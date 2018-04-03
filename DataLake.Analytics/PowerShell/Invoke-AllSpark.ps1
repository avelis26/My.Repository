# Version  --  v0.9.0.2
#######################################################################################################
# Add database maintance feature
#######################################################################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $false)][switch]$scale,
	[parameter(Mandatory = $false)][switch]$exit
)
#######################################################################################################
$databaseSubId = 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$userName = 'gpink003'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$opsLogRootPath = 'H:\Ops_Log\ETL\AllSpark\'
$emailList = 'graham.pinkston@ansira.com'
$AddEjDataToSqlScript = 'C:\Scripts\PowerShell\Add-EjDataToSql.ps1'
$AddEjDataToHadoopScript = 'C:\Scripts\PowerShell\Add-EjDataToHadoop.ps1'
#######################################################################################################
# Init
[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
If ($policy -ne 'TrustAllCertsPolicy') {
	Add-Type -TypeDefinition @"
		using System.Net;
		using System.Security.Cryptography.X509Certificates;
		public class TrustAllCertsPolicy : ICertificatePolicy {
			public bool CheckValidationResult(
				ServicePoint srvPoint, X509Certificate certificate,
				WebRequest request, int certificateProblem
			) {
				return true;
			}
		}
"@
	[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}
Function New-TimeStamp {
	[CmdletBinding()]
	Param(
		[switch]$forFileName
	)
	$now = Get-Date -ErrorAction Stop
	$day = $now.day.ToString("00")
	$month = $now.month.ToString("00")
	$year = $now.year.ToString("0000")
	$hour = $now.hour.ToString("00")
	$minute = $now.minute.ToString("00")
	$second = $now.second.ToString("00")
	If ($forFileName -eq $true) {
		$timeStamp = $year + $month + $day + '_' + $hour + $minute + $second
	}
	Else {
		$timeStamp = $year + '/' + $month + '/' + $day + '-' + $hour + ':' + $minute + ':' + $second
	}
	Return $timeStamp
}
Function Set-AzureSqlDatabaseSize {
	[CmdletBinding()]
	Param(
		[string]$size
	)
	$params = @{
		ResourceGroupName = 'CRM-TEST-RG';
		ServerName = 'mstestsqldw';
		DatabaseName = '7ELE';
		Edition = 'Premium';
		RequestedServiceObjectiveName = $size;
		ErrorAction = 'Stop';
	}
	Set-AzureRmSqlDatabase @params
}
Add-Content -Value "$(New-TimeStamp -forFileName) :: $($MyInvocation.MyCommand.Name) :: Start" -Path 'H:\Ops_Log\bitc.log'
Try {
	$opsLog = $opsLogRootPath + "$(New-TimeStamp -forFileName)_AllSpark.log"
	If ($scale.IsPresent -eq $true) {
		$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
		$message = "Logging into Azure..."
		Write-Verbose -Message $message
		Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
		Login-AzureRmAccount -Credential $credential -Subscription $databaseSubId -Force -ErrorAction Stop
		$size = 'P15'
		$message = "$(Create-TimeStamp)  Scaling database to $size..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop	
		Set-AzureSqlDatabaseSize -size $size
		$message = "$(Create-TimeStamp)  Database scaling successful."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	}
# Data to SQL - Store
	$EtlResult = Invoke-Expression -Command "$AddEjDataToSqlScript -report 's' -autoDate" -ErrorAction Stop
	If ($EtlResult -ne 0) {
		$errorParams = @{
			Message = "$AddEjDataToSqlScript Failed!!!";
			ErrorId = "01";
			RecommendedAction = "Fix it.";
			ErrorAction = "Stop";
		}
		Write-Error @errorParams
	}
# Data to SQL - CEO
	$EtlResult = Invoke-Expression -Command "$AddEjDataToSqlScript -report 'c' -autoDate" -ErrorAction Stop
	If ($EtlResult -ne 0) {
		$errorParams = @{
			Message = "$AddEjDataToSqlScript Failed!!!";
			ErrorId = "02";
			RecommendedAction = "Fix it.";
			ErrorAction = "Stop";
		}
		Write-Error @errorParams
	}
# Data to Hadoop
	$EtlResult = Invoke-Expression -Command "$AddEjDataToHadoopScript -autoDate" -ErrorAction Stop
	If ($EtlResult -ne 0) {
		$errorParams = @{
			Message = "$AddEjDataToHadoopScript Failed!!!";
			ErrorId = "03";
			RecommendedAction = "Fix it.";
			ErrorAction = "Stop";
		}
		Write-Error @errorParams
	}
# Remove Old Data

# Rebuild Indexs and stats

# Exit
	If ($scale.IsPresent -eq $true) {
		$size = 'P1'
		Write-Output "Scaling database to size $size..."
		Add-Content -Value "$(Create-TimeStamp)  Scaling database to size $size..." -Path $opsLog -ErrorAction Stop
		Set-AzureSqlDatabaseSize -size $size -ErrorAction Stop
	}
	$exitCode = 0
}
Catch {
	Add-Content -Value $($Error[0].CategoryInfo.Activity) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.InnerExceptionMessage) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].RecommendedAction) -Path $opsLog -ErrorAction Stop
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "AllSpark: Failed!!!";
		Body = @"
			<font face='consolas'>
			Something bad happened!!!<br><br>
			$($Error[0].CategoryInfo.Activity)<br>
			$($Error[0].Exception.Message)<br>
			$($Error[0].Exception.InnerExceptionMessage)<br>
			$($Error[0].RecommendedAction)<br>
			$($Error[0].Message)<br>
			</font>
"@
	}
	Send-MailMessage @params
	$exitCode = 1
}
Finally {
	Add-Content -Value "$(New-TimeStamp -forFileName) :: $($MyInvocation.MyCommand.Name) :: End" -Path 'H:\Ops_Log\bitc.log'
	If ($exit.IsPresent -eq $true) {	
		[Environment]::Exit($exitCode)	
	}
}

# Version  --  v1.0.0.0
######################################################
######################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $true)][string]$size
)
[string[]]$emailList = `
	'graham.pinkston@ansira.com', `
	'mayank.minawat@ansira.com', `
	'tyler.bailey@ansira.com'
$userName = 'gpink003'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$sqlServer = 'mstestsqldw.database.windows.net'
$database = '7ELE'
$sqlUser = 'sqladmin'
$databaseSubId = 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$sqlPass = Get-Content -Path 'C:\Scripts\Secrets\sqlAdmin.txt' -ErrorAction Stop
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
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
Try {
# Init
	$scriptStartTime = Get-Date
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
	$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
	If ($policy -ne 'TrustAllCertsPolicy') {
		add-type @"
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
	Import-Module SqlServer -ErrorAction Stop
	Import-Module AzureRM -ErrorAction Stop
	Login-AzureRmAccount -Credential $credential -Subscription $databaseSubId -Force -ErrorAction Stop
# Scale to p15
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: Scaling Database to $size";
		Body = "$(New-TimeStamp -forFileName)"
	}
	Send-MailMessage @params
	$params = @{
		ResourceGroupName = 'CRM-TEST-RG';
		ServerName = 'mstestsqldw';
		DatabaseName = '7ELE';
		Edition = 'Premium';
		RequestedServiceObjectiveName = $size;
	}
	Set-AzureRmSqlDatabase @params
# Shrik Log
	Start-Sleep -Seconds 420
	$params = @{
		query = "EXECUTE [dbo].[usp_Shrink_Log]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @params
# Delete Old Data
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: Deleting Old Data";
		Body = "$(New-TimeStamp -forFileName)"
	}
	Send-MailMessage @params
	$params = @{
		query = "EXECUTE [dbo].[usp_Delete_Old_Data]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @params
# Update Statistics
	Start-Sleep -Seconds 420
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: Updating Database Statistics";
		Body = "$(New-TimeStamp -forFileName)"
	}
	Send-MailMessage @params
	$params = @{
		query = "EXECUTE [dbo].[usp_Update_Statistics]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @params	
# Report
	$scriptEndTime = Get-Date
	$totTime = New-TimeSpan -Start $scriptStartTime -End $scriptEndTime
	$message = "Total Run Time----:  $($totTime.Hours.ToString("00")) h $($totTime.Minutes.ToString("00")) m $($totTime.Seconds.ToString("00")) s"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: Database Ready For Store Report";
		Body = $message;
	}
	Send-MailMessage @params
	$exitCode = 0
}
Catch {
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: ::ERROR:: Store Report Prep Failed!!!";
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
	[Environment]::Exit($exitCode)
}
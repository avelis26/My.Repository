# Version  --  v1.1.3.2
#######################################################################################################
# Add database maintance feature
#######################################################################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $false)][switch]$scaleUp,
	[parameter(Mandatory = $false)][switch]$scaleDown,
	[parameter(Mandatory = $false)][switch]$maintenance,
	[parameter(Mandatory = $false)][switch]$scheduled,
	[parameter(Mandatory = $false)][switch]$exit
)
#######################################################################################################
Add-Content -Value "$(Get-Date -Format 'yyyyMMdd_HHmmss') :: $($MyInvocation.MyCommand.Name) :: Start" -Path '\\MS-SSW-CRM-BITC\Data\Ops_Log\bitc.log'
$databaseSubId = 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$userName = 'gpink003'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$opsLogRootPath = '\\MS-SSW-CRM-BITC\Data\Ops_Log\AllSpark\'
$emailList = 'graham.pinkston@ansira.com'
$AddEjDataToSqlScript = 'C:\Scripts\PowerShell\Add-EjDataToSql.ps1'
$AddEjDataToHadoopScript = 'C:\Scripts\PowerShell\Add-EjDataToHadoop.ps1'
$sqlServer = 'mstestsqldw.database.windows.net'
$database = '7ELE'
$sqlUser = 'sqladmin'
$sqlPass = Get-Content -Path 'C:\Scripts\Secrets\sqlAdmin.txt' -ErrorAction Stop
#######################################################################################################
# Init
Function New-TimeStamp {
	[CmdletBinding()]
	Param(
		[switch]$forFileName
	)
	If ($forFileName -eq $true) {
		$timeStamp = Get-Date -Format 'yyyyMMdd_HHmmss' -ErrorAction Stop
	}
	Else {
		$timeStamp = Get-Date -Format 'yyyy/MM/dd_HH:mm:ss' -ErrorAction Stop
	}
	Return $timeStamp
}
Function Set-AzureSqlDatabaseSize {
	[CmdletBinding()]
	Param(
		[string]$size
	)
	Set-AzureRmContext -Subscription $databaseSubId -ErrorAction Stop
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
If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
	New-Item -Path $opsLogRootPath -ItemType Directory -ErrorAction Stop -Force > $null
}
$opsLog = $opsLogRootPath + "$(New-TimeStamp -forFileName)_AllSpark.log"
Add-Content -Value "$(New-TimeStamp)  Importing AzureRM and SQL Server modules as well as custom functions..." -Path $opsLog -ErrorAction Stop
Import-Module SqlServer -ErrorAction Stop
Import-Module AzureRM -ErrorAction Stop
. $($PSScriptRoot + '\Set-SslCertPolicy.ps1')
Try {
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
	$currentUser = [Environment]::UserName.ToString()
	Add-Content -Value "$(New-TimeStamp)  Current User: $currentUser" -Path $opsLog -ErrorAction Stop
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
	If ($scaleUp.IsPresent -eq $true) {
		$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
		$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
		Add-Content -Value "$(New-TimeStamp)  SSL Policy: $policy" -Path $opsLog -ErrorAction Stop
		Set-SslCertPolicy
		$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
		Add-Content -Value "$(New-TimeStamp)  SSL Policy: $policy" -Path $opsLog -ErrorAction Stop
		$message = "Logging into Azure..."
		Write-Verbose -Message $message
		Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
		Connect-AzureRmAccount -Credential $credential -Subscription $databaseSubId -Force -ErrorAction Stop
		$size = 'P15'
		$message = "$(New-TimeStamp)  Scaling database to $size..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop	
		Set-AzureSqlDatabaseSize -size $size
		$message = "$(New-TimeStamp)  Database scaling successful."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	}
# Data to SQL - Store
	If ($scheduled.IsPresent -eq $true) {
		$continue = 0
		$startTime = Get-Date -Hour 5 -Minute 50 -Second 0
		While ($continue -ne 1) {
			$now = Get-Date
			If ($now.TimeOfDay -gt $startTime.TimeOfDay) {
				$continue = 1
			}
			Else {
				Start-Sleep -Seconds 1
			}
		} # while
	} # if
	$start = Get-Date
	$message = "$(New-TimeStamp)  Adding store EJ data to SQL..."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	$EtlResult = Invoke-Expression -Command "$AddEjDataToSqlScript -report 's' -autoDate" -ErrorAction Stop
	If ($EtlResult[$EtlResult.Count - 1] -ne 0) {
		$errorParams = @{
			Message = "$AddEjDataToSqlScript Failed!!!";
			ErrorId = "01";
			RecommendedAction = "Fix it.";
			ErrorAction = "Stop";
		}
		Write-Error @errorParams
	}
	$end = Get-Date
	$run = New-TimeSpan -Start $start -End $end
	$message = "$(New-TimeStamp)  Store EJ data added to SQL successfully."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	$message = "$(New-TimeStamp)  Run Time: $($run.Hours.ToString('00')) h $($run.Minutes.ToString('00')) m $($run.Seconds.ToString('00')) s"
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
# Data to SQL - CEO
	$start = Get-Date
	$message = "$(New-TimeStamp)  Adding CEO EJ data to SQL..."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	$EtlResult = Invoke-Expression -Command "$AddEjDataToSqlScript -report 'c' -autoDate" -ErrorAction Stop
	If ($EtlResult[$EtlResult.Count - 1] -ne 0) {
		$errorParams = @{
			Message = "$AddEjDataToSqlScript Failed!!!";
			ErrorId = "02";
			RecommendedAction = "Fix it.";
			ErrorAction = "Stop";
		}
		Write-Error @errorParams
	}
	$end = Get-Date
	$run = New-TimeSpan -Start $start -End $end
	$message = "$(New-TimeStamp)  CEO EJ data added to SQL successfully."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	$message = "$(New-TimeStamp)  Run Time: $($run.Hours.ToString('00')) h $($run.Minutes.ToString('00')) m $($run.Seconds.ToString('00')) s"
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
# Data to Hadoop
	$start = Get-Date
	$message = "$(New-TimeStamp)  Adding EJ data to Hadoop..."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	$EtlResult = Invoke-Expression -Command "$AddEjDataToHadoopScript -autoDate" -ErrorAction Stop
	If ($EtlResult[$EtlResult.Count - 1] -ne 0) {
		$errorParams = @{
			Message = "$AddEjDataToHadoopScript Failed!!!";
			ErrorId = "03";
			RecommendedAction = "Fix it.";
			ErrorAction = "Stop";
		}
		Write-Error @errorParams
	}
	$end = Get-Date
	$run = New-TimeSpan -Start $start -End $end
	$message = "$(New-TimeStamp)  EJ data added to Hadoop successfully."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	$message = "$(New-TimeStamp)  Run Time: $($run.Hours.ToString('00')) h $($run.Minutes.ToString('00')) m $($run.Seconds.ToString('00')) s"
	Write-Output $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
# Remove Old Data
	If ($maintenance.IsPresent -eq $true) {
		$message = "$(New-TimeStamp)  Removing old data from store database..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop	
		$query = "EXECUTE [dbo].[usp_Delete_Old_Data]"
		$sqlTruncateParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlTruncateParams
		$message = "$(New-TimeStamp)  Removing old data from CEO database..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop	
		$query = "EXECUTE [dbo].[usp_Delete_Old_Data_CEO]"
		$sqlTruncateParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlTruncateParams
		$message = "$(New-TimeStamp)  Old data removed successfully."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	} # if
# Rebuild SQL Indexs
	If ($maintenance.IsPresent -eq $true) {
		$message = "$(New-TimeStamp)  Rebuilding SQL indexes..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop	
		$query = "EXECUTE [dbo].[usp_Rebuild_Indexs]"
		$sqlTruncateParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlTruncateParams
		$message = "$(New-TimeStamp)  Indexes rebuilt successfully."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	} # if
# Update SQL Stats
	If ($maintenance.IsPresent -eq $true) {
		$message = "$(New-TimeStamp)  Updating SQL stats..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop	
		$query = "EXECUTE [dbo].[usp_Update_Statistics]"
		$sqlTruncateParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlTruncateParams
		$message = "$(New-TimeStamp)  SQL stats updated successfully."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	} # if
# Exit
	If ($scaleDown.IsPresent -eq $true) {
		$size = 'P1'
		Write-Output "Scaling database to size $size..."
		Add-Content -Value "$(New-TimeStamp)  Scaling database to size $size..." -Path $opsLog -ErrorAction Stop
		Set-AzureSqlDatabaseSize -size $size -ErrorAction Stop
	}
	$exitCode = 0
}
Catch {
	Add-Content -Value $($_.Exception.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.Exception.InnerException.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.Exception.InnerException.InnerException.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.CategoryInfo.Activity) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.CategoryInfo.Reason) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.InvocationInfo.Line) -Path $opsLog -ErrorAction Stop
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
			$($_.Exception.Message)<br>
			$($_.Exception.InnerException.Message)<br>
			$($_.Exception.InnerException.InnerException.Message)<br>
			$($_.CategoryInfo.Activity)<br>
			$($_.CategoryInfo.Reason)<br>
			$($_.InvocationInfo.Line)<br>
			</font>
"@
	}
	Send-MailMessage @params
	$exitCode = 1
}
Finally {
	Add-Content -Value "$(New-TimeStamp -forFileName) :: $($MyInvocation.MyCommand.Name) :: End" -Path '\\MS-SSW-CRM-BITC\Data\Ops_Log\bitc.log'
	Add-Content -Value "----------------------------------------------------------------------------------" -Path '\\MS-SSW-CRM-BITC\Data\Ops_Log\bitc.log'
	If ($exit.IsPresent -eq $true) {	
		[Environment]::Exit($exitCode)	
	}
}

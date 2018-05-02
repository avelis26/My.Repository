# Init  --  v1.0.1.1
##########################################
$opsAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'Britten.Morse@Ansira.com'
$finalAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'megan.morace@ansira.com', 'Anna.Behle@Ansira.com', 'Ben.Smith@Ansira.com', 'Britten.Morse@Ansira.com'
##########################################
$opsLogRoot = '\\MS-SSW-CRM-BITC\Data\Ops_Log\Report\CEO\'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$database = '7ELE'
$sqlUser = 'sqladmin'
$sqlPass = Get-Content -Path 'C:\Scripts\Secrets\sqlAdmin.txt' -ErrorAction Stop
$sqlServer = 'MS-SSW-CRM-SQL'
##########################################
$currentYearDate = $($(Get-Date).AddDays(-1).Year.ToString('0000')) + '-' + $($(Get-Date).AddDays(-1).Month.ToString('00')) + '-' + $($(Get-Date).AddDays(-1).Day.ToString('00'))
If ($(Test-Path -Path $opsLogRoot) -eq $false) {
	New-Item -Path $opsLogRoot -ItemType Directory -Force
}
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
$opsLog = $opsLogRoot + "BITC_$($currentYearDate)_" + $(New-TimeStamp -forFileName) + "_CEO_Report.log"
Function Execute-ShrinkLogFile {
	$message = "Shrinking database log file..."
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	$sqlShrinkParams = @{
		query = "EXECUTE [dbo].[usp_Shrink_Log]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$tryAgain = 1
	While ($tryAgain -ne 'continue') {
		Try {
			Invoke-Sqlcmd @sqlShrinkParams
			$tryAgain = 'continue'
			$message = "Database log file shrunk successfully."
			Write-Output $message
			Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
		}
		Catch {
			If ($tryAgain -gt 4) {
				Write-Error -Exception $($Error[0].Exception) -ErrorAction Continue
				Break
			}
			$message = "Shrinking database log file failed!!! Trying again..."
			Write-Output $message
			Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
			Start-Sleep -Seconds 60
			$tryAgain++
		}
	}
}
Function Execute-CeoAggregation {
	[CmdletBinding()]
	Param(
		[string]$query,
		[string]$currentYearDate,
		[string]$lastYearDate,
		[string]$step,
		[string]$opsLog

	)
	$startTime = Get-Date
	$startTimeText = $(New-TimeStamp -forFileName)
	$message = "Starting step $step of 5 for CEO report aggregation..."
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(New-TimeStamp)  $query" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: CEO Report: $step of 5: Dates: $currentYearDate | $lastYearDate";
		Body = @"
			<font face='courier'>
			$message<br>
			Start Time: $startTimeText<br>
			$query<br>
			</font>
"@
	}
	Send-MailMessage @params
	$sqlParams = @{
		query = $query;
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @sqlParams
	$message = "Step $step of 5 for CEO report aggregation completed successfully."
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	$endTime = Get-Date
	$endTimeText = $(New-TimeStamp -forFileName)
	$spanObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time--------:  $startTimeText"
	$message2 = "End Time----------:  $endTimeText"
	$message3 = "Total Run Time----:  $($spanObj.Hours.ToString("00")) h $($spanObj.Minutes.ToString("00")) m $($spanObj.Seconds.ToString("00")) s"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: CEO Report: $step of 5: Dates: $currentYearDate | $lastYearDate";
		Body = @"
			<font face='courier'>
			$message<br>
			$message1<br>
			$message2<br>
			$message3<br>
			<br>
			</font>
"@
	}
	Send-MailMessage @params
	Write-Output $message3
	Add-Content -Value "$(New-TimeStamp)  $message3" -Path $opsLog
	Add-Content -Value "---------------------------------------------------------------------------------------------------------------------------------------" -Path $opsLog
}
# Init
Add-Content -Value "$(New-TimeStamp)  Importing SQL module and custom functions..." -Path $opsLog
Import-Module SqlServer -ErrorAction Stop
. $($PSScriptRoot + '\Set-SslCertPolicy.ps1')
Add-Content -Value "$(New-TimeStamp)  Getting comp date..." -Path $opsLog
$query = 'SELECT [comp_dt] FROM [dbo].[RPTS_Calendar] WHERE [calendar_dt] = DATEADD(day, -1, CAST(GETDATE() AS DATE))'
$sqlParams = @{
	query = $query;
	ServerInstance = $sqlServer;
	Database = $database;
	Username = $sqlUser;
	Password = $sqlPass;
	QueryTimeout = 0;
	ErrorAction = 'Stop';
}
$comp_dt = Invoke-Sqlcmd @sqlParams
$comp_yr = $comp_dt.comp_dt.Year.ToString('0000')
$comp_mo = $comp_dt.comp_dt.Month.ToString('00')
$comp_da = $comp_dt.comp_dt.Day.ToString('00')
$lastYearDate = $comp_yr + '-' + $comp_mo + '-' + $comp_da
$scriptStartTime = Get-Date
$scriptStartTimeText = $(New-TimeStamp -forFileName)
$currentYearDateObj = Get-Date -Date $currentYearDate
$lastYearDateObj = Get-Date -Date $lastYearDate
Write-Host '********************************************************************' -ForegroundColor Magenta
Write-Host "Current Year    ::  $currentYearDate"
Write-Host "Last Year       ::  $lastYearDate"
Write-Host '********************************************************************' -ForegroundColor Magenta
Write-Host "Starting script in 5..."
Start-Sleep -Seconds 1
Write-Host "4..."
Start-Sleep -Seconds 1
Write-Host "3..."
Start-Sleep -Seconds 1
Write-Host "2..."
Start-Sleep -Seconds 1
Write-Host "1..."
Start-Sleep -Seconds 1
Try {
	If ($lastYearDateObj.Year -eq $(Get-Date).Year) {
		throw [System.ArgumentOutOfRangeException] "Years should not be the same!!!"
	}
	$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
	Add-Content -Value "$(New-TimeStamp)  SSL Policy: $policy" -Path $opsLog -ErrorAction Stop
	Set-SslCertPolicy
	$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
	Add-Content -Value "$(New-TimeStamp)  SSL Policy: $policy" -Path $opsLog -ErrorAction Stop
# Step 0 of 5: Update local store and product tables
	$startTime = Get-Date
	$startTimeText = $(New-TimeStamp -forFileName)
	$query = "EXECUTE [dbo].[usp_Copy_Store_Product_Locally]"
	$message = "Updateing store and product tables..."
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(New-TimeStamp)  $query" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: CEO Report: 0 of 5: Dates: $currentYearDate | $lastYearDate";
		Body = @"
			<font face='courier'>
			$message<br>
			Start Time: $startTimeText<br>
			$query<br>
			</font>
"@
	}
	Send-MailMessage @params
	$sqlParams = @{
		query = $query;
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @sqlParams
	$message = "Store And Product Tables Updated Successfully"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	$endTime = Get-Date
	$endTimeText = $(New-TimeStamp -forFileName)
	$0spanObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time--------:  $startTimeText"
	$message2 = "End Time----------:  $endTimeText"
	$message3 = "Total Run Time----:  $($0spanObj.Hours.ToString("00")) h $($0spanObj.Minutes.ToString("00")) m $($0spanObj.Seconds.ToString("00")) s"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: CEO Report: 0 of 5: Dates: $currentYearDate | $lastYearDate";
		Body = @"
			<font face='courier'>
			$message<br>
			$message1<br>
			$message2<br>
			$message3<br>
			<br>
			</font>
"@
	}
	Send-MailMessage @params
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 1 of 5: [dbo].[usp_CeoReport_1_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_1_5] @curr_yr_date = '$currentYearDate'"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '1' -opsLog $opsLog
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 2 of 5: [dbo].[usp_CeoReport_2_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_2_5] @last_yr_date = '$lastYearDate'"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '2' -opsLog $opsLog
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 3 of 5: [dbo].[usp_CeoReport_3_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_3_5]"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '3' -opsLog $opsLog
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 4 of 5: [dbo].[usp_CeoReport_4_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_4_5]"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '4' -opsLog $opsLog
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 5 of 5: [dbo].[usp_CeoReport_5_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_5_5]"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '5' -opsLog $opsLog
	Start-Sleep -Seconds 2
# Report
	$scriptEndTime = Get-Date
	$scriptEndTimeText = $(New-TimeStamp -forFileName)
	$totTime = New-TimeSpan -Start $scriptStartTime -End $scriptEndTime
	$message0 = "Start Time--------:  $scriptStartTimeText"
	$message1 = "End Time----------:  $scriptEndTimeText"
	$message2 = "Total Run Time----:  $($totTime.Hours.ToString("00")) h $($totTime.Minutes.ToString("00")) m $($totTime.Seconds.ToString("00")) s"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $finalAddr;
		BodyAsHtml = $true;
		Subject = "BITC: CEO Report: Ready: Dates: $currentYearDate | $lastYearDate";
		Body = @"
			Ben (or Anna), CEO report data is aggregated and ready.<br>
			<br>
			<font face='courier'>
			$message0<br>
			$message1<br>
			$message2<br>
			</font>
"@
	}
	Send-MailMessage @params
	$exitCode = 0
}
Catch {
	Start-Sleep -Seconds 2
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
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: CEO Report: FAILED: Dates: $currentYearDate | $lastYearDate";
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
	Get-Job | Remove-Job
}
# Init  --  v0.9.0.1
##########################################
$opsAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
$finalAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com', 'megan.morace@ansira.com', 'Anna.Behle@Ansira.com', 'Ben.Smith@Ansira.com'
##########################################
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$database = '7ELE'
$sqlUser = 'sqladmin'
$sqlPass = 'Password20!7!'
$sqlServer = 'mstestsqldw.database.windows.net'
##########################################
Function New-TimeStamp {
	[CmdletBinding()]
	Param(
		[switch]$forFileName
	)
	$now = Get-Date
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
	Invoke-Sqlcmd @sqlShrinkParams
	$message = "Database log file shrunk successfully."
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
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
}
# Init
Import-Module SqlServer -ErrorAction Stop
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
$currentYearDate = $($(Get-Date).AddDays(-1).Year.ToString('0000')) + '-' + $($(Get-Date).AddDays(-1).Month.ToString('00')) + '-' + $($(Get-Date).AddDays(-1).Day.ToString('00'))
$scriptStartTime = Get-Date
$scriptStartTimeText = $(New-TimeStamp -forFileName)
$opsLog = "H:\Ops_Log\Report\BITC_$($currentYearDate)_" + $(New-TimeStamp -forFileName) + "_CEO_Report.log"
[DateTime]$currentYearDateObj = Get-Date -Date $currentYearDate
[DateTime]$lastYearDateObj = Get-Date -Date $lastYearDate
[string]$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
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
	Start-Sleep -Seconds 420
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 1 of 5: [dbo].[usp_CeoReport_1_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_1_5] @curr_yr_date = '$currentYearDate'"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '1' -opsLog $opsLog
	Start-Sleep -Seconds 420
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 2 of 5: [dbo].[usp_CeoReport_2_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_2_5] @last_yr_date = '$lastYearDate'"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '2' -opsLog $opsLog
	Start-Sleep -Seconds 420
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 3 of 5: [dbo].[usp_CeoReport_3_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_3_5]"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '3' -opsLog $opsLog
	Start-Sleep -Seconds 420
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
# Step 4 of 5: [dbo].[usp_CeoReport_4_5]
	$sqlQuery = "EXECUTE [dbo].[usp_CeoReport_4_5]"
	Execute-CeoAggregation -query $sqlQuery -currentYearDate $currentYearDate -lastYearDate $lastYearDate -step '4' -opsLog $opsLog
	Start-Sleep -Seconds 420
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
	Add-Content -Value $($Error[0].CategoryInfo.Activity) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.InnerExceptionMessage) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].RecommendedAction) -Path $opsLog -ErrorAction Stop
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
	Get-Job | Remove-Job
	[Environment]::Exit($exitCode)
}
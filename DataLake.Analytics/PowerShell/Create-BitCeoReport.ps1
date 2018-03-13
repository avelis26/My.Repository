# Init  --  v0.0.0.2
##########################################
$currentYearDate = '2018-03-12'
$lastYearDate = '2017-03-13'
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
$scriptStartTime = Get-Date
$scriptStartTimeText = $(Create-TimeStamp -forFileName)
##########################################
## select comp_dt
## from [dbo].[RPTS_Calendar]
## where calendar_dt = dateadd(dd,-1,cast(getdate() as date))
##########################################
Function Create-TimeStamp {
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
Function Confirm-Run {
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Current Year    ::  $currentYearDate"
	Write-Host "Last Year       ::  $lastYearDate"
	Write-Host '********************************************************************' -ForegroundColor Magenta
    $answer = Read-Host -Prompt "Are you sure you want to start? (y/n)"
	Return $answer
}
Function Execute-LocalStoreAndProduct {
	$startTime = Get-Date
	$startTimeText = $(Create-TimeStamp -forFileName)
	$query = "EXECUTE [dbo].[usp_Copy_Store_Product_Locally]"
	Add-Content -Value "$(Create-TimeStamp)  Updateing store and product tables..." -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $query" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: CEO Report: 0 of 1: Dates: $currentYearDate | $lastYearDate";
		Body = @"
			<font face='courier'>
			Start Time: $startTime<br>
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
	$result = Invoke-Sqlcmd @sqlParams
	$message = "Store And Product Tables Updated Successfully"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $result" -Path $opsLog
	$endTime = Get-Date
	$endTimeText = $(Create-TimeStamp -forFileName)
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
		Subject = "BITC: CEO Report: 0 of 1: Dates: $currentYearDate | $lastYearDate";
		Body = @"
			<font face='courier'>
			$message<br>
			$result<br>
			$message1<br>
			$message2<br>
			$message3<br>
			<br>
			</font>
"@
	}
	Send-MailMessage @params
}
Function Execute-ShrinkLogFile {
	$message = "Shrinking database log file..."
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
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
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
}
# Init
$opsLog = "H:\Ops_Log\BITC_$($currentYearDate)_" + $(Create-TimeStamp -forFileName) + "_CEO_Report.log"
[DateTime]$currentYearDateObj = Get-Date -Date $currentYearDate
[DateTime]$lastYearDateObj = Get-Date -Date $lastYearDate
[string]$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
If ($(Confirm-Run) -eq 'y') {
	Try {
		If ($lastYearDateObj.Year -eq $(Get-Date).Year) {
			throw [System.ArgumentOutOfRangeException] "Years should not be the same!!!"
		}
		Import-Module SqlServer -ErrorAction Stop
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
		# Step 0: Update local store and product tables
		Execute-LocalStoreAndProduct
		Start-Sleep -Seconds 420
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Step 1: Run ceo_agg
		$query = "EXECUTE [dbo].[usp_CEO_Report] @curr_yr_date = '$currentYearDate', @last_yr_date = '$lastYearDate'"
		Add-Content -Value "$(Create-TimeStamp)  Starting CEO aggregate query..." -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $query" -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $opsAddr;
			BodyAsHtml = $true;
			Subject = "BITC: CEO Report: 1 of 1: Dates: $currentYearDate | $lastYearDate";
			Body = @"
				<font face='courier'>
				Start Time: $startTime<br>
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
		$ceoResult = Invoke-Sqlcmd @sqlParams
		# Report
		$scriptEndTime = Get-Date
		$scriptEndTimeText = $(Create-TimeStamp -forFileName)
		$totTime = New-TimeSpan -Start $scriptStartTime -End $scriptEndTime
		$message0 = "Start Time--------:  $scriptStartTimeText"
		$message1 = "End Time----------:  $scriptEndTimeText"
		$message2 = "Total Run Time----:  $($spanObj.Hours.ToString("00")) h $($spanObj.Minutes.ToString("00")) m $($spanObj.Seconds.ToString("00")) s"
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
	}
	Catch [System.ArgumentOutOfRangeException] {
		Write-Error -Exception $Error[0].Exception
	}
	Catch {
		Start-Sleep -Seconds 2
		Add-Content -Value "$(Create-TimeStamp)  BITC: CEO Report: FAILED:" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $ceoResult" -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $opsAddr;
			BodyAsHtml = $true;
			Subject = "BITC: CEO Report: FAILED: Dates: $currentYearDate | $lastYearDate";
			Body = @"
				<font face='courier'>
				Something bad happened!!!<br>
				$ceoResult<br>
				</font>
"@
		}
		Send-MailMessage @params
	}
}

# Init  --  v1.2.0.5
##########################################
##########################################
$global:end = '2018-02-25'
##########################################
##########################################
$global:opsLog = "H:\Ops_Log\BITC_$($end)_Store_Report.log"
$global:opsAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
$global:finalAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com', 'megan.morace@ansira.com', 'Anna.Behle@Ansira.com', 'Ben.Smith@Ansira.com'
##########################################
$global:smtpServer = '10.128.1.125'
$global:port = 25
$global:fromAddr = 'noreply@7-11.com'
$global:database = '7ELE'
$global:sqlUser = 'sqladmin'
$global:sqlPass = 'Password20!7!'
$global:sqlServer = 'mstestsqldw.database.windows.net'
##########################################
Function Create-TimeStamp {
	$now = Get-Date
	$day = $now.day.ToString("00")
	$month = $now.month.ToString("00")
	$year = $now.year.ToString("0000")
	$hour = $now.hour.ToString("00")
	$minute = $now.minute.ToString("00")
	$second = $now.second.ToString("00")
	$timeStamp = $year + '/' + $month + '/' + $day + '-' + $hour + ':' + $minute + ':' + $second
	Return $timeStamp
}
Function Confirm-Run {
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Start Date    ::  $start"
	Write-Host "End Date      ::  $end"
	Write-Host '********************************************************************' -ForegroundColor Magenta
    $answer = Read-Host -Prompt "Are you sure you want to start? (y/n)"
	Return $answer
}
Function Execute-AggregateOneOne {
	$startTime = Get-Date
	$message = "Store Report: 1 of 8 For Date Range: $start - $end"
	$query = "EXECUTE [dbo].[usp_Aggregate_1_1] @StartDate = '$start', @EndDate = '$end'"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $query" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = @"
<font face='courier'>
Start Time: $(Get-Date)<br>
$query<br>
</font>
"@
	}
	Send-MailMessage @params
	$sqlAggOneOneParams = @{
		query = "EXECUTE [dbo].[usp_Aggregate_1_1] @StartDate = '$start', @EndDate = '$end'";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$global:aggOneOneResult = Invoke-Sqlcmd @sqlAggOneOneParams
	$message = "Store Report: 1 of 8 For Date Range: $start - $end Completed Successfully"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $aggOneOneResult" -Path $opsLog
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = @"
<font face='courier'>
$message1<br>
$message2<br>
$message3<br>
<br>
</font>
"@
	}
	Send-MailMessage @params
}
Function Execute-AggregateOneTwo {
	$startTime = Get-Date
	$message = "Starting Aggregate 1-2 For Date Range: $start - $end"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = "Start Time: $(Get-Date)"
	}
	Send-MailMessage @params
	$sqlAggOneTwoParams = @{
		query = "EXECUTE [dbo].[usp_Aggregate_1_2]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$global:aggOneTwoResult = Invoke-Sqlcmd @sqlAggOneTwoParams
	$message = "Aggregate 1-2 For Date Range: $start - $end Completed Successfully"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $aggOneTwoResult" -Path $opsLog
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = @"
<font face='courier'>
$message1<br>
$message2<br>
$message3<br>
<br>
</font>
"@
	}
	Send-MailMessage @params
}
Function Execute-AggregateOneThree {
	[CmdletBinding()]
	Param(
		[string]$dateStart,
		[string]$dateEnd
	)
	$startTime = Get-Date
	$message = "Starting Aggregate 1-3 For Date Range: $dateStart - $dateEnd"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = "Start Time: $(Get-Date)"
	}
	Send-MailMessage @params
	$sqlAggOneThreeParams = @{
		query = "EXECUTE [dbo].[usp_Aggregate_1_3] @StartDate = '$dateStart', @EndDate = '$dateEnd'";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$global:aggOneThreeResult = Invoke-Sqlcmd @sqlAggOneThreeParams
	$message = "Aggregate 1-3 For Date Range: $dateStart - $dateEnd Completed Successfully"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $aggOneThreeResult" -Path $opsLog
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = @"
<font face='courier'>
The results have been loaded into:<br>
<br>
Server--------------:  [MsTestSqlDw.Database.Windows.Net]<br>
Database------------:  [7ELE]<br>
Tables--------------:  [dbo].[Agg1_DaypartAggregate]<br>
$message1<br>
$message2<br>
$message3<br>
<br>
</font>
"@
	}
	Send-MailMessage @params
}
Function Execute-AggregateTwo {
	$startTime = Get-Date
	$message = "Starting Aggregate Two For Date Range: $start - $end"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = "Start Time: $(Get-Date)"
	}
	Send-MailMessage @params
	$sqlAggTwoParams = @{
		query = "EXECUTE [dbo].[usp_Aggregate_Two]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$aggTwoResult = Invoke-Sqlcmd @sqlAggTwoParams
	$message = "Aggregate Two For Date Range: $start - $end Completed Successfully"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $aggTwoResult" -Path $opsLog
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = @"
<font face='courier'>
The results have been loaded into:<br>
<br>
Server--------------:  [MsTestSqlDw.Database.Windows.Net]<br>
Database------------:  [7ELE]<br>
Tables--------------:  [dbo].[Agg2_StoreTxnItems]<br>
$message1<br>
$message2<br>
$message3<br>
<br>
</font>
"@
	}
	Send-MailMessage @params
}
Function Execute-LocalStoreAndProduct {
	$startTime = Get-Date
	$message = "Updating Local Store And Product Tables"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = "Start Time: $(Get-Date)"
	}
	Send-MailMessage @params
	$sqlSandPParams = @{
		query = "EXECUTE [dbo].[usp_Copy_Store_Product_Locally]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$result = Invoke-Sqlcmd @sqlSandPParams
	$message = "Store And Product Tables Updated Successfully"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(Create-TimeStamp)  $result" -Path $opsLog
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $opsAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = @"
<font face='courier'>
The results have been loaded into:<br>
<br>
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
[DateTime]$endDate = Get-Date -Date $end
[DateTime]$startDate = $endDate.AddDays(-29)
[string]$start = $($startDate.year.ToString("0000")) + '-' + $($startDate.month.ToString("00")) + '-' + $($startDate.day.ToString("00"))
[DateTime]$weekOneStartDate = $startDate.AddDays(0)
[DateTime]$weekOneEndDate = $startDate.AddDays(5)
[string]$weekOneStart = $($weekOneStartDate.year.ToString("0000")) + '-' + $($weekOneStartDate.month.ToString("00")) + '-' + $($weekOneStartDate.day.ToString("00"))
[string]$weekOneEnd = $($weekOneEndDate.year.ToString("0000")) + '-' + $($weekOneEndDate.month.ToString("00")) + '-' + $($weekOneEndDate.day.ToString("00"))
[DateTime]$weekTwoStartDate = $startDate.AddDays(6)
[DateTime]$weekTwoEndDate = $startDate.AddDays(11)
[string]$weekTwoStart = $($weekTwoStartDate.year.ToString("0000")) + '-' + $($weekTwoStartDate.month.ToString("00")) + '-' + $($weekTwoStartDate.day.ToString("00"))
[string]$weekTwoEnd = $($weekTwoEndDate.year.ToString("0000")) + '-' + $($weekTwoEndDate.month.ToString("00")) + '-' + $($weekTwoEndDate.day.ToString("00"))
[DateTime]$weekThreeStartDate = $startDate.AddDays(12)
[DateTime]$weekThreeEndDate = $startDate.AddDays(17)
[string]$weekThreeStart = $($weekThreeStartDate.year.ToString("0000")) + '-' + $($weekThreeStartDate.month.ToString("00")) + '-' + $($weekThreeStartDate.day.ToString("00"))
[string]$weekThreeEnd = $($weekThreeEndDate.year.ToString("0000")) + '-' + $($weekThreeEndDate.month.ToString("00")) + '-' + $($weekThreeEndDate.day.ToString("00"))
[DateTime]$weekFourStartDate = $startDate.AddDays(18)
[DateTime]$weekFourEndDate = $startDate.AddDays(23)
[string]$weekFourStart = $($weekFourStartDate.year.ToString("0000")) + '-' + $($weekFourStartDate.month.ToString("00")) + '-' + $($weekFourStartDate.day.ToString("00"))
[string]$weekFourEnd = $($weekFourEndDate.year.ToString("0000")) + '-' + $($weekFourEndDate.month.ToString("00")) + '-' + $($weekFourEndDate.day.ToString("00"))
[DateTime]$weekFiveStartDate = $startDate.AddDays(24)
[DateTime]$weekFiveEndDate = $startDate.AddDays(29)
[string]$weekFiveStart = $($weekFiveStartDate.year.ToString("0000")) + '-' + $($weekFiveStartDate.month.ToString("00")) + '-' + $($weekFiveStartDate.day.ToString("00"))
[string]$weekFiveEnd = $($weekFiveEndDate.year.ToString("0000")) + '-' + $($weekFiveEndDate.month.ToString("00")) + '-' + $($weekFiveEndDate.day.ToString("00"))
[string]$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
If ($(Confirm-Run) -eq 'y') {
	Try {
		$totalStartTime = Get-Date
		If ($endDate.DayOfWeek -ne 'Sunday') {
			throw [System.ArgumentOutOfRangeException] "End date should be a Sunday!!!"
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
		# Update local store and product tables
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		Execute-LocalStoreAndProduct
		Start-Sleep -Seconds 2
		# Run agg1-1
		Execute-AggregateOneOne
		Start-Sleep -Seconds 420
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Run agg1-2
		Execute-AggregateOneTwo
		Start-Sleep -Seconds 420
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Run agg1-3-1
		Execute-AggregateOneThree -dateStart $weekOneStart -dateEnd $weekOneEnd
		Start-Sleep -Seconds 420
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Run agg1-3-2
		Execute-AggregateOneThree -dateStart $weekTwoStart -dateEnd $weekTwoEnd
		Start-Sleep -Seconds 420
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Run agg1-3-3
		Execute-AggregateOneThree -dateStart $weekThreeStart -dateEnd $weekThreeEnd
		Start-Sleep -Seconds 420
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Run agg1-3-4
		Execute-AggregateOneThree -dateStart $weekFourStart -dateEnd $weekFourEnd
		Start-Sleep -Seconds 420
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Run agg1-3-5
		Execute-AggregateOneThree -dateStart $weekFiveStart -dateEnd $weekFiveEnd
		Start-Sleep -Seconds 2
		Execute-ShrinkLogFile
		Start-Sleep -Seconds 2
		# Run agg2
		Execute-AggregateTwo
		Start-Sleep -Seconds 2
		# Report
		$totalEndTime = Get-Date
		$totTime = New-TimeSpan -Start $totalStartTime -End $totalEndTime
		$message0 = "Start Time-----------:  $($startTime.DateTime)"
		$message1 = "End Time-------------:  $($endTime.DateTime)"
		$message2 = "Total Run Time-------:  $($totTime.Hours.ToString("00")) hours $($totTime.Minutes.ToString("00")) minutes $($totTime.Seconds.ToString("00")) seconds"
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $finalAddr;
			BodyAsHtml = $true;
			Subject = "BITC: Store Report Data For: $start - $end Is Ready";
			Body = @"
Ben (or Anna), please start the Alteryx process to create the store reports and drop them into the outbound 7Reports folder.<br>
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
		$message = "BIT Store Report Data For Date Range: $start - $end FAILED!!!"
		Write-Output $message
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $aggOneOneResult" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $aggOneTwoResult" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $aggOneThreeResult" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $aggTwoResult" -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $opsAddr;
			BodyAsHtml = $true;
			Subject = "BITC: $message";
			Body = @"
<font face='courier'>
Something bad happened!!!<br>
$aggOneResult<br>
$aggOneTwoResult<br>
$aggOneThreeResult<br>
$aggTwoResult<br>
</font>
"@
		}
		Send-MailMessage @params
	}
}

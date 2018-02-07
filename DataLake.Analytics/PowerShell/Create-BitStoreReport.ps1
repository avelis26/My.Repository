# Init  --  v1.0.0.0
##########################################
##########################################
$global:end = '2018-02-04'
##########################################
##########################################
$global:opsLog = "H:\Ops_Log\BITC_$($end)_Store_Report.log"
$global:opsAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com'
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
Function Execute-AggregateOne {
	$startTime = Get-Date
	$message = "Starting Aggregate One For Date Range: $start - $end"
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
	$sqlAggOneParams = @{
		query = "EXECUTE [dbo].[usp_Aggregate_One_test] @StartDate = '$start', @EndDate = '$end'";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$result = Invoke-Sqlcmd @sqlAggOneParams
	$message = "Aggregate One For Date Range: $start - $end Completed Successfully"
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
<font face='consolas'>
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
		query = "EXECUTE [dbo].[usp_Aggregate_One_test]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$result = Invoke-Sqlcmd @sqlAggTwoParams
	$message = "Aggregate Two For Date Range: $start - $end Completed Successfully"
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
<font face='consolas'>
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
<font face='consolas'>
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
# Init
[DateTime]$endDate = Get-Date -Date $end
[DateTime]$startDate = $endDate.AddDays(-29)
[string]$start = $($startDate.year.ToString("0000")) + '-' + $($startDate.month.ToString("00")) + '-' + $($startDate.day.ToString("00"))
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
		Execute-LocalStoreAndProduct
		Start-Sleep -Seconds 2
# Run agg1
		Execute-AggregateOne
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
			Subject = "BITC: Store Report Data For Date Range: $start - $end Is Ready";
			Body = @"
Ben (or Anna), please start the Alteryx process to create the store reports and drop them into the outbound 7Reports folder.<br>
<br>
<font face='consolas'>
$message0
$message1
$message2
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
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $opsAddr;
			BodyAsHtml = $true;
			Subject = "BITC: $message";
			Body = @"
Something bad happened!!!
$result
"@
		}
		Send-MailMessage @params
	}
}

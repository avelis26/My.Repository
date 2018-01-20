##########################################
##########################################
$start = '2017-12-20'
$end = '2017-12-23'
##########################################
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
$opsLog = "H:\Ops_Log\usp_prod_store_tables.log"
$message = "$(Create-TimeStamp)  Starting stored procedure for updating product and store tables..."
Write-Output $message
Add-Content -Value $message -Path $opsLog
$server = 'Server=tcp:mstestsqldw.database.windows.net,1433;'
$catalog = 'Initial Catalog=7ELE;'
$secInfo = 'Persist Security Info=False;'
$user = 'User ID=sqladmin;'
$pass = 'Password=Password20!7!;'
$sets = 'MultipleActiveResultSets=False;'
$encrypt = 'Encrypt=True;'
$cert = 'TrustServerCertificate=True;'
$connectionString = $server + $catalog + $secInfo + $user + $pass + $sets + $encrypt + $cert
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = $connectionString
$sqlConnection.Open()
$sqlCommand = New-Object System.Data.SqlClient.SqlCommand
$sqlCommand.Connection = $sqlConnection
$sqlCommand.CommandText= "[dbo].[usp_prod_store_tables]"
$sqlCommand.CommandTimeout = 0
$result = $sqlCommand.ExecuteNonQuery()
$sqlConnection.Close()
$message = "$(Create-TimeStamp)  Product and store tables updated successfully."
Write-Output $message
Add-Content -Value $message -Path $opsLog
$block = {
	add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
	$startTime = Get-Date
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
	$opsLog = "H:\Ops_Log\uspAggregateTables_agg1.log"
	$message = "$(Create-TimeStamp)  Starting aggregate query 1 for date range $($args[0]) - $($args[1])..."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog
	$server = 'Server=tcp:mstestsqldw.database.windows.net,1433;'
	$catalog = 'Initial Catalog=7ELE;'
	$secInfo = 'Persist Security Info=False;'
	$user = 'User ID=sqladmin;'
	$pass = 'Password=Password20!7!;'
	$sets = 'MultipleActiveResultSets=False;'
	$encrypt = 'Encrypt=True;'
	$cert = 'TrustServerCertificate=True;'
	$connectionString = $server + $catalog + $secInfo + $user + $pass + $sets + $encrypt + $cert
	$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$sqlConnection.ConnectionString = $connectionString
	$sqlConnection.Open()
	$sqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$sqlCommand.Connection = $sqlConnection
	$sqlCommand.CommandText= "[dbo].[uspAggregateTables_agg1] @StartDate = '$($args[0])', @EndDate = '$($args[1])'"
	$sqlCommand.CommandTimeout = 0
	$result = $sqlCommand.ExecuteNonQuery()
	$sqlConnection.Close()
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$smtpServer = '10.128.1.125'
	$port = 25
	$fromAddr = 'noreply@7-11.com'
	$toAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'megan.morace@ansira.com', 'tyler.bailey@ansira.com', 'anna.behle@ansira.com', 'ben.smith@ansira.com'
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $toAddr;
		BodyAsHtml = $true;
		Subject = "BITC: Aggregate Query 1 For Date Range: $($args[0]) - $($args[1]) Completed";
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
Start-Job -ScriptBlock $block -ArgumentList "$start", "$end"
$block = {
	add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
	$startTime = Get-Date
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
	$opsLog = "H:\Ops_Log\uspAggregateTables_agg2.log"
	$message = "$(Create-TimeStamp)  Starting aggregate query 2 for date range $($args[0]) - $($args[1])..."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog
	$server = 'Server=tcp:mstestsqldw.database.windows.net,1433;'
	$catalog = 'Initial Catalog=7ELE;'
	$secInfo = 'Persist Security Info=False;'
	$user = 'User ID=sqladmin;'
	$pass = 'Password=Password20!7!;'
	$sets = 'MultipleActiveResultSets=False;'
	$encrypt = 'Encrypt=True;'
	$cert = 'TrustServerCertificate=True;'
	$connectionString = $server + $catalog + $secInfo + $user + $pass + $sets + $encrypt + $cert
	$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
	$sqlConnection.ConnectionString = $connectionString
	$sqlConnection.Open()
	$sqlCommand = New-Object System.Data.SqlClient.SqlCommand
	$sqlCommand.Connection = $sqlConnection
	$sqlCommand.CommandText= "[dbo].[uspAggregateTables_agg2] @StartDate = '$($args[0])', @EndDate = '$($args[1])'"
	$sqlCommand.CommandTimeout = 0
	$result = $sqlCommand.ExecuteNonQuery()
	$sqlConnection.Close()
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$runTime = New-TimeSpan -Start $startTime -End $endTime
	$smtpServer = '10.128.1.125'
	$port = 25
	$fromAddr = 'noreply@7-11.com'
	$toAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'megan.morace@ansira.com', 'tyler.bailey@ansira.com', 'anna.behle@ansira.com', 'ben.smith@ansira.com'
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $toAddr;
		BodyAsHtml = $true;
		Subject = "BITC: Aggregate Query 2 For Date Range: $($args[0]) - $($args[1]) Completed";
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
Start-Job -ScriptBlock $block -ArgumentList "$start", "$end"
Get-Job | Wait-Job
Get-Job | Remove-Job

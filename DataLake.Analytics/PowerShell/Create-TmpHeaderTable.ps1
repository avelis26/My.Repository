##########################################
##########################################
$start = '2017-12-16'
$end = '2018-01-14'
##########################################
##########################################
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
$opsLog = "H:\Ops_Log\usp_Create_Tmp_Header_Table.log"
$message = "Starting stored procedure create partitioned and indexed temp header table for date range: $start - $end"
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$toAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
$params = @{
	SmtpServer = $smtpServer;
	Port = $port;
	UseSsl = 0;
	From = $fromAddr;
	To = $toAddr;
	BodyAsHtml = $true;
	Subject = $message;
	Body = "Start Time: $(Get-Date)"
}
Send-MailMessage @params
Write-Output $message
Add-Content -Value $message -Path $opsLog
Try {
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
	$sqlCommand.CommandText= "[dbo].[usp_Create_Tmp_Header_Table] @StartDate = '$start', @EndDate = '$end'"
	$sqlCommand.CommandTimeout = 0
	$result = $sqlCommand.ExecuteNonQuery()
	$sqlConnection.Close()
	$message = "$(Create-TimeStamp)  Temp header table created successfully."
	Write-Output $message
	Add-Content -Value $message -Path $opsLog
	Add-Content -Value $result -Path $opsLog
	$endTime = Get-Date
	$spandObj = New-TimeSpan -Start $startTime -End $endTime
	$message1 = "Start Time----------:  $($startTime.DateTime)"
	$message2 = "End Time------------:  $($endTime.DateTime)"
	$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
	$smtpServer = '10.128.1.125'
	$port = 25
	$fromAddr = 'noreply@7-11.com'
	$toAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $toAddr;
		BodyAsHtml = $true;
		Subject = "BITC: Temp Header Table For Date Range: $start - $wnd Completed";
		Body = @"
<font face='consolas'>
The results have been loaded into:<br>
<br>
Server--------------:  [MsTestSqlDw.Database.Windows.Net]<br>
Database------------:  [7ELE]<br>
Tables--------------:  [dbo].[tmp_Header_Table]<br>
$message1<br>
$message2<br>
$message3<br>
<br>
</font>
"@
	}
	Send-MailMessage @params
}
Catch {
	$message = "Creating temp header table for date range: $start - $end FAILED!!!!!!!!"
	$smtpServer = '10.128.1.125'
	$port = 25
	$fromAddr = 'noreply@7-11.com'
	$toAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $toAddr;
		BodyAsHtml = $true;
		Subject = $message;
		Body = "Something bad happened!!!"
	}
	Send-MailMessage @params
	Write-Output $message
	Add-Content -Value $message -Path $opsLog
}

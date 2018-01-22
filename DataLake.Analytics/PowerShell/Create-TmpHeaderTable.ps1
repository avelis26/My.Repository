##########################################
##########################################
$global:end = '2018-01-21'
##########################################
##########################################
$global:opsLog = "H:\Ops_Log\usp_Create_Tmp_Header_Table.log"
$global:smtpServer = '10.128.1.125'
$global:port = 25
$global:fromAddr = 'noreply@7-11.com'
$global:toAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
##########################################
##########################################
[DateTime]$endDate = Get-Date -Date $end
[DateTime]$startDate = $endDate.AddDays(-29)

$global:start = $($startDate.year.ToString("0000")) + '-' + $($startDate.month.ToString("00")) + '-' + $($startDate.day.ToString("00"))
If ($endDate.DayOfWeek -ne 'Sunday') {
	throw [System.ArgumentOutOfRangeException] "End date should be a Sunday!!!"
}
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
$message = "Creating Temp Header Table for date range: $start - $end"
Write-Output $message
Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
$params = @{
	SmtpServer = $smtpServer;
	Port = $port;
	UseSsl = 0;
	From = $fromAddr;
	To = $toAddr;
	BodyAsHtml = $true;
	Subject = "BITC: $message";
	Body = "Start Time: $(Get-Date)"
}
Send-MailMessage @params
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
	$sqlCommand.CommandText= "EXECUTE [dbo].[usp_Create_Tmp_Header_Table] @StartDate = '$start', @EndDate = '$end'"
	$sqlCommand.CommandTimeout = 0
	$result = $sqlCommand.ExecuteNonQuery()
	$sqlConnection.Close()
	$message = "Temp Header Table For Date Range: $start - $end Created"
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
		To = $toAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
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
Catch [System.ArgumentOutOfRangeException] {
	Write-Error -Exception $Error[0].Exception
	Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: Temp header table creation for date range: $start - $end FAILED!!!";
		Body = "$($Error[0].Exception)"
	}
	Send-MailMessage @params
}
Catch {
	Start-Sleep -Seconds 2
	$message = "Temp header table creation for date range: $start - $end FAILED!!!"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $toAddr;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = @"
Something bad happened!!!
$result
"@
	}
	Send-MailMessage @params
}

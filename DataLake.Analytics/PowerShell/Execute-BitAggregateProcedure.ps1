##########################################
##########################################
$global:end = '2018-01-21'
##########################################
##########################################
$global:opsLog = "H:\Ops_Log\Aggregate.log"
$global:smtpServer = '10.128.1.125'
$global:port = 25
$global:fromAddr = 'noreply@7-11.com'
$global:toAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
$global:finalAddr = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com', 'anna.behle@ansira.com', 'ben.smith@ansira.com'
##########################################
##########################################
Try {
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
		Subject = "BITC: Aggregation for date range: $start - $end FAILED!!!";
		Body = "$($Error[0].Exception)"
	}
	Send-MailMessage @params
	Exit 1
}
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
Try {
	$message = "Updating Master Product and Store Tables"
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = "Start Time: $(Get-Date)"
	}
	Send-MailMessage @params
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
	$sqlCommand.CommandText= "EXECUTE [dbo].[usp_prod_store_tables]"
	$sqlCommand.CommandTimeout = 0
	$result = $sqlCommand.ExecuteNonQuery()
	$sqlConnection.Close()
	$message = "Product and store tables updated successfully."
	Write-Output $message
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = "$result rows inserted"
	}
	Send-MailMessage @params
}
Catch {
	$message = "Updating Master Product And Store Tables FAILED!!!"
	Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
	Write-Error -Exception $($Error[0].Exception) -Message $message
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "BITC: $message";
		Body = "$($Error[0].Exception)"
	}
	Send-MailMessage @params
	Exit 1
}
$block = {
	Try {
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
		$opsLog = "H:\Ops_Log\uspAggregateTables_agg1.log"
		$message = "Starting aggregate query 1 for date range $($args[0]) - $($args[1])..."
		Write-Output $message
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
		$params = @{
			SmtpServer = $($args[2]);
			Port = $($args[3]);
			UseSsl = 0;
			From = $($args[4]);
			To = $($args[5]);
			BodyAsHtml = $true;
			Subject = "BITC: $message";
			Body = "Start Time: $(Get-Date)"
		}
		Send-MailMessage @params
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
		$sqlCommand.CommandText= "EXECUTE [dbo].[uspAggregateTables_agg1] @StartDate = '$($args[0])', @EndDate = '$($args[1])'"
		$sqlCommand.CommandTimeout = 0
		$result = $sqlCommand.ExecuteNonQuery()
		$sqlConnection.Close()
		$endTime = Get-Date
		$spandObj = New-TimeSpan -Start $startTime -End $endTime
		$message = "Aggregate Query 1 For Date Range: $($args[0]) - $($args[1]) Completed"
		$message1 = "Start Time----------:  $($startTime.DateTime)"
		$message2 = "End Time------------:  $($endTime.DateTime)"
		$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
		Write-Output $message
		Write-Output $message1
		Write-Output $message2
		Write-Output $message3
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $message1" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $message2" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $message3" -Path $opsLog
		$params = @{
			SmtpServer = $($args[2]);
			Port = $($args[3]);
			UseSsl = 0;
			From = $($args[4]);
			To = $($args[5]);
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
	Catch {
		$message = "Aggregate Query 1 For Date Range: $($args[0]) - $($args[1]) FAILED!!!"
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $($args[2]);
			Port = $($args[3]);
			UseSsl = 0;
			From = $($args[4]);
			To = $($args[5]);
			BodyAsHtml = $true;
			Subject = "BITC: $message";
			Body = $result
		}
		Send-MailMessage @params
		Exit 1
	}
}
Start-Job -ScriptBlock $block -ArgumentList "$start", "$end", "$smtpServer", "$port", "$fromAddr", "$toAddr"
Get-Job | Wait-Job
Get-Job | Remove-Job
$block = {
	Try {
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
		$opsLog = "H:\Ops_Log\uspAggregateTables_agg2.log"
		$message = "Starting aggregate query 2 for date range $($args[0]) - $($args[1])..."
		Write-Output $message
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
		$params = @{
			SmtpServer = $($args[2]);
			Port = $($args[3]);
			UseSsl = 0;
			From = $($args[4]);
			To = $($args[5]);
			BodyAsHtml = $true;
			Subject = "BITC: $message";
			Body = "Start Time: $(Get-Date)"
		}
		Send-MailMessage @params
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
		$sqlCommand.CommandText= "EXECUTE [dbo].[uspAggregateTables_agg2] @StartDate = '$($args[0])', @EndDate = '$($args[1])'"
		$sqlCommand.CommandTimeout = 0
		$result = $sqlCommand.ExecuteNonQuery()
		$sqlConnection.Close()
		$endTime = Get-Date
		$spandObj = New-TimeSpan -Start $startTime -End $endTime
		$message = "Aggregate Query 2 For Date Range: $($args[0]) - $($args[1]) Completed"
		$message1 = "Start Time----------:  $($startTime.DateTime)"
		$message2 = "End Time------------:  $($endTime.DateTime)"
		$message3 = "Total Run Time------:  $($spandObj.Hours.ToString("00")) hours $($spandObj.Minutes.ToString("00")) minutes $($spandObj.Seconds.ToString("00")) seconds"
		Write-Output $message
		Write-Output $message1
		Write-Output $message2
		Write-Output $message3
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $message1" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $message2" -Path $opsLog
		Add-Content -Value "$(Create-TimeStamp)  $message3" -Path $opsLog
		$params = @{
			SmtpServer = $($args[2]);
			Port = $($args[3]);
			UseSsl = 0;
			From = $($args[4]);
			To = $($args[6]);
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
<br></font>
<b>READY TO START ALTERYX</b>
<br>
"@
		}
		Send-MailMessage @params
	}
	Catch {
		$message = "Aggregate Query 2 For Date Range: $($args[0]) - $($args[1]) FAILED!!!"
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $($args[2]);
			Port = $($args[3]);
			UseSsl = 0;
			From = $($args[4]);
			To = $($args[5]);
			BodyAsHtml = $true;
			Subject = "BITC: $message";
			Body = $result
		}
		Send-MailMessage @params
		Exit 1
	}
}
Start-Job -ScriptBlock $block -ArgumentList "$start", "$end", "$smtpServer", "$port", "$fromAddr", "$toAddr", "$finalAddr"
Get-Job | Wait-Job
Get-Job | Remove-Job

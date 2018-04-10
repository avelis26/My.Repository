$startDateObj = Get-Date -Date '2018-02-25'
$day = $startDateObj.day.ToString("00")
$month = $startDateObj.month.ToString("00")
$year = $startDateObj.year.ToString("0000")
$end = $year + '-' + $month + '-' + $day
##########################################
##########################################
$opsAddr = 'graham.pinkston@ansira.com'
$finalAddr = 'graham.pinkston@ansira.com'
##########################################
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$database = '7ELE'
$sqlUser = 'sqladmin'
$sqlPass = 'Password20!7!'
$sqlServer = 'mstestsqldw.database.windows.net'
$scriptStartTime = Get-Date
##########################################
Function New-TimeStamp {
	[CmdletBinding()]
	Param(
		[switch]$forFileName
	)
	If ($forFileName -eq $true) {
		$timeStamp = Get-Date -Format 'yyyyMMdd_hhmmss' -ErrorAction Stop
	}
	Else {
		$timeStamp = Get-Date -Format 'yyyy/MM/dd_HH:mm:ss' -ErrorAction Stop
	}
	Return $timeStamp
}
Function Execute-AggregateOneOne {
	$startTime = Get-Date
	$message = "Store Report: 1 of 8 For Date Range: $start - $end"
	$query = "EXECUTE [dbo].[usp_Hadoop_1_1] @StartDate = '$start', @EndDate = '$end'"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(New-TimeStamp)  $query" -Path $opsLog
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
		query = $query;
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
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
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
	$message = "Store Report: 2 of 8 For Date Range: $start - $end"
	$query = "EXECUTE [dbo].[usp_Hadoop_1_2]"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(New-TimeStamp)  $query" -Path $opsLog
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
	$sqlAggOneTwoParams = @{
		query = $query;
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$global:aggOneTwoResult = Invoke-Sqlcmd @sqlAggOneTwoParams
	$message = "Store Report: 2 of 8 For Date Range: $start - $end Completed Successfully"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
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
		[string]$dateEnd,
		[string]$step
	)
	$startTime = Get-Date
	$message = "Store Report: $step of 8 For Date Range: $dateStart - $dateEnd"
	$query = "EXECUTE [dbo].[usp_Hadoop_1_3] @StartDate = '$dateStart', @EndDate = '$dateEnd'"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(New-TimeStamp)  $query" -Path $opsLog
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
	$sqlAggOneThreeParams = @{
		query = $query;
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$global:aggOneThreeResult = Invoke-Sqlcmd @sqlAggOneThreeParams
	$message = "Store Report: $step of 8 For Date Range: $dateStart - $dateEnd Completed Successfully"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
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
	$message = "Store Report: 8 of 8 For Date Range: $start - $end"
	$query = "EXECUTE [dbo].[usp_Hadoop_Two]"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(New-TimeStamp)  $query" -Path $opsLog
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
	$sqlAggTwoParams = @{
		query = $query;
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	$aggTwoResult = Invoke-Sqlcmd @sqlAggTwoParams
	$message = $message = "Store Report: 8 of 8 For Date Range: $start - $end Completed Successfully"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
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
	$message = "Store Report: 0 of 8 For Date Range: $dateStart - $dateEnd"
	$query = "EXECUTE [dbo].[usp_Copy_Store_Product_Locally]"
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
	Add-Content -Value "$(New-TimeStamp)  $query" -Path $opsLog
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
	$sqlSandPParams = @{
		query = $query;
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
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
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
		}
		Catch {
			If ($tryAgain -gt 5) {
				$errorParams = @{
					Message = "Azure SQL Database totally sucks!!!";
					ErrorId = "542";
					RecommendedAction = "Wait and try again.";
					ErrorAction = "Stop";
				}
				Write-Error @errorParams
				Break
			} # if
			$message = "Shrinking database log file failed!!! Trying again..."
			Write-Output $message
			Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
			Start-Sleep -Seconds 60
			$tryAgain++
		} # catch
	} # while
	$message = "Database log file shrunk successfully."
	Write-Output $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog
}
# Init
$global:opsLog = "H:\Ops_Log\BITC_$($end)_" + $(New-TimeStamp -forFileName) + "_Store_Report.log"
[DateTime]$endDate = Get-Date -Date $end
[DateTime]$startDate = Get-Date -Date '2002-01-01'
[string]$start = $($startDate.year.ToString("0000")) + '-' + $($startDate.month.ToString("00")) + '-' + $($startDate.day.ToString("00"))
[string]$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
Try {
	Import-Module SqlServer -ErrorAction Stop
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
	# Step 0: Update local store and product tables
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	Execute-LocalStoreAndProduct
	Start-Sleep -Seconds 2
	# Step 1: Run agg_1-1
	Execute-AggregateOneOne
	Start-Sleep -Seconds 2
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 2: Run agg_1-2
	Execute-AggregateOneTwo
	Start-Sleep -Seconds 2
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 3: Run agg_1-3
	Execute-AggregateOneThree -dateStart $start -dateEnd $end -step '3'
	Start-Sleep -Seconds 2
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 4: Run agg_1-4
	Execute-AggregateTwo
	Start-Sleep -Seconds 2
	# Report
	$endDateObj = Get-Date
	$totTime = New-TimeSpan -Start $startDateObj -End $endDateObj -ErrorAction Stop
	$message0 = "Start Time-----------:  $($startDateObj.Hour.ToString("00")) hours $($startDateObj.Minute.ToString("00")) minutes $($startDateObj.Second.ToString("00")) seconds"
	$message1 = "End Time-------------:  $($endDateObj.Hour.ToString("00")) hours $($endDateObj.Minute.ToString("00")) minutes $($endDateObj.Second.ToString("00")) seconds"
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
Catch {
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
		Subject = "BITC: Store Report Data For Date Range: $start - $end FAILED!!!";
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
}
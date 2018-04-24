# Init  --  v1.3.2.9
##########################################
# Fix error hanlding
##########################################
$scriptStartTime = Get-Date
$day = $($scriptStartTime.AddDays(-1)).day.ToString("00")
$month = $($scriptStartTime.AddDays(-1)).month.ToString("00")
$year = $($scriptStartTime.AddDays(-1)).year.ToString("0000")
$end = $year + '-' + $month + '-' + $day
##########################################
$opsAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com', 'Britten.Morse@Ansira.com'
$finalAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com', 'megan.morace@ansira.com', 'Anna.Behle@Ansira.com', 'Ben.Smith@Ansira.com', 'Britten.Morse@Ansira.com'
##########################################
$opsLogRoot = '\\MS-SSW-CRM-BITC\Data\Ops_Log\Report\Store\'
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
	If ($forFileName -eq $true) {
		$timeStamp = Get-Date -Format 'yyyyMMdd_HHmmss' -ErrorAction Stop
	}
	Else {
		$timeStamp = Get-Date -Format 'yyyy/MM/dd_HH:mm:ss' -ErrorAction Stop
	}
	Return $timeStamp
}
Function Execute-AggregateOneOne {
	$startTime = Get-Date
	$message = "Store Report: 1 of 8 For Date Range: $start - $end"
	$query = "EXECUTE [dbo].[usp_Aggregate_1_1] @StartDate = '$start', @EndDate = '$end'"
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
	$message1 = "Start Time-----: $($startTime.DateTime)"
	$message2 = "End Time-------: $($endTime.DateTime)"
	$message3 = "Total Run Time-: $($spandObj.Hours.ToString("00")) h $($spandObj.Minutes.ToString("00")) m $($spandObj.Seconds.ToString("00")) s"
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
	$query = "EXECUTE [dbo].[usp_Aggregate_1_2]"
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
	$message1 = "Start Time-----: $($startTime.DateTime)"
	$message2 = "End Time-------: $($endTime.DateTime)"
	$message3 = "Total Run Time-: $($spandObj.Hours.ToString("00")) h $($spandObj.Minutes.ToString("00")) m $($spandObj.Seconds.ToString("00")) s"
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
	$query = "EXECUTE [dbo].[usp_Aggregate_1_3] @StartDate = '$dateStart', @EndDate = '$dateEnd'"
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
	$message1 = "Start Time-----: $($startTime.DateTime)"
	$message2 = "End Time-------: $($endTime.DateTime)"
	$message3 = "Total Run Time-: $($spandObj.Hours.ToString("00")) h $($spandObj.Minutes.ToString("00")) m $($spandObj.Seconds.ToString("00")) s"
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
			Server---: [MsTestSqlDw.Database.Windows.Net]<br>
			Database-: [7ELE]<br>
			Table----: [dbo].[Agg1_DaypartAggregate]<br>
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
	$query = "EXECUTE [dbo].[usp_Aggregate_Two]"
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
	$message1 = "Start Time-----: $($startTime.DateTime)"
	$message2 = "End Time-------: $($endTime.DateTime)"
	$message3 = "Total Run Time-: $($spandObj.Hours.ToString("00")) h $($spandObj.Minutes.ToString("00")) m $($spandObj.Seconds.ToString("00")) s"
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
			Server---: [MsTestSqlDw.Database.Windows.Net]<br>
			Database-: [7ELE]<br>
			Table----: [dbo].[Agg2_StoreTxnItems]<br>
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
	$message = "Store Report: 0 of 8 For Date Range: $start - $end"
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
	$message1 = "Start Time-----: $($startTime.DateTime)"
	$message2 = "End Time-------: $($endTime.DateTime)"
	$message3 = "Total Run Time-: $($spandObj.Hours.ToString("00")) h $($spandObj.Minutes.ToString("00")) m $($spandObj.Seconds.ToString("00")) s"
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
# Init
If ($(Test-Path -Path $opsLogRoot) -eq $false) {
	New-Item -Path $opsLogRoot -ItemType Directory -Force
}
$opsLog = $opsLogRoot + "BITC_$($end)_" + $(New-TimeStamp -forFileName) + "_Store_Report.log"
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
$message = "Date Range: $start - $end"
Write-Output $message
Add-Content -Path $opsLog -Value $message
$searchPath = '\\MS-SSW-CRM-BITC\Data\Ops_Log\ETL\Store'
$continue = $null
$shouldExit = 0
While ($continue -ne 1) {
	$file = Get-ChildItem -Path $searchPath -File | Sort-Object -Property LastWriteTime | Select-Object -Last 1
	$content = Get-Content -Path $file.FullName -Tail 1
	If ($content -eq '::ETL SUCCESSFUL::') {
		$continue = 1
	}
	Start-Sleep -Seconds 60
	$shouldExit++
	If ($shouldExit -gt 120) {
		$errorParams = @{
			Message = "Store report aggregation script failed to start because current day ETL status unknown!!!";
			ErrorId = "5";
			RecommendedAction = "Check ops log.";
			ErrorAction = "Stop";
		}
		Write-Error @errorParams
	}
}
Try {
	If ($endDate.DayOfWeek -ne 'Sunday') {
		throw [System.ArgumentOutOfRangeException] "End date should be a Sunday!!!"
	}
	Import-Module SqlServer -ErrorAction Stop
	. $($PSScriptRoot + '\Set-SslCertPolicy.ps1')
	$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
	Add-Content -Value "$(New-TimeStamp)  SSL Policy: $policy" -Path $opsLog -ErrorAction Stop
	Set-SslCertPolicy
	$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
	Add-Content -Value "$(New-TimeStamp)  SSL Policy: $policy" -Path $opsLog -ErrorAction Stop
	# Step 0: Update local store and product tables
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	Execute-LocalStoreAndProduct
	Start-Sleep -Seconds 2
	# Step 1: Run agg1-1
	Execute-AggregateOneOne
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 2: Run agg1-2
	Execute-AggregateOneTwo
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 3: Run agg1-3-1
	Execute-AggregateOneThree -dateStart $weekOneStart -dateEnd $weekOneEnd -step '3'
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 4: Run agg1-3-2
	Execute-AggregateOneThree -dateStart $weekTwoStart -dateEnd $weekTwoEnd -step '4'
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 5: Run agg1-3-3
	Execute-AggregateOneThree -dateStart $weekThreeStart -dateEnd $weekThreeEnd -step '5'
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 6: Run agg1-3-4
	Execute-AggregateOneThree -dateStart $weekFourStart -dateEnd $weekFourEnd -step '6'
	Start-Sleep -Seconds 64
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 7: Run agg1-3-5
	Execute-AggregateOneThree -dateStart $weekFiveStart -dateEnd $weekFiveEnd -step '7'
	Start-Sleep -Seconds 2
	Execute-ShrinkLogFile
	Start-Sleep -Seconds 2
	# Step 8: Run agg2
	Execute-AggregateTwo
	Start-Sleep -Seconds 2
	# Report
	$scriptEndTime = Get-Date
	$totTime = New-TimeSpan -Start $scriptStartTime -End $scriptEndTime -ErrorAction Stop
	$message0 = "Start Time-----------:  $($scriptStartTime.ToString())"
	$message1 = "End Time-------------:  $($scriptEndTime.ToString())"
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
			Ben (or Anna), please start the Alteryx process and drop the reports into the outbound 7Reports file share.<br>
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
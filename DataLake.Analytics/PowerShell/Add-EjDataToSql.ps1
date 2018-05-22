# Version  --  v3.1.6.5
#######################################################################################################
# need to imporve multithreading
# Add logic to check bcp error file for content
# add error text to email from optimus
#######################################################################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $true)][ValidateSet('s', 'c')][string]$report,
	[parameter(Mandatory = $false)][switch]$autoDate,
	[parameter(Mandatory = $false)][string]$startDate,
	[parameter(Mandatory = $false)][string]$endDate,
	[parameter(Mandatory = $false)][switch]$test
)
Write-Output "Importing AzureRm, 7Zip, and SqlServer modules as well as custom fuctions..."
Import-Module AzureRM -ErrorAction Stop
Import-Module SqlServer -ErrorAction Stop
Import-Module 7Zip4powershell -ErrorAction Stop
. $($PSScriptRoot + '\Set-SslCertPolicy.ps1')
. $($PSScriptRoot + '\Get-DataLakeRawFiles.ps1')
. $($PSScriptRoot + '\Expand-FilesInParallel.ps1')
. $($PSScriptRoot + '\Split-FilesAmongFolders.ps1')
##   Enter your 7-11 user name without domain:
$userName = 'gpink003'
##   Enter the transactions you would like to filter for:
$transTypes = 'D1121,D1122'
##   Enter the path where you want the raw files to be downloaded on your local machine:
$destinationRootPath = 'D:\BIT_CRM\'
$archiveRootPath = '\\MS-SSW-CRM-MGMT\Data\BIT_CRM\SQL\Error\'
##   Enter the path where you want the error logs to be stored:
$errLogRootPath = '\\MS-SSW-CRM-MGMT\Data\Err_Log\'
##   Enter the email address for failures:
$failEmailList = 'graham.pinkston@ansira.com', `
	'mayank.minawat@ansira.com', `
	'catherine.wells@ansira.com', `
	'britten.morse@ansira.com', `
	'Geri.Shaeffer@Ansira.com', `
	'megan.morace@ansira.com'
##   If autoDate switch not used, get dates from variables provided above:
If ($autoDate.IsPresent -eq $false) {
	$startDateObj = Get-Date -Date $startDate -ErrorAction Stop
	$endDateObj = Get-Date -Date $endDate -ErrorAction Stop
}
##   Email, log path, and dates change for store report
$headersMovePreProdSp = 'usp_Staging_To_PreProd_Headers'
$detailsMovePreProdSp = 'usp_Staging_To_PreProd_Details'
$detailsEndDateSp = 'usp_Create_Details_EndDate'
If ($report -eq 's') {
	$opsLogRootPath = '\\MS-SSW-CRM-MGMT\Data\Ops_Log\ETL\Store\'
	$headersMoveSp = 'usp_Staging_To_Prod_Headers'
	$detailsMoveSp = 'usp_Staging_To_Prod_Details'
	[string[]]$emailList = `
	'graham.pinkston@ansira.com', `
	'mayank.minawat@ansira.com', `
	'DIST-SEI_CRM_STATUS@7-11.com', `
	'catherine.wells@ansira.com', `
	'britten.morse@ansira.com', `
	'Geri.Shaeffer@Ansira.com', `
	'megan.morace@ansira.com'
	If ($autoDate.IsPresent -eq $true) {
		$startDateObj = $endDateObj = Get-Date -ErrorAction Stop
		$startDate = $endDate = $startDateObj.Year.ToString('0000') + '-' + $startDateObj.Month.ToString('00') + '-' + $startDateObj.Day.ToString('00')
	}
}
##   Email, log path, and dates change for CEO report
ElseIf ($report -eq 'c') {
	$opsLogRootPath = '\\MS-SSW-CRM-MGMT\Data\Ops_Log\ETL\CEO\'
	$headersMoveSp = 'usp_Staging_To_Prod_Headers_CEO'
	$detailsMoveSp = 'usp_Staging_To_Prod_Details_CEO'
	$emailList = 'graham.pinkston@ansira.com'
	If ($autoDate.IsPresent -eq $true) {
		$startDateObj = $endDateObj = $($(Get-Date).AddYears(-1)).AddDays(7)
		$startDate = $endDate = $startDateObj.Year.ToString('0000') + '-' + $startDateObj.Month.ToString('00') + '-' + $startDateObj.Day.ToString('00')
	}
}
If ($test.IsPresent -eq $true) {
	$emailList = 'graham.pinkston@ansira.com'
	$failEmailList = 'graham.pinkston@ansira.com'
	$opsLogRootPath = $opsLogRootPath + 'Test\'
}
##   Base name of database tables
$stgTable121 = 'stg_121_Headers'
$stgTable122 = 'stg_122_Details'
#######################################################################################################
##   These parametser probably won't change
$dataLakeSubId = 'ee691273-18af-4600-bc24-eb6768bf9cfa'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$sqlServer = 'MS-SSW-CRM-SQL'
$database = '7ELE'
$sqlUser = 'sqladmin'
$sqlPass = Get-Content -Path 'C:\Scripts\Secrets\sqlAdmin.txt' -ErrorAction Stop
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$dataLakeSearchPathRoot = '/BIT_CRM/'
$dataLakeStoreName = '711dlprodcons01'
$extractorExe = 'C:\Scripts\C#\Optimus\SQL\Ansira.Sel.BITC.DataExtract.Processor.exe'
##   Here we are nulling out some important variables since PowerISE likes to maintain the runspace
$table = $null
$file = $null
$storeCountResults = $null
$y = 0
#######################################################################################################
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
Add-Content -Value "$(New-TimeStamp -forFileName) :: $($MyInvocation.MyCommand.Name) :: Start" -Path '\\MS-SSW-CRM-MGMT\Data\Ops_Log\bitc.log'
# Init
[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
Write-Host '********************************************************************' -ForegroundColor Magenta
Write-Host "Start Date    ::  $startDate"
Write-Host "End Date      ::  $endDate"
Write-Host "Transactions  ::  $transTypes"
Write-Host "stgTable121   ::  $stgTable121"
Write-Host "stgTable122   ::  $stgTable122"
Write-Host "121 Move SP   ::  $headersMoveSp"
Write-Host "122 Move SP   ::  $detailsMoveSp"
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
	$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj -ErrorAction Stop).Days + 1
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
	Write-Debug -Message $credential.UserName
	While ($y -lt $range) {
		$startTime = Get-Date -ErrorAction Stop
		$startTimeText = $(New-TimeStamp -forFileName)
		$day = $($startDateObj.AddDays($y)).day.ToString("00")
		$month = $($startDateObj.AddDays($y)).month.ToString("00")
		$year = $($startDateObj.AddDays($y)).year.ToString("0000")
		$processDate = $year + $month + $day
		$opsLog = $opsLogRootPath + $processDate + '_' + $startTimeText + '_BITC.log'
		If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
			Write-Output "Creating $opsLogRootPath..."
			New-Item -ItemType Directory -Path $opsLogRootPath -Force -ErrorAction Stop > $null
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Process Date: $processDate"
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Created folder: $opsLogRootPath"
		}
		Else {
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Process Date: $processDate"
		}
		If ($(Test-Path -Path $destinationRootPath) -eq $false) {
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Creating $destinationRootPath..."
			New-Item -ItemType Directory -Path $destinationRootPath -Force -ErrorAction Stop > $null
		}
		If ($(Test-Path -Path $errLogRootPath) -eq $false) {
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Creating $errLogRootPath..."
			New-Item -ItemType Directory -Path $errLogRootPath -Force -ErrorAction Stop > $null
		}
		$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  SSL Policy: $policy"
		Set-SslCertPolicy
		$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  SSL Policy: $policy"
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Logging into Azure..."
		Connect-AzureRmAccount -Credential $credential -Subscription $dataLakeSubId -Force -ErrorAction Stop
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Login successful."
# Get raw files
		$retry = 0
		While ($retry -lt 3) {
			Try {
				$milestone_0 = Get-Date -ErrorAction Stop
				Get-DataLakeRawFiles -dataLakeStoreName $dataLakeStoreName -destination $($destinationRootPath + $processDate + '\') -source $($dataLakeSearchPathRoot + $processDate) -log $opsLog
# Seperate files into 5 seperate folders for paralell processing
				$milestone_1 = Get-Date
				Split-FilesAmongFolders -rootPath $($destinationRootPath + $processDate + '\') -log $opsLog
# Decompress files in parallel
				Expand-FilesInParallel -rootPath $($destinationRootPath + $processDate + '\') -log $opsLog
				$retry = 3
			}
			Catch {
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  $($Error[0].Exception.Message)."
				$retry++
				If ($retry -eq 3) {
					$errorParams = @{
						Message = "$($Error[0].Exception.Message)";
						ErrorId = "69";
						ErrorAction = "Stop";
					}
					Write-Error @errorParams
				}
			}
		}
# Execute C# app as job on raw files to create CSV's
		$milestone_2 = Get-Date
		$folders = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Directory -ErrorAction Stop
		ForEach ($folder in $folders) {
			$outputPath = $($folder.Parent.FullName) + '\' + $($folder.Name) + '_Output\'
			If ($(Test-Path -Path $outputPath) -eq $false) {
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Creating folder:  $outputPath ..."
				New-Item -ItemType Directory -Path $outputPath -Force -ErrorAction Stop > $null
			}
			$block = {
				[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
				& $args[0] $args[1..4];
				Remove-Item -Path $($args[1]) -Recurse -Force -ErrorAction Stop;
			}
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Starting convert job:  $($folder.FullName)..."
			Start-Job -ScriptBlock $block -ArgumentList "$extractorExe", "$($folder.FullName)", "$outputPath", "$transTypes", "$processDate" -ErrorAction Stop
			Start-Sleep -Milliseconds 128
		}
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Converting..."
		Get-Job | Wait-Job
		Get-Job | Remove-Job -ErrorAction Stop
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Optimus Report:"
		$folders = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Directory -ErrorAction Stop
		ForEach ($folder in $folders) {
			$outputFile = Get-ChildItem -Path $($folder.FullName) -Recurse -File -Filter "*output*" -ErrorAction Stop
			$jsonObj = Get-Content -Raw -Path $outputFile.FullName -ErrorAction Stop | ConvertFrom-Json -ErrorAction Stop
			If ($jsonObj.ResponseCode -ne 0) {
				[string]$optimusError = $jsonObj.ResponseMsg
				$errorParams = @{
					Message = "Optimus Failed: $optimusError";
					ErrorId = "$($jsonObj.ResponseCode)";
					RecommendedAction = "Check ops log.";
					ErrorAction = "Stop";
				}
				Write-Error @errorParams
			}
			Else {
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$($folder.FullName)"
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "TotalNumRecords: $($jsonObj.TotalNumRecords)"
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "TotalNumFiles: $($jsonObj.TotalNumFiles)"
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "------------------------------------------------------------------------------------------------------"
			}
		}
# Insert CSV's to DB (stg tables)
		$milestone_3 = Get-Date -ErrorAction Stop
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Truncating staging tables..."
		$query = @"
			TRUNCATE TABLE [dbo].[$($stgTable121)_1];
			TRUNCATE TABLE [dbo].[$($stgTable121)_2];
			TRUNCATE TABLE [dbo].[$($stgTable121)_3];
			TRUNCATE TABLE [dbo].[$($stgTable121)_4];
			TRUNCATE TABLE [dbo].[$($stgTable121)_5];
			TRUNCATE TABLE [dbo].[$($stgTable122)_1];
			TRUNCATE TABLE [dbo].[$($stgTable122)_2];
			TRUNCATE TABLE [dbo].[$($stgTable122)_3];
			TRUNCATE TABLE [dbo].[$($stgTable122)_4];
			TRUNCATE TABLE [dbo].[$($stgTable122)_5];
"@
		$sqlTruncateParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlTruncateParams
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Truncating staging tables successful."
		$structuredFiles = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Recurse -File -Filter "*Structured*" -ErrorAction Stop
		$hext = 1
		$dext = 1
		$jobN = 1
		$jobBase = 'bcp_job_'
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Starting BCP jobs..."
		ForEach ($file in $structuredFiles) {
			Write-Output "$(New-TimeStamp)  Inserting $($file.FullName)..."
			If ($file.Name -like "*D1_121*") {
				$table = "$($stgTable121)_$hext"
				$formatFile = "C:\Scripts\XML\format121.xml"
				$hext++
			}
			ElseIf ($file.Name -like "*D1_122*") {
				$table = "$($stgTable122)_$dext"
				$formatFile = "C:\Scripts\XML\format122.xml"
				$dext++
			}
			Else {
				$errorParams = @{
					Message = "ERROR:: $($file.FullName) didn't mach any defined CSV file name patteren!";
					ErrorId = "999";
					RecommendedAction = "Fix it.";
					ErrorAction = "Stop";
				}
				Write-Error @errorParams
			}
			$errLogFile = $errLogRootPath + $($file.BaseName) + '_' + $($file.Directory.Name) + '_BCP_Error.log'
			$command = "bcp $table in $($file.FullName) -S $sqlServer -d $database -U $sqlUser -P $sqlPass -f $formatFile -b 640000 -F 2 -t ',' -q -e '$errLogFile'"
			$query = "UPDATE $table SET [CsvFile] = '$($file.FullName)'"
			$block = {
				[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
				Import-Module SqlServer -ErrorAction Stop
				[string[]]$jobResult = $($args[0]), $($args[1])
				[string[]]$bcpResult = Invoke-Expression -Command $($args[0])
				If ($bcpResult[$bcpResult.Count - 3] -notlike "*copied*") {
					Return $bcpResult
				}
				Else {
					$sqlParams = @{
						query = $($args[1]);
						ServerInstance = $($args[2]);
						Database = $($args[3]);
						Username = $($args[4]);
						Password = $($args[5]);
						QueryTimeout = 0;
						ErrorAction = 'Stop';
					}
					Invoke-Sqlcmd @sqlParams
				}
				$jobResult += $bcpResult
				Return $jobResult
			}
			[string]$jobName = $jobBase + $jobN
			Start-Job -ScriptBlock $block -Name $jobName -ErrorAction Stop -ArgumentList `
				"$command", ` #0
				"$query", ` #1
				"$sqlServer", ` #2
				"$database", ` #3
				"$sqlUser", ` #4
				"$sqlPass" #5
			$jobN++
		}
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Inserting..."
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  BCP Results:"
		$jobN = 1
		While ($jobN -lt $($structuredFiles.Count + 1)) {
			[string]$jobName = $jobBase + $jobN
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Waiting on $jobName..."
			Get-Job -Name $jobName -ErrorAction Stop | Wait-Job -ErrorAction Stop
			$bcpJobResults = Receive-Job -Name $jobName -ErrorAction Stop
			If ($bcpJobResults[$bcpJobResults.Count - 3] -notlike "*copied*") {
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  BCP FAILED!!!"
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $bcpJobResults
				$errorParams = @{
					Message = "ERROR:: BCP FAILED!!!";
					ErrorId = "999";
					RecommendedAction = "Check log for BCP results.";
					ErrorAction = "Stop";
				}
				Write-Error @errorParams
			}
			Else {
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $bcpJobResults
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "------------------------------------------------------------------------------------------------------"
				Remove-Job -Name $jobName -ErrorAction Stop
			}
			$jobN++
		}
# Count stores by day in stg header table and compare rows in database to rows in files
		$milestone_4 = Get-Date -ErrorAction Stop
		$block = {
			$files = Get-ChildItem -Recurse -File -Path $($args[0]) -Filter "*Structured*" -ErrorAction Stop
			$total = 0
			ForEach ($file in $files) {
				$count = 0
				Get-Content -Path $($file.FullName) -ReadCount 250000 -ErrorAction Stop | ForEach-Object {$count += $_.Count}
				$total = $total + $count
			}
			Return $total
		}
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Counting and comparing..."
		$rowsInFilesJobResults = Start-Job -ScriptBlock $block -ArgumentList "$($destinationRootPath + $processDate + '\')" -ErrorAction Stop
		$query = @"
			SELECT		CAST([EndDate] AS char(10))		AS [EndDate],
						COUNT(DISTINCT([StoreNumber]))	AS [StoreCount]
			FROM		(
			SELECT		[EndDate],
						[StoreNumber]
			FROM		[dbo].[$($stgTable121)_1]
			UNION		ALL
			SELECT		[EndDate],
						[StoreNumber]
			FROM		[dbo].[$($stgTable121)_2]
			UNION		ALL
			SELECT		[EndDate],
						[StoreNumber]
			FROM		[dbo].[$($stgTable121)_3]
			UNION		ALL
			SELECT		[EndDate],
						[StoreNumber]
			FROM		[dbo].[$($stgTable121)_4]
			UNION		ALL
			SELECT		[EndDate],
						[StoreNumber]
			FROM		[dbo].[$($stgTable121)_5]
						)								AS					[x]
			GROUP BY	[EndDate]
			ORDER BY	[EndDate]						DESC
"@
		$sqlStoreCountParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		$storeCountResults = Invoke-Sqlcmd @sqlStoreCountParams
		$storeCountHtml = "<style>
		table {
			font-family: consolas;
			border-collapse: collapse;
		}
		td, th {
			border: 1px solid #dddddd;
			text-align: left;
			padding: 8px;
		}
		tr:nth-child(even) {
			background-color: #dddddd;
		}
		</style>
		<table>";
		$storeCountHtml += "<tr><th>EndDate</th><th>StoreCount</th></tr>"
		$j = 0
		While ($j -lt $($storeCountResults.EndDate.Count)) {
			$storeCountHtml += "<tr><td>$($storeCountResults.EndDate.Get($j))</td><td>$($storeCountResults.StoreCount.Get($j))</td></tr>"
			$j++
		}
		$storeCountHtml += "</table>"
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "Store Count By Day:"
		$t = 0
		While ($t -lt $($storeCountResults.EndDate.Count)) {
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$($storeCountResults.EndDate.Get($t))  |  $($storeCountResults.StoreCount.Get($t))"
			$t++
		}
		$query = @"
			SELECT		COUNT([RecordID])			AS		[Count]
			FROM		(
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable121)_1]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable121)_2]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable121)_3]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable121)_4]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable121)_5]
						)							AS		[x]
"@
		$sqlHeadersCountParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		$sqlHeadersCountResults = Invoke-Sqlcmd @sqlHeadersCountParams
		$query = @"
			SELECT		COUNT([RecordID])			AS		[Count]
			FROM		(
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable122)_1]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable122)_2]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable122)_3]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable122)_4]
			UNION		ALL
			SELECT		[RecordID]
			FROM		[dbo].[$($stgTable122)_5]
						)							AS		[x]
"@
		$sqlDetailsCountParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		$sqlDetailsCountResults = Invoke-Sqlcmd @sqlDetailsCountParams
		Get-Job | Wait-Job -ErrorAction Stop
		$totalFileRowCount = $(Receive-Job $rowsInFilesJobResults) - $($transTypes.Split(',').Count * 5)
		Get-Job | Remove-Job -ErrorAction Stop
		$totalSqlRowCount = $($sqlHeadersCountResults.Count) + $($sqlDetailsCountResults.Count)
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Total Headers Rows: $($sqlHeadersCountResults.Count.ToString('N0'))"
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Total Details Rows: $($sqlDetailsCountResults.Count.ToString('N0'))"
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Total File Rows: $($totalFileRowCount.ToString('N0'))"
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Total DB Rows: $($totalSqlRowCount.ToString('N0'))"
		If ($totalFileRowCount -ne $totalSqlRowCount) {
			$errorParams = @{
				Message = "ERROR: ROW COUNT MISMATCH!!!";
				ErrorId = "999";
				RecommendedAction = "Fix it.";
				ErrorAction = "Stop";
			}
			Write-Error @errorParams
		}
# Create PK's in staging
		$milestone_5 = Get-Date
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Creating PK's on data in staging tables..."
		$block = {
			Import-Module SqlServer -ErrorAction Stop
			$sqlParams = @{
				query = "UPDATE $($args[0]) SET [DataLakeFolder] = '$($args[2])', [Pk] = CONCAT([StoreNumber],'-',[DayNumber],'-',[ShiftNumber],'-',[TransactionUID])";
				ServerInstance = $($args[3]);
				Database = $($args[4]);
				Username = $($args[5]);
				Password = $($args[6]);
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			Invoke-Sqlcmd @sqlParams
			$sqlParams = @{
				query = "UPDATE $($args[1]) SET [DataLakeFolder] = '$($args[2])', [Pk] = CONCAT([StoreNumber],'-',[DayNumber],'-',[ShiftNumber],'-',[TransactionUID],'-',[SequenceNumber])";
				ServerInstance = $($args[3]);
				Database = $($args[4]);
				Username = $($args[5]);
				Password = $($args[6]);
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			Invoke-Sqlcmd @sqlParams
			Return 'Successful'
		}
		$jobBase = 'Pk_Job_'
		$i = 1
		While ($i -lt 6) {
			[string]$jobName = $jobBase + $i
			Start-Job -ScriptBlock $block -Name $jobName -ErrorAction Stop -ArgumentList `
				"$($stgTable121)_$i", ` #0
				"$($stgTable122)_$i", ` #1
				"$($dataLakeSearchPathRoot + $processDate)", ` #2
				"$sqlServer", ` #3
				"$database", ` #4
				"$sqlUser", ` #5
				"$sqlPass" #6
			$i++
		}
		$i = 1
		While ($i -lt 6) {
			[string]$jobName = $jobBase + $i
			Get-Job -Name $jobName -ErrorAction Stop | Wait-Job -ErrorAction Stop
			$pkResult = Receive-Job -Name $jobName -ErrorAction Stop
			If ($pkResult -ne 'Successful') {
				$errorParams = @{
					Message = "ERROR: Failed to create PK's in Staging!!!";
					ErrorId = "999";
					RecommendedAction = "Fix it.";
					ErrorAction = "Stop";
				}
				Write-Error @errorParams
			}
			Else {
				Remove-Job -Name $jobName -ErrorAction Stop
			}
			$i++
		}
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Finished creating PK's on data in staging tables!"
# Move data in DB from stg to preprod, add enddate to details, then move to prod
		$milestone_6 = Get-Date
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Moving headers from staging to preProd..."
		$sqlHeadersFromStgToPreProdParams = @{
			query = "EXECUTE [dbo].[$headersMovePreProdSp]";
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlHeadersFromStgToPreProdParams
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Moving details from staging to preProd..."
		$sqlDetailsFromStgToPreProdParams = @{
			query = "EXECUTE [dbo].[$detailsMovePreProdSp]";
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlDetailsFromStgToPreProdParams
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Adding EndDate to details in preProd..."
		$sqlCreateDetailsEndDateParams = @{
			query = "EXECUTE [dbo].[$detailsEndDateSp]";
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlCreateDetailsEndDateParams
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Moving headers to prod..."
		$sqlHeadersFromPreProdToProdParams = @{
			query = "EXECUTE [dbo].[$headersMoveSp]";
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlHeadersFromPreProdToProdParams
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Moving details to prod..."
		$sqlDetailsFromPreProdToProdParams = @{
			query = "EXECUTE [dbo].[$detailsMoveSp]";
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlDetailsFromPreProdToProdParams
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Move complete!"
# Remove data from temp drive to archive
		$milestone_7 = Get-Date
		$message = "$(New-TimeStamp)  Removing $destinationRootPath..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		Remove-Item -Path $destinationRootPath -Recurse -Force -ErrorAction SilentlyContinue
		$message = "$(New-TimeStamp)  $destinationRootPath removed successfully."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
# Send report
		$endTime = Get-Date
		$endTimeText = $(New-TimeStamp -forFileName)
		$iniTime = New-TimeSpan -Start $startTime -End $milestone_0
		$rawTime = New-TimeSpan -Start $milestone_0 -End $milestone_1
		$sepTime = New-TimeSpan -Start $milestone_1 -End $milestone_2
		$exeTime = New-TimeSpan -Start $milestone_2 -End $milestone_3
		$insTime = New-TimeSpan -Start $milestone_3 -End $milestone_4
		$couTime = New-TimeSpan -Start $milestone_4 -End $milestone_5
		$pkcTime = New-TimeSpan -Start $milestone_5 -End $milestone_6
		$movTime = New-TimeSpan -Start $milestone_6 -End $milestone_7
		$cleTime = New-TimeSpan -Start $milestone_7 -End $endTime
		$totTime = New-TimeSpan -Start $startTime -End $endTime
		$message01 = "Data Lake Folder--:  $($dataLakeSearchPathRoot + $processDate)"
		$message02 = "Start Time--------:  $startTimeText"
		$message03 = "End Time----------:  $endTimeText"
		$message04 = "Initialization----:  $($iniTime.Hours.ToString("00")) h $($iniTime.Minutes.ToString("00")) m $($iniTime.Seconds.ToString("00")) s"
		$message05 = "Raw File Download-:  $($rawTime.Hours.ToString("00")) h $($rawTime.Minutes.ToString("00")) m $($rawTime.Seconds.ToString("00")) s"
		$message06 = "Decompression-----:  $($sepTime.Hours.ToString("00")) h $($sepTime.Minutes.ToString("00")) m $($sepTime.Seconds.ToString("00")) s"
		$message07 = "File Processing---:  $($exeTime.Hours.ToString("00")) h $($exeTime.Minutes.ToString("00")) m $($exeTime.Seconds.ToString("00")) s"
		$message08 = "Insert To SQL DB--:  $($insTime.Hours.ToString("00")) h $($insTime.Minutes.ToString("00")) m $($insTime.Seconds.ToString("00")) s"
		$message09 = "Count Stores------:  $($couTime.Hours.ToString("00")) h $($couTime.Minutes.ToString("00")) m $($couTime.Seconds.ToString("00")) s"
		$message10 = "Create PK in STG--:  $($pkcTime.Hours.ToString("00")) h $($pkcTime.Minutes.ToString("00")) m $($pkcTime.Seconds.ToString("00")) s"
		$message11 = "Move Data To Prod-:  $($movTime.Hours.ToString("00")) h $($movTime.Minutes.ToString("00")) m $($movTime.Seconds.ToString("00")) s"
		$message12 = "Cleanup-----------:  $($cleTime.Hours.ToString("00")) h $($cleTime.Minutes.ToString("00")) m $($cleTime.Seconds.ToString("00")) s"
		$message13 = "Total Run Time----:  $($totTime.Hours.ToString("00")) h $($totTime.Minutes.ToString("00")) m $($totTime.Seconds.ToString("00")) s"
		$message14 = "Total File Count--:  $fileCount"
		$message15 = "Empty File Count--:  $emptyFileCount"
		$message16 = "Total Row Count---:  $($totalFileRowCount.ToString('N0'))"
		$message17 = "Total Headers-----:  $($sqlHeadersCountResults.Count.ToString('N0'))"
		$message18 = "Total Details-----:  $($sqlDetailsCountResults.Count.ToString('N0'))"
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message01
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message02
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message03
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message04
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message05
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message06
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message07
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message08
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message09
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message10
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message11
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message12
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message13
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message14
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message15
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message16
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message17
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $message18
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
			BodyAsHtml = $true;
			Subject = "BITC: $($processDate): ETL Process Finished";
			Body = @"
				Raw files from the 7-11 data lake have been processed and inserted into the database.<br>
				<br>
				<font face='courier'>
				$message01<br>
				$message02<br>
				$message03<br>
				$message04<br>
				$message05<br>
				$message06<br>
				$message07<br>
				$message08<br>
				$message09<br>
				$message10<br>
				$message11<br>
				$message12<br>
				$message13<br>
				$message14<br>
				$message15<br>
				$message16<br>
				$message17<br>
				$message18<br>
				</font>
				<br>
				Store Count By Day In Folder $processDate :<br>
				$storeCountHtml
"@
		}
		Send-MailMessage @params
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject '::ETL SUCCESSFUL::'
		$y++
		If ($y -lt $range) {
			Write-Output "Starting next day in 10..."
			Start-Sleep -Seconds 1
			Write-Output "9..."
			Start-Sleep -Seconds 1
			Write-Output "8..."
			Start-Sleep -Seconds 1
			Write-Output "7..."
			Start-Sleep -Seconds 1
			Write-Output "6..."
			Start-Sleep -Seconds 1
			Write-Output "5..."
			Start-Sleep -Seconds 1
			Write-Output "4..."
			Start-Sleep -Seconds 1
			Write-Output "3..."
			Start-Sleep -Seconds 1
			Write-Output "2..."
			Start-Sleep -Seconds 1
			Write-Output "1..."
			Start-Sleep -Milliseconds 400
			Write-Output "Too late :P"
			Start-Sleep -Milliseconds 256
		}
	} # while
	$exitCode = 0
} # try
Catch {
	Add-Content -Value $($_.Exception.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.Exception.InnerException.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.Exception.InnerException.InnerException.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.CategoryInfo.Activity) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.CategoryInfo.Reason) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($_.InvocationInfo.Line) -Path $opsLog -ErrorAction Stop
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $failEmailList;
		BodyAsHtml = $true;
		Subject = "BITC: ::ERROR:: ETL Failed For $processDate!!!";
		Body = @"
			<font face='consolas'>
			Something bad happened!!!<br><br>
			$($_.Exception.Message)<br>
			$($_.Exception.InnerException.Message)<br>
			$($_.Exception.InnerException.InnerException.Message)<br>
			$($_.CategoryInfo.Activity)<br>
			$($_.CategoryInfo.Reason)<br>
			$($_.InvocationInfo.Line)<br>
			</font>
"@
	}
	Send-MailMessage @params
	If ($(Test-Path -Path $archiveRootPath) -eq $false) {
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Creating $archiveRootPath..."
		New-Item -ItemType Directory -Path $archiveRootPath -Force -ErrorAction Stop > $null
	}
	If ($(Test-Path -Path $($destinationRootPath + $processDate)) -eq $true) {
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Moving data to $archiveRootPath..."
		Move-Item -Path $($destinationRootPath + $processDate) -Destination $archiveRootPath -Force -ErrorAction Stop
	}
	$exitCode = 1
}
Finally {
	Write-Output 'Finally...'
	Get-Job | Remove-Job -Force
	Remove-Item -Path $destinationRootPath -Recurse -Force -ErrorAction SilentlyContinue
	Add-Content -Value "$(New-TimeStamp -forFileName) :: $($MyInvocation.MyCommand.Name) :: End" -Path '\\MS-SSW-CRM-MGMT\Data\Ops_Log\bitc.log'
}
Return $exitCode

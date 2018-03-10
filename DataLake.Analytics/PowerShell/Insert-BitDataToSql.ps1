# Version  --  v2.0.1.2
######################################################
## need to imporve multithreading
## Add logic to check bcp error file for content
## add logic to compare row count from output.json
## finish error handling for optimus failure
######################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $true, HelpMessage = 'Is this for the store report, or the CEO dashboard?')][ValidateSet('s', 'c')][string]$report,
	[parameter(Mandatory = $false)][switch]$autoDate,
	[parameter(Mandatory = $false)][switch]$test = $true
)
##   Enter your 7-11 user name without domain:
$userName = 'gpink003'
##   Enter the range of aggregate files you want to download in mm-dd-yyyy format:
$startDate = '02-08-2018'
$endDate   = '03-12-2018'
##   Enter the transactions you would like to filter for:
$transTypes = 'D1121,D1122'
##   Enter the path where you want the raw files to be downloaded on your local machine:
$destinationRootPath = 'D:\BIT_CRM\'
$archiveRootPath = 'H:\BIT_CRM\'
##   Enter the path where you want the error logs to be stored:
$errLogRootPath = 'H:\Err_Log\'
##   Enter the email address's desired for notifications and path for log:
If ($test.IsPresent -eq $true) {
	$emailList = 'graham.pinkston@ansira.com'
	$failEmailList = 'graham.pinkston@ansira.com'
	If ($report -eq 's') {
		$opsLogRootPath = 'H:\Ops_Log\ETL\Store\Test\'
	}
	ElseIf ($report -eq 'c') {
		$opsLogRootPath = 'H:\Ops_Log\ETL\CEO\Test\'
	}
}
Else {
	[string[]]$emailList = `
	'graham.pinkston@ansira.com', `
	'mayank.minawat@ansira.com', `
	'tyler.bailey@ansira.com', `
	'DIST-SEI_CRM_STATUS@7-11.com', `
	'catherine.wells@ansira.com', `
	'britten.morse@ansira.com', `
	'Geri.Shaeffer@Ansira.com', `
	'megan.morace@ansira.com'
	[string[]]$failEmailList = `
	'graham.pinkston@ansira.com', `
	'mayank.minawat@ansira.com', `
	'tyler.bailey@ansira.com'
	If ($report -eq 's') {
		$opsLogRootPath = 'H:\Ops_Log\ETL\Store\'
	}
	ElseIf ($report -eq 'c') {
		$opsLogRootPath = 'H:\Ops_Log\ETL\CEO\'
	}
}
## Base name of staging tables to insert data to
[string]$stgTable121 = 'stg_121_Headers'
[string]$stgTable122 = 'stg_122_Details'
[string]$prodTable121 = 'prod_121_Headers'
[string]$prodTable122 = 'prod_122_Details'
#######################################################################################################
## These parametser probably won't change
$dataLakeSubId = 'ee691273-18af-4600-bc24-eb6768bf9cfa'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$sqlServer = 'mstestsqldw.database.windows.net'
$database = '7ELE'
$sqlUser = 'sqladmin'
$sqlPass = Get-Content -Path 'C:\Scripts\Secrets\sqlAdmin.txt' -ErrorAction Stop
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$dataLakeSearchPathRoot = '/BIT_CRM/'
$dataLakeStoreName = '711dlprodcons01'
$extractorExe = "C:\Scripts\C#\Release\Ansira.Sel.BITC.DataExtract.Processor.exe"
$headersMoveSp = 'usp_Staging_To_Prod_Headers'
$detailsMoveSp = 'usp_Staging_To_Prod_Details'
## Here we are nulling out some important variables since PowerISE likes to maintain the runspace
$table = $null
$file = $null
$fileCount = $null
$emptyFileList = $null
$storeCountResults = $null
$i = 0
#######################################################################################################
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
Function Get-DataLakeRawFiles {
	[CmdletBinding()]
	Param(
		[string]$dataLakeSearchPath,
		[string]$destinationPath,
		[string]$dataLakeStoreName,
		[string]$opsLog
	)
	Try {
		If ($(Test-Path -Path $destinationPath) -eq $true) {
			$message = "$(Create-TimeStamp)  Removing folder $destinationPath ..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			Remove-Item -Path $destinationPath -Force -Recurse -ErrorAction Stop | Out-Null
		}
		$message = "$(Create-TimeStamp)  Validating $dataLakeSearchPath exists in data lake..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		$getParams = @{
			Account = $dataLakeStoreName;
			Path = $dataLakeSearchPath;
			ErrorAction = 'SilentlyContinue';
		}
		$dataLakeFolder = Get-AzureRmDataLakeStoreItem @getParams
		If ($dataLakeFolder -eq $null) {
			throw [System.IO.DirectoryNotFoundException] "$dataLakeSearchPath NOT FOUND!!!"
		}
		$message = "$(Create-TimeStamp)  Downloading folder $($dataLakeFolder.Path)..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		$exportParams = @{
			Account = $dataLakeStoreName;
			Path = $($dataLakeFolder.Path);
			Destination = $destinationPath;
			Force = $true;
			ErrorAction = 'SilentlyContinue';
		}
		Export-AzureRmDataLakeStoreItem @exportParams
		$message = "$(Create-TimeStamp)  Folder $($dataLakeFolder.Path) downloaded successfully."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	}
	Catch {
		throw $_
	}
}
Function Split-FilesAmongFolders {
	[CmdletBinding()]
	Param(
		[string]$inFolder,
		[string]$opsLog
	)
	$global:fileCount = $null
	$global:emptyFileCount = $null
	$global:emptyFileList = @()
	$files = Get-ChildItem -Path $inFolder -File -ErrorAction Stop
	$emptyFiles = Get-ChildItem -Path $inFolder -File | Where-Object -FilterScript {$_.Length -lt 92}
	$global:fileCount = $files.Count.ToString()
	$global:emptyFileCount = $emptyFiles.Count.ToString()
	$message = "$(Create-TimeStamp)  Found $fileCount total files..."
	Write-Verbose -Message $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	$message = "$(Create-TimeStamp)  Found $emptyFileCount EMPTY files..."
	Write-Verbose -Message $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	ForEach ($emptyFile in $emptyFiles) {
		$global:emptyFileList += $emptyFile.Name
	}
	$i = 1
	$count = 5
	$folderPreFix = 'bucket_'
	While ($i -lt $($count + 1)) {
		$dirName = $folderPreFix + $i
		$dirPath = $inFolder + $dirName
		If ($(Test-Path -Path $dirPath) -eq $false) {
			$message = "$(Create-TimeStamp)  Creating folder:  $dirPath ..."
			Write-Verbose -Message $message
			New-Item -ItemType Directory -Path $dirPath -Force -ErrorAction Stop | Out-Null
		}
		Else {
			Get-ChildItem -Path $dirPath -Recurse | Remove-Item -Force -ErrorAction Stop
		}
		$i++
	}
	[int]$divider = $($files.Count / $count) - 0.5
	$i = 0
	$message = "$(Create-TimeStamp)  Separating files into bucket folders..."
	Write-Verbose -Message $message
	Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	While ($i -lt $($files.Count)) {
		If ($i -lt $divider) {
			$movePath = $inFolder + $folderPreFix + '1'
		}
		ElseIf ($i -ge $divider -and $i -lt $($divider * 2)) {
			$movePath = $inFolder + $folderPreFix + '2'
		}
		ElseIf ($i -ge $($divider * 2) -and $i -lt $($divider * 3)) {
			$movePath = $inFolder + $folderPreFix + '3'
		}
		ElseIf ($i -ge $($divider * 3) -and $i -lt $($divider * 4)) {
			$movePath = $inFolder + $folderPreFix + '4'
		}
		Else {
			$movePath = $inFolder + $folderPreFix + '5'
		}
		Move-Item -Path $files[$i].FullName -Destination $movePath -Force -ErrorAction Stop
		$i++
	}
	$folders = Get-ChildItem -Path $inFolder -Directory
	ForEach ($folder in $folders) {
		$block = {
			[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
			$path = $args[0]
			$files = Get-ChildItem -Path $path -Filter '*.gz' -File
			ForEach ($file in $files) {
				Expand-7Zip -ArchiveFileName $($file.FullName) -TargetPath $path -ErrorAction Stop
				Remove-Item -Path $($file.FullName) -Force -ErrorAction Stop
			}
		}
		$message = "$(Create-TimeStamp)  Starting decompress job:  $($folder.FullName)..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		Start-Job -ScriptBlock $block -ArgumentList $($folder.FullName) -ErrorAction Stop
		Start-Sleep -Milliseconds 128
	}
	Write-Output "$(Create-TimeStamp)  Spliting and decompressing..."
	Get-Job | Wait-Job
	Get-Job | Remove-Job -ErrorAction Stop
}
Function Convert-BitFilesToCsv {
	[CmdletBinding()]
	Param(
		[string]$inFolder,
		[string]$transTypes,
		[string]$extractorExe,
		[string]$filePrefix,
		[string]$opsLog
	)
	$folders = Get-ChildItem -Path $inFolder -Directory -ErrorAction Stop
	ForEach ($folder in $folders) {
		$outputPath = $($folder.Parent.FullName) + '\' + $($folder.Name) + '_Output\'
		If ($(Test-Path -Path $outputPath) -eq $false) {
			$message = "$(Create-TimeStamp)  Creating folder:  $outputPath ..."
			Write-Verbose -Message $message
			New-Item -ItemType Directory -Path $outputPath -Force -ErrorAction Stop | Out-Null
		}
		$block = {
			[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
			& $args[0] $args[1..4];
			Remove-Item -Path $($args[1]) -Recurse -Force -ErrorAction Stop;
		}
		$message = "$(Create-TimeStamp)  Starting convert job:  $($folder.FullName)..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		Start-Job -ScriptBlock $block -ArgumentList "$extractorExe", "$($folder.FullName)", "$outputPath", "$transTypes", "$filePrefix" -ErrorAction Stop
		Start-Sleep -Milliseconds 128
	}
	Write-Output "$(Create-TimeStamp)  Converting..."
	Get-Job | Wait-Job
	Get-Job | Remove-Job -ErrorAction Stop
	Add-Content -Value "$(Create-TimeStamp)  Optimus Report:" -Path $opsLog -ErrorAction Stop
	$folders = Get-ChildItem -Path $inFolder -Directory -ErrorAction Stop
	ForEach ($folder in $folders) {
		$outputFile = Get-ChildItem -Path $($folder.FullName) -Recurse -File -Filter "*output*" -ErrorAction Stop
		$jsonObj = Get-Content -Raw -Path $outputFile.FullName -ErrorAction Stop | ConvertFrom-Json
		If ($jsonObj.ResponseCode -ne 0) {
			[string]$global:optimusError = $jsonObj.ResponseMsg
			throw [OptimusException] "Optimus Failed!!!"
		}
		Else {
			Add-Content -Value "$($folder.FullName)" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "TotalNumRecords: $($jsonObj.TotalNumRecords)" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "TotalNumFiles: $($jsonObj.TotalNumFiles)" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "-------------------------------------------------" -Path $opsLog -ErrorAction Stop
		}
	}
}
Function Add-CsvsToSql {
	[CmdletBinding()]
	Param(
		[System.IO.FileInfo[]]$structuredFiles,
		[string]$errLogRoot,
		[string]$opsLog
	)
	$hext = 1
	$dext = 1
	$jobN = 1
	$jobBase = 'bcp_job_'
	Add-Content -Value "$(Create-TimeStamp)  Starting BCP jobs..." -Path $opsLog -ErrorAction Stop
	ForEach ($file in $structuredFiles) {
		Write-Output "$(Create-TimeStamp)  Inserting $($file.FullName)..."
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
			throw [System.FormatException] "ERROR:: $($file.FullName) didn't mach any patteren!"
		}
		$errLogFile = $errLogRoot + $($file.BaseName) + '_' + $($file.Directory.Name) + '_BCP_Error.log'
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
		Start-Job -ScriptBlock $block -Name $jobName -ArgumentList `
			"$command", ` #0
			"$query", ` #1
			"$sqlServer", ` #2
			"$database", ` #3
			"$sqlUser", ` #4
			"$sqlPass" #5
		$jobN++
	}
	Write-Output "$(Create-TimeStamp)  Inserting..."
	Add-Content -Value "$(Create-TimeStamp)  BCP Results:" -Path $opsLog -ErrorAction Stop
	$jobN = 1
	While ($jobN -lt $($structuredFiles.Count + 1)) {
		[string]$jobName = $jobBase + $jobN
		Write-Output "$(Create-TimeStamp)  Waiting on $jobName..."
		Get-Job -Name $jobName | Wait-Job
		$global:bcpJobResults = Receive-Job -Name $jobName
		If ($bcpJobResults[$bcpJobResults.Count - 3] -notlike "*copied*") {
			Add-Content -Value "$(Create-TimeStamp)  BCP FAILED!!!" -Path $opsLog -ErrorAction Stop
			Add-Content -Value $bcpJobResults -Path $opsLog -ErrorAction Stop
			throw [System.Activities.WorkflowApplicationException] "ERROR:: BCP FAILED!"
		}
		Else {
			Add-Content -Value $bcpJobResults -Path $opsLog -ErrorAction Stop
			Add-Content -Value "------------------------------------------------------------------------------" -Path $opsLog -ErrorAction Stop
			Remove-Job -Name $jobName
		}
		$jobN++
	}
}
Function Add-PkToStgData {
	[CmdletBinding()]
	Param(
		[string]$dataLakeFolder
	)
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
		Start-Job -ScriptBlock $block -Name $jobName -ArgumentList `
			"$($stgTable121)_$i", ` #0
			"$($stgTable122)_$i", ` #1
			"$dataLakeFolder", ` #2
			"$sqlServer", ` #3
			"$database", ` #4
			"$sqlUser", ` #5
			"$sqlPass" #6
		$i++
	}
	$i = 1
	While ($i -lt 6) {
		[string]$jobName = $jobBase + $i
		Get-Job -Name $jobName | Wait-Job
		$pkResult = Receive-Job -Name $jobName
		If ($pkResult -ne 'Successful') {
			throw [PkError] 'Failed to create PKs in Staging!!!'
		}
		Else {
			Remove-Job -Name $jobName
		}
		$i++
	}
}
Function Confirm-Run {
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Start Date    ::  $startDate"
	Write-Host "End Date      ::  $endDate"
	Write-Host "Transactions  ::  $transTypes"
	Write-Host "stgTable121   ::  $stgTable121"
	Write-Host "stgTable122   ::  $stgTable122"
	Write-Host "121 Move SP   ::  $headersMoveSp"
	Write-Host "122 Move SP   ::  $detailsMoveSp"
	Write-Host '********************************************************************' -ForegroundColor Magenta
	$answer = Read-Host -Prompt "Are you sure you want to start? (y/n)"
	Return $answer
}
# Init
[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
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
If ($autoDate.IsPresent -eq $false) {
	$startDateObj = Get-Date -Date $startDate -ErrorAction Stop
	$endDateObj = Get-Date -Date $endDate -ErrorAction Stop
	$continue = Confirm-Run
}
Else {
	$startDateObj = Get-Date -ErrorAction Stop
	$endDateObj = $startDateObj
	$continue = 'y'
}
If ($continue -eq 'y') {
	Write-Verbose -Message "$(Create-TimeStamp)  Importing AzureRm, 7Zip, and SqlServer modules..."
	Import-Module SqlServer -ErrorAction Stop
	Import-Module AzureRM -ErrorAction Stop
	Import-Module 7Zip -ErrorAction Stop
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass)
	Try {
		$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
		While ($i -lt $range) {
			$startTime = Get-Date
			$startTimeText = $(Create-TimeStamp -forFileName)
			$day = $($startDateObj.AddDays($i)).day.ToString("00")
			$month = $($startDateObj.AddDays($i)).month.ToString("00")
			$year = $($startDateObj.AddDays($i)).year.ToString("0000")
			$processDate = $year + $month + $day
			$opsLog = $opsLogRootPath + $processDate + '_' + $startTimeText + '_BITC.log'
			If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
				New-Item -ItemType Directory -Path $opsLogRootPath -Force -ErrorAction Stop | Out-Null
				Add-Content -Value "$(Create-TimeStamp)  Process Date: $processDate" -Path $opsLog -ErrorAction Stop
				Add-Content -Value "$(Create-TimeStamp)  Created folder: $opsLogRootPath..." -Path $opsLog -ErrorAction Stop
			}
			Else {
				Add-Content -Value "$(Create-TimeStamp)  Process Date: $processDate" -Path $opsLog -ErrorAction Stop
			}
			If ($(Test-Path -Path $destinationRootPath) -eq $false) {
				Add-Content -Value "$(Create-TimeStamp)  Creating folder: $destinationRootPath..." -Path $opsLog -ErrorAction Stop
				New-Item -ItemType Directory -Path $destinationRootPath -Force -ErrorAction Stop | Out-Null
			}
			If ($(Test-Path -Path $archiveRootPath) -eq $false) {
				Add-Content -Value "$(Create-TimeStamp)  Creating folder: $archiveRootPath..." -Path $opsLog -ErrorAction Stop
				New-Item -ItemType Directory -Path $archiveRootPath -Force -ErrorAction Stop | Out-Null
			}
			If ($(Test-Path -Path $errLogRootPath) -eq $false) {
				Add-Content -Value "$(Create-TimeStamp)  Creating folder: $errLogRootPath..." -Path $opsLog -ErrorAction Stop
				New-Item -ItemType Directory -Path $errLogRootPath -Force -ErrorAction Stop | Out-Null
			}
			Add-Content -Value "$(Create-TimeStamp)  Logging into Azure..." -Path $opsLog -ErrorAction Stop
			Login-AzureRmAccount -Credential $credential -Subscription $dataLakeSubId -ErrorAction Stop
			Add-Content -Value "$(Create-TimeStamp)  Login successful." -Path $opsLog -ErrorAction Stop
# Get raw files
			$getDataLakeRawFilesParams = @{
				dataLakeSearchPath = $($dataLakeSearchPathRoot + $processDate);
				destinationPath = $($destinationRootPath + $processDate + '\');
				dataLakeStoreName = $dataLakeStoreName;
				opsLog = $opsLog;
			}
			Get-DataLakeRawFiles @getDataLakeRawFilesParams
# Seperate files into 5 seperate folders for paralell processing
			$milestone_1 = Get-Date
			$splitFilesAmongFoldersParams = @{
				inFolder = $($destinationRootPath + $processDate + '\');
				opsLog = $opsLog;
			}
			Split-FilesAmongFolders @splitFilesAmongFoldersParams
# Execute C# app as job on raw files to create CSV's
			$milestone_2 = Get-Date
			$convertBitFilesToCsvParams = @{
				inFolder = $($destinationRootPath + $processDate + '\');
				transTypes = $transTypes;
				extractorExe = $extractorExe;
				filePrefix = $processDate;
				opsLog = $opsLog;
			}
			Convert-BitFilesToCsv @convertBitFilesToCsvParams
# Insert CSV's to DB (stg tables)
			$milestone_3 = Get-Date
			$message = "$(Create-TimeStamp)  Truncating staging tables..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
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
			$message = "$(Create-TimeStamp)  Truncating staging tables successful."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			$structuredFiles = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Recurse -File -Filter "*Structured*" -ErrorAction Stop
			$addCsvsToSqlParams = @{
				structuredFiles = $structuredFiles;
				errLogRoot = $errLogRootPath;
				opsLog = $opsLog;
			}
			Add-CsvsToSql @addCsvsToSqlParams
# Count stores by day in stg header table and compare rows in database to rows in files
			$milestone_4 = Get-Date
			$block = {
				$files = Get-ChildItem -Recurse -File -Path $($args[0]) -Filter "*Structured*"
				$total = 0
				ForEach ($file in $files) {
					$count = 0
					Get-Content -Path $($file.FullName) -ReadCount 250000 | ForEach-Object {$count += $_.Count}
					$total = $total + $count
				}
				Return $total
			}
			Write-Output "$(Create-TimeStamp)  Counting and comparing..."
			$rowsInFilesJobResults = Start-Job -ScriptBlock $block -ArgumentList "$($destinationRootPath + $processDate + '\')"
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
			$message = "Store Count By Day:"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			$t = 0
			While ($t -lt $($storeCountResults.EndDate.Count)) {
				Add-Content -Value "$($storeCountResults.EndDate.Get($t))  |  $($storeCountResults.StoreCount.Get($t))" -Path $opsLog -ErrorAction Stop
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
			Get-Job | Wait-Job
			$totalFileRowCount = $(Receive-Job $rowsInFilesJobResults) - $($transTypes.Split(',').Count * 5)
			Get-Job | Remove-Job
			$totalSqlRowCount = $($sqlHeadersCountResults.Count) + $($sqlDetailsCountResults.Count)
			Add-Content -Value "$(Create-TimeStamp)  Total Headers Rows: $($sqlHeadersCountResults.Count.ToString('N0'))" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "$(Create-TimeStamp)  Total Details Rows: $($sqlDetailsCountResults.Count.ToString('N0'))" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "$(Create-TimeStamp)  Total File Rows: $($totalFileRowCount.ToString('N0'))" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "$(Create-TimeStamp)  Total DB Rows: $($totalSqlRowCount.ToString('N0'))" -Path $opsLog -ErrorAction Stop
			If ($totalFileRowCount -ne $totalSqlRowCount) {
				throw [System.InvalidOperationException] "ROW COUNT MISMATCH"
			}
# Create PK and move data in DB from stg to prod
			$milestone_5 = Get-Date
			$message = "$(Create-TimeStamp)  Creating PK's on data in staging tables..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			Write-Output "$(Create-TimeStamp)  Adding PK's..."
			Add-PkToStgData -dataLakeFolder $($dataLakeSearchPathRoot + $processDate)
			$message = "$(Create-TimeStamp)  Finished creating PK's on data in staging tables!"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			$milestone_6 = Get-Date
			$message = "$(Create-TimeStamp)  Moving data from staging tables to production tables..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			$i = 1
			$sqlStgToProdParams = @{
				query = "EXECUTE [dbo].[$headersMoveSp]";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			$message = "$(Create-TimeStamp)  Moving headers to prod..."
			Write-Output $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			Invoke-Sqlcmd @sqlStgToProdParams
			$sqlStgToProdParams = @{
				query = "EXECUTE [dbo].[$detailsMoveSp]";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			$message = "$(Create-TimeStamp)  Moving details to prod..."
			Write-Output $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			Invoke-Sqlcmd @sqlStgToProdParams
			$message = "$(Create-TimeStamp)  Move complete!"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
# Move data from temp drive to archive
			If ($(Test-Path -Path $($archiveRootPath + $processDate)) -eq $true) {
				Add-Content -Value "$(Create-TimeStamp)  Removing folder: $($archiveRootPath + $processDate)..." -Path $opsLog -ErrorAction Stop
				Remove-Item -Path $($archiveRootPath + $processDate) -Recurse -Force -ErrorAction Stop
				Add-Content -Value "$(Create-TimeStamp)  Folder removed successfully." -Path $opsLog -ErrorAction Stop
			}
			Add-Content -Value "$(Create-TimeStamp)  Moving folder to archive: $($destinationRootPath + $processDate)..." -Path $opsLog -ErrorAction Stop
			Move-Item -Path $($destinationRootPath + $processDate) -Destination $archiveRootPath -Force -ErrorAction Stop
# Send report
			$endTime = Get-Date
			$endTimeText = $(Create-TimeStamp -forFileName)
			$htmlEmptyFileList = @()
			ForEach ($item in $emptyFileList) {
				$htmlEmptyFileList += $item + '<br>'
			}
			$rawTime = New-TimeSpan -Start $startTime -End $milestone_1
			$sepTime = New-TimeSpan -Start $milestone_1 -End $milestone_2
			$exeTime = New-TimeSpan -Start $milestone_2 -End $milestone_3
			$insTime = New-TimeSpan -Start $milestone_3 -End $milestone_4
			$couTime = New-TimeSpan -Start $milestone_4 -End $milestone_5
			$pkcTime = New-TimeSpan -Start $milestone_5 -End $milestone_6
			$movTime = New-TimeSpan -Start $milestone_6 -End $endTime
			$totTime = New-TimeSpan -Start $startTime -End $endTime
			$message0 = "Data Lake Folder--:  $($dataLakeSearchPathRoot + $processDate)"
			$messageA = "Start Time--------:  $startTimeText"
			$messageB = "End Time----------:  $endTimeText"
			$messageC = "Raw File Download-:  $($rawTime.Hours.ToString("00")) h $($rawTime.Minutes.ToString("00")) m $($rawTime.Seconds.ToString("00")) s"
			$messageD = "Decompression-----:  $($sepTime.Hours.ToString("00")) h $($sepTime.Minutes.ToString("00")) m $($sepTime.Seconds.ToString("00")) s"
			$messageE = "File Processing---:  $($exeTime.Hours.ToString("00")) h $($exeTime.Minutes.ToString("00")) m $($exeTime.Seconds.ToString("00")) s"
			$messageF = "Insert To SQL DB--:  $($insTime.Hours.ToString("00")) h $($insTime.Minutes.ToString("00")) m $($insTime.Seconds.ToString("00")) s"
			$messageG = "Count Stores------:  $($couTime.Hours.ToString("00")) h $($couTime.Minutes.ToString("00")) m $($couTime.Seconds.ToString("00")) s"
			$messageH = "Create PK in STG--:  $($pkcTime.Hours.ToString("00")) h $($pkcTime.Minutes.ToString("00")) m $($pkcTime.Seconds.ToString("00")) s"
			$messageI = "Move Data To Prod-:  $($movTime.Hours.ToString("00")) h $($movTime.Minutes.ToString("00")) m $($movTime.Seconds.ToString("00")) s"
			$messageJ = "Total Run Time----:  $($totTime.Hours.ToString("00")) h $($totTime.Minutes.ToString("00")) m $($totTime.Seconds.ToString("00")) s"
			$messageK = "Total File Count--:  $fileCount"
			$messageL = "Empty File Count--:  $emptyFileCount"
			$messageM = "Total Row Count---:  $($totalFileRowCount.ToString('N0'))"
			$messageN = "Total Headers-----:  $($sqlHeadersCountResults.Count.ToString('N0'))"
			$messageO = "Total Details-----:  $($sqlDetailsCountResults.Count.ToString('N0'))"
			Write-Output $message0
			Write-Output $messageA
			Write-Output $messageB
			Write-Output $messageC
			Write-Output $messageD
			Write-Output $messageE
			Write-Output $messageF
			Write-Output $messageG
			Write-Output $messageH
			Write-Output $messageI
			Write-Output $messageJ
			Write-Output $messageK
			Write-Output $messageL
			Write-Output $messageM
			Write-Output $messageN
			Write-Output $messageO
			Write-Output $emptyFileList
			Add-Content -Value $message0 -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageA -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageB -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageC -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageD -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageE -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageF -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageG -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageH -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageI -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageJ -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageK -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageL -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageM -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageN -Path $opsLog -ErrorAction Stop
			Add-Content -Value $messageO -Path $opsLog -ErrorAction Stop
			Add-Content -Value $emptyFileList -Path $opsLog -ErrorAction Stop
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
					$message0<br>
					$messageA<br>
					$messageB<br>
					$messageC<br>
					$messageD<br>
					$messageE<br>
					$messageF<br>
					$messageG<br>
					$messageH<br>
					$messageI<br>
					$messageJ<br>
					$messageK<br>
					$messageL<br>
					$messageM<br>
					$messageN<br>
					$messageO<br>
					</font>
					<br>
					Store Count By Day In Folder $processDate :<br>
					$storeCountHtml
					<br>
					Empty File List:<br>
					$htmlEmptyFileList<br>
"@
			}
			Send-MailMessage @params
			Add-Content -Value '::ETL SUCCESSFUL::' -Path $opsLog -ErrorAction Stop
			$i++
			If ($i -lt $range) {
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
		}
	}
	Catch [System.InvalidOperationException] {
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog -ErrorAction Stop
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $failEmailList;
			BodyAsHtml = $true;
			Subject = "BITC: ::ERROR:: FAILED For $processDate!!!";
			Body = @"
				<font face='consolas'>
				File row count doesn't match database row count!!! Please check the ops log!!!<br><br>
				<br>
				Error:  $($Error[0].Exception.Message)<br>
				</font>
"@
		}
		Send-MailMessage @params
	}
	Catch [System.IO.DirectoryNotFoundException] {
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog -ErrorAction Stop
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $failEmailList;
			BodyAsHtml = $true;
			Subject = "BITC: ::ERROR:: FAILED For $processDate!!!";
			Body = @"
				<font face='consolas'>
				Something bad happened!!!<br><br>
				Failed Command:  $($Error[0].CategoryInfo.Activity)<br>
				<br>
				Error:  $($Error[0].Exception.Message)<br>
				</font>
"@
		}
		Send-MailMessage @params
	}
	Catch [System.FormatException] {
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog -ErrorAction Stop
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $failEmailList;
			BodyAsHtml = $true;
			Subject = "BITC: ::ERROR:: FAILED For $processDate!!!";
			Body = @"
				<font face='consolas'>
				Something bad happened!!!<br><br>
				Failed Command:  $($Error[0].CategoryInfo.Activity)<br>
				<br>
				Error:  $($Error[0].Exception.Message)<br>
				</font>
"@
		}
		Send-MailMessage @params
	}
	Catch [System.Activities.WorkflowApplicationException] {
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog -ErrorAction Stop
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $failEmailList;
			BodyAsHtml = $true;
			Subject = "BITC: ::ERROR:: FAILED For $processDate!!!";
			Body = @"
				<font face='consolas'>
				Something bad happened!!!<br><br>
				Failed Command:  BCP<br>
				<br>
				$bcpJobResults<br>
				</font>
"@
		}
		Send-MailMessage @params
	}
	Catch [System.ArgumentOutOfRangeException] {
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog -ErrorAction Stop
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $failEmailList;
			BodyAsHtml = $true;
			Subject = "BITC: ::ERROR:: FAILED For $processDate!!!";
			Body = @"
				<font face='consolas'>
				Something bad happened!!!<br><br>
				Failed Command:  $($Error[0].CategoryInfo.Activity)<br>
				<br>
				Error:  $($Error[0].Exception.Message)<br>
				</font>
"@
		}
		Send-MailMessage @params
	}
	Catch {
		$errorParams = @{
			Exception = $Error[0].Exception;
			Message = $Error[0].Exception.Message;
			CategoryActivity = $Error[0].CategoryInfo.Activity;
		}
		Write-Error @errorParams
		Add-Content -Value $($Error[0].CategoryInfo.Activity) -Path $opsLog -ErrorAction Stop
		Add-Content -Value $($Error[0].Exception.Message) -Path $opsLog -ErrorAction Stop
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $failEmailList;
			BodyAsHtml = $true;
			Subject = "BITC: ::ERROR:: FAILED For $processDate!!!";
			Body = @"
				<font face='consolas'>
				Something bad happened!!!<br><br>
				Failed Command:  $($Error[0].CategoryInfo.Activity)<br>
				<br>
				Error:  $($Error[0].Exception.Message)<br>
				</font>
"@
		}
		Send-MailMessage @params
	}
	Finally {
		Get-Job | Remove-Job
		Remove-Item -Path $archiveRootPath -Recurse -Force -ErrorAction Stop
	}
}

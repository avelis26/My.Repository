# Init  --  v1.5.3.2
#######################################################################################################
#######################################################################################################
##   Enter your 7-11 user name without domain:
[string]$global:userName = 'gpink003'
##   Enter the range of aggregate files you want to download in mm-dd-yyyy format:
[string]$global:startDate = '01-26-2018'
[string]$global:endDate   = '01-28-2018'
##   Enter the transactions you would like to filter for:
[string]$global:transTypes = 'D1121,D1122'
##   Enter the path where you want the raw files to be downloaded on your local machine:
[string]$global:destinationRootPath = 'D:\BIT_CRM\'
[string]$global:archiveRootPath = 'H:\BIT_CRM\'
##   Enter the path where you want the error logs to be stored:
[string]$global:errLogRootPath = 'H:\Err_Log\'
##   Enter the email address desired for notifications:
#[string[]]$global:emailList = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
#[string[]]$global:emailList = 'graham.pinkston@ansira.com', 'Bryan.Ingram@ansira.com', 'Cheong.Sin@Ansira.com'
[string[]]$global:emailList = 'graham.pinkston@ansira.com'
######################################################
## create failure email list and add megan and ravi ##
## check why powershell spins up only 4 jobs at a time
######################################################
##   Enter $true for verbose information output, $false faster speed:
[bool]$global:verbose = $false
## Name of staging tables to insert data to
[string]$global:table121 = 'stg_121_Headers'
[string]$global:table122 = 'stg_122_Details'
#######################################################################################################
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
		[string]$dataLakeSearchPath, # /BIT_CRM/20171216
		[string]$destinationRootPath, # H:\BIT_CRM\20171216\
		[string]$dataLakeStoreName, # 711dlprodcons01
		[string]$opsLog # H:\Ops_Log\20171216_BITC.log
	)
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
	Try {
		If ($(Test-Path -Path $destinationRootPath) -eq $true) {
			$message = "$(Create-TimeStamp)  Removing folder $destinationRootPath ..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			Remove-Item -Path $destinationRootPath -Force -Recurse -ErrorAction Stop | Out-Null
		}
		$message = "$(Create-TimeStamp)  Validating $dataLakeSearchPath exists in data lake..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog
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
		Add-Content -Value $message -Path $opsLog
		$exportParams = @{
			Account = $dataLakeStoreName;
			Path = $($dataLakeFolder.Path);
			Destination = $destinationRootPath;
			Force = $true;
			ErrorAction = 'SilentlyContinue';
		}
		Export-AzureRmDataLakeStoreItem @exportParams
		$message = "$(Create-TimeStamp)  Folder $($dataLakeFolder.Path) downloaded successfully."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog
	}
	Catch {
		throw $_
	}
}
Function Split-FilesAmongFolders {
	[CmdletBinding()]
	Param(
		[string]$inFolder, # H:\BIT_CRM\20171216\
		[string]$opsLog # H:\Ops_Log\20171216_BITC.log
	)
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
	$global:fileCount = $null
	$global:emptyFileCount = $null
	$global:emptyFileList = @()
	$files = Get-ChildItem -Path $inFolder -File -ErrorAction Stop
	$emptyFiles = Get-ChildItem -Path $inFolder -File | Where-Object -FilterScript {$_.Length -lt 92}
	$global:fileCount = $files.Count.ToString()
	$global:emptyFileCount = $emptyFiles.Count.ToString()
	$message = "$(Create-TimeStamp)  Found $fileCount total files..."
	Write-Verbose -Message $message
	Add-Content -Value $message -Path $opsLog
	$message = "$(Create-TimeStamp)  Found $emptyFileCount EMPTY files..."
	Write-Verbose -Message $message
	Add-Content -Value $message -Path $opsLog
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
			New-Item -ItemType Directory -Path $dirPath -Force | Out-Null
		}
		Else {
			Get-ChildItem -Path $dirPath -Recurse | Remove-Item -Force
		}
		$i++
	}
	[int]$divider = $($files.Count / $count) - 0.5
	$i = 0
	$message = "$(Create-TimeStamp)  Separating files into bucket folders..."
	Write-Verbose -Message $message
	Add-Content -Value $message -Path $opsLog
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
		Add-Content -Value $message -Path $opsLog
		Start-Job -ScriptBlock $block -ArgumentList $($folder.FullName)
		Start-Sleep -Seconds 1
	}
	Write-Output "$(Create-TimeStamp)  Spliting and decompressing..."
	Get-Job | Wait-Job
	Get-Job | Remove-Job
}
Function Convert-BitFilesToCsv {
	[CmdletBinding()]
	Param(
		[string]$inFolder, # H:\BIT_CRM\20171216\
		[string]$transTypes, # D1121,D1122,D1124
		[string]$extractorExe, # C:\Scripts\C#\Debug\Ansira.Sel.fileExtractor.exe
		[string]$filePrefix, # 20171216
		[string]$opsLog # H:\Ops_Log\20171216_BITC.log
	)
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
	$folders = Get-ChildItem -Path $inFolder -Directory
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
			Remove-Item -Path $($args[1]) -Recurse -Force;
		}
		$message = "$(Create-TimeStamp)  Starting convert job:  $($folder.FullName)..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog
		Start-Job -ScriptBlock $block -ArgumentList "$extractorExe", "$($folder.FullName)", "$outputPath", "$transTypes", "$filePrefix"
		Start-Sleep -Seconds 1
	}
	Write-Output "$(Create-TimeStamp)  Converting..."
	Get-Job | Wait-Job
	Get-Job | Remove-Job
}
Function Add-CsvsToSql {
	[CmdletBinding()]
	Param(
		[System.IO.FileInfo[]]$structuredFiles,
		[string]$errLogRoot, # H:\BCP_Errors\
		[string]$opsLog # H:\Ops_Log\20171216_BITC.log
	)
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
	###################################################
	## Add logic to check bcp error file for content ##
	###################################################
	Write-Output "$(Create-TimeStamp)  Inserting..."
	ForEach ($file in $structuredFiles) {
		If ($file.Name -like "*D1_121*") {
			$table = $table121
			$formatFile = "C:\Scripts\XML\format121.xml"
		}
		ElseIf ($file.Name -like "*D1_122*") {
			$table = $table122
			$formatFile = "C:\Scripts\XML\format122.xml"
		}
		Else {
			throw [System.FormatException] "ERROR:: $($file.FullName) didn't mach any patteren!"
		}
		$errLogFile = $errLogRoot + $($file.BaseName) + '_' + $($file.Directory.Name) + '_BCP_Error.log'
		$command = "bcp $table in $($file.FullName) -S $sqlServer -d $database -U $sqlUser -P $sqlPass -f $formatFile -b 10000000 -F 2 -t ',' -q -e '$errLogFile'"
		Add-Content -Value "$(Create-TimeStamp)  $command" -Path $opsLog
		$global:bcpResult = Invoke-Expression -Command $command
		If ($bcpResult[$bcpResult.Count - 3] -notlike "*copied*") {
			$global:bcpError = $Error[0]
			Add-Content -Value "$(Create-TimeStamp)  $bcpResult" -Path $opsLog
			throw [System.Activities.WorkflowApplicationException] "ERROR:: BCP FAILED!"
		}
		Else {
			Add-Content -Value "$(Create-TimeStamp)  $($bcpResult[$bcpResult.Count - 3])" -Path $opsLog
		}
		$query = "UPDATE $table SET [CsvFile] = '$($file.FullName)' WHERE [CsvFile] IS NULL"
		Add-Content -Value "$(Create-TimeStamp)  $query" -Path $opsLog
		Add-Content -Value "_" -Path $opsLog
		$sqlParams = @{
			query = $query;
			ServerInstance = $sqlServer;
			Database = $database;
			Username = $sqlUser;
			Password = $sqlPass;
			QueryTimeout = 0;
			ErrorAction = 'Stop';
		}
		Invoke-Sqlcmd @sqlParams
	}
}
Function Add-PkToStgData {
	[CmdletBinding()]
	Param(
		[string]$dataLakeFolder
	)
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
	$sqlParams = @{
		query = "UPDATE $table121 SET [DataLakeFolder] = '$dataLakeFolder', [Pk] = CONCAT([StoreNumber],'-',[DayNumber],'-',[ShiftNumber],'-',[TransactionUID])";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @sqlParams
	$sqlParams = @{
		query = "UPDATE $table122 SET [DataLakeFolder] = '$dataLakeFolder', [Pk] = CONCAT([StoreNumber],'-',[DayNumber],'-',[ShiftNumber],'-',[TransactionUID],'-',[SequenceNumber])";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @sqlParams
}
Function Confirm-Run {
	$report = Read-Host -Prompt "Store report or CEO dashboard? (s/c)"
	If ($report -eq 's') {
		$global:moveSp = 'usp_Move_STG_To_PROD'
		$global:opsLogRootPath = 'H:\Ops_Log\'
	}
	ElseIf ($report -eq 'c') {
		$global:moveSp = 'usp_Move_STG_To_PROD_CEO'
		$global:opsLogRootPath = 'H:\Ops_Log_CEO\'
	}
	Else {
		[System.ArgumentOutOfRangeException] "Only 's' or 'c' accepted!!!"
	}
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Start Date    ::  $startDate"
	Write-Host "End Date      ::  $endDate"
	Write-Host "Transactions  ::  $transTypes"
	Write-Host "Verbose       ::  $verbose"
	Write-Host "Table121      ::  $table121"
	Write-Host "Table122      ::  $table122"
	Write-Host "Move SP       ::  $moveSp"
	Write-Host '********************************************************************' -ForegroundColor Magenta
	$answer = Read-Host -Prompt "Are you sure you want to start? (y/n)"
	Return $answer
}
$continue = Confirm-Run
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
$global:smtpServer = '10.128.1.125'
$global:port = 25
$global:fromAddr = 'noreply@7-11.com'
$global:database = '7ELE'
$global:sqlUser = 'sqladmin'
$sqlPass = Get-Content -Path 'C:\Scripts\Secrets\sqlAdmin.txt' -ErrorAction Stop
$global:sqlServer = 'mstestsqldw.database.windows.net'
$global:user = $userName + '@7-11.com'
$global:dataLakeSearchPathRoot = '/BIT_CRM/'
$global:dataLakeStoreName = '711dlprodcons01'
$global:extractorExe = 'C:\Scripts\C#\Release\Ansira.Sel.BITC.DataExtract.Processor.exe'
$global:table = $null
$global:file = $null
$global:fileCount = $null
$global:emptyFileList = $null
$global:storeCountResults = $null
$i = 0
If ($continue -eq 'y') {
	Write-Verbose -Message "$(Create-TimeStamp)  Importing AzureRm, 7Zip, and SqlServer modules..."
	Import-Module SqlServer -ErrorAction Stop
	Import-Module AzureRM -ErrorAction Stop
	Import-Module 7Zip -ErrorAction Stop
	$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
	Try {
# Get raw files
		$startDateObj = Get-Date -Date $startDate
		$endDateObj = Get-Date -Date $endDate
		$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
		While ($i -lt $range) {
			$startTime = Get-Date
			$startTimeText = $(Create-TimeStamp -forFileName)
			$day = $($startDateObj.AddDays($i)).day.ToString("00")
			$month = $($startDateObj.AddDays($i)).month.ToString("00")
			$year = $($startDateObj.AddDays($i)).year.ToString("0000")
			$global:processDate = $year + $month + $day
			$global:opsLog = $opsLogRootPath + $processDate + '_' + $(Create-TimeStamp -forFileName) + '_BITC.log'
			$message = "Range: $startDate - $endDate"
			Add-Content -Value "$(Create-TimeStamp)  Logging into Azure..." -Path $opsLog
			Login-AzureRmAccount -Credential $credential -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop
			Add-Content -Value "$(Create-TimeStamp)  Login successful." -Path $opsLog
			If ($(Test-Path -Path $destinationRootPath) -eq $false) {
				Add-Content -Value "$(Create-TimeStamp)  Creating folder: $destinationRootPath..." -Path $opsLog
				New-Item -ItemType Directory -Path $destinationRootPath -Force | Out-Null
			}
			If ($(Test-Path -Path $archiveRootPath) -eq $false) {
				Add-Content -Value "$(Create-TimeStamp)  Creating folder: $archiveRootPath..." -Path $opsLog
				New-Item -ItemType Directory -Path $archiveRootPath -Force | Out-Null
			}
			If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
				Add-Content -Value "$(Create-TimeStamp)  Creating folder: $opsLogRootPath..." -Path $opsLog
				New-Item -ItemType Directory -Path $opsLogRootPath -Force | Out-Null
			}
			If ($(Test-Path -Path $errLogRootPath) -eq $false) {
				Add-Content -Value "$(Create-TimeStamp)  Creating folder: $errLogRootPath..." -Path $opsLog
				New-Item -ItemType Directory -Path $errLogRootPath -Force | Out-Null
			}
			Write-Verbose -Message $message
			Set-Content -Value $message -Path $opsLog
			$getDataLakeRawFilesParams = @{
				dataLakeSearchPath = $($dataLakeSearchPathRoot + $processDate);
				destinationRootPath = $($destinationRootPath + $processDate + '\');
				dataLakeStoreName = $dataLakeStoreName;
				opsLog = $opsLog;
				Verbose = $verbose;
			}
			Get-DataLakeRawFiles @getDataLakeRawFilesParams
# Seperate files into 5 seperate folders for paralell processing
			$milestone_1 = Get-Date
			$splitFilesAmongFoldersParams = @{
				inFolder = $($destinationRootPath + $processDate + '\');
				opsLog = $opsLog;
				Verbose = $verbose;
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
				Verbose = $verbose;
			}
			Convert-BitFilesToCsv @convertBitFilesToCsvParams
# Insert CSV's to DB (stg tables)
			$milestone_3 = Get-Date
			$message = "$(Create-TimeStamp)  Truncating staging tables..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			$sqlTruncateParams = @{
				query = "TRUNCATE TABLE [dbo].[stg_121_Headers]; TRUNCATE TABLE [dbo].[stg_122_Details];";
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
			Add-Content -Value $message -Path $opsLog
			$structuredFiles = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Recurse -File -Include "*Structured*"
			$addCsvsToSqlParams = @{
				structuredFiles = $structuredFiles;
				errLogRoot = $errLogRootPath;
				opsLog = $opsLog;
				Verbose = $verbose;
			}
			Add-CsvsToSql @addCsvsToSqlParams
# Count stores by day in stg header table and compare rows in database to rows in files
			$milestone_4 = Get-Date
			$block = {
				$files = Get-ChildItem -Recurse -File -Path $($args[0]) -Include "*Structured*"
				$total = 0
				ForEach ($file in $files) {
					$count = 0
					Get-Content -Path $($file.FullName) -ReadCount 250000 | ForEach-Object {$count += $_.Count}
					$total = $total + $count
				}
				Return $total
			}
			$job121122124 = Start-Job -ScriptBlock $block -ArgumentList "$($destinationRootPath + $processDate + '\')"
			$sqlStgToProdParams = @{
				query = "SELECT CAST([EndDate] AS char(10)) AS [EndDate], COUNT(DISTINCT([StoreNumber])) AS [StoreCount] FROM [dbo].[stg_121_Headers] GROUP BY [EndDate] ORDER BY [EndDate] DESC";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			$storeCountResults = Invoke-Sqlcmd @sqlStgToProdParams
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
			Add-Content -Value $message -Path $opsLog
			$t = 0
			While ($t -lt $($storeCountResults.EndDate.Count)) {
				Add-Content -Value "$($storeCountResults.EndDate.Get($t))  |  $($storeCountResults.StoreCount.Get($t))" -Path $opsLog
				$t++
			}
			$sql121Params = @{
				query = "SELECT COUNT([RecordID]) AS [Count] FROM [dbo].[stg_121_Headers]";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			$121CountResults = Invoke-Sqlcmd @sql121Params
			$sql122Params = @{
				query = "SELECT COUNT([RecordID]) AS [Count] FROM [dbo].[stg_122_Details]";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			$122CountResults = Invoke-Sqlcmd @sql122Params
			Write-Output "$(Create-TimeStamp)  Counting and comparing..."
			Get-Job | Wait-Job
			$totalFileRowCount = $(Receive-Job $job121122124) - $($transTypes.Split(',').Count * 5)
			Get-Job | Remove-Job
			$totalSqlRowCount = $($121CountResults.Count) + $($122CountResults.Count)
			$message = "$(Create-TimeStamp)  Total File Rows: $($totalFileRowCount.ToString('N0'))  |  Total DB Rows: $($totalSqlRowCount.ToString('N0'))"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			If ($totalFileRowCount -ne $totalSqlRowCount) {
				throw [System.InvalidOperationException] "ROW COUNT MISMATCH"
			}
# Create PK and move data in DB from stg to prod
			$milestone_5 = Get-Date
			$message = "$(Create-TimeStamp)  Creating PK's on data in staging tables..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			Write-Output "$(Create-TimeStamp)  Adding PK's..."
			Add-PkToStgData -dataLakeFolder $($dataLakeSearchPathRoot + $processDate)
			$message = "$(Create-TimeStamp)  Finished creating PK's on data in staging tables!"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			$milestone_6 = Get-Date
			$message = "$(Create-TimeStamp)  Moving data from staging tables to production tables..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			$sqlStgToProdParams = @{
				query = "EXECUTE [dbo].[$moveSp]";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			Write-Output "$(Create-TimeStamp)  Moving..."
			Invoke-Sqlcmd @sqlStgToProdParams
			$message = "$(Create-TimeStamp)  Move complete!"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
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
			$message0 = "Start Time--------:  $startTimeText"
			$message1 = "End Time----------:  $endTimeText"
			$message2 = "Raw File Download-:  $($rawTime.Hours.ToString("00")) h $($rawTime.Minutes.ToString("00")) m $($rawTime.Seconds.ToString("00")) s"
			$message3 = "Decompression-----:  $($sepTime.Hours.ToString("00")) h $($sepTime.Minutes.ToString("00")) m $($sepTime.Seconds.ToString("00")) s"
			$message4 = "File Processing---:  $($exeTime.Hours.ToString("00")) h $($exeTime.Minutes.ToString("00")) m $($exeTime.Seconds.ToString("00")) s"
			$message5 = "Insert To SQL DB--:  $($insTime.Hours.ToString("00")) h $($insTime.Minutes.ToString("00")) m $($insTime.Seconds.ToString("00")) s"
			$message6 = "Count Stores------:  $($couTime.Hours.ToString("00")) h $($couTime.Minutes.ToString("00")) m $($couTime.Seconds.ToString("00")) s"
			$message7 = "Create PK in STG--:  $($pkcTime.Hours.ToString("00")) h $($pkcTime.Minutes.ToString("00")) m $($pkcTime.Seconds.ToString("00")) s"
			$message8 = "Move Data To Prod-:  $($movTime.Hours.ToString("00")) h $($movTime.Minutes.ToString("00")) m $($movTime.Seconds.ToString("00")) s"
			$message9 = "Total Run Time----:  $($totTime.Hours.ToString("00")) h $($totTime.Minutes.ToString("00")) m $($totTime.Seconds.ToString("00")) s"
			$messageX = "Total File Count--:  $fileCount"
			$messageY = "Empty File Count--:  $emptyFileCount"
			$messageZ = "Total Row Count---:  $($totalFileRowCount.ToString('N0'))"
			Write-Output $message0
			Write-Output $message1
			Write-Output $message2
			Write-Output $message3
			Write-Output $message4
			Write-Output $message5
			Write-Output $message6
			Write-Output $message7
			Write-Output $message8
			Write-Output $message9
			Write-Output $messageX
			Write-Output $messageY
			Write-Output $messageZ
			Write-Output $emptyFileList
			Add-Content -Value $message0 -Path $opsLog
			Add-Content -Value $message1 -Path $opsLog
			Add-Content -Value $message2 -Path $opsLog
			Add-Content -Value $message3 -Path $opsLog
			Add-Content -Value $message4 -Path $opsLog
			Add-Content -Value $message5 -Path $opsLog
			Add-Content -Value $message6 -Path $opsLog
			Add-Content -Value $message7 -Path $opsLog
			Add-Content -Value $message8 -Path $opsLog
			Add-Content -Value $message9 -Path $opsLog
			Add-Content -Value $messageX -Path $opsLog
			Add-Content -Value $messageY -Path $opsLog
			Add-Content -Value $messageZ -Path $opsLog
			Add-Content -Value $emptyFileList -Path $opsLog
			$params = @{
				SmtpServer = $smtpServer;
				Port = $port;
				UseSsl = 0;
				From = $fromAddr;
				To = $emailList;
				BodyAsHtml = $true;
				Subject = "BITC: $($processDate): ETL Process Finished";
				Body = @"
Raw files from the 7-11 data lake have been processed and inserted into the database and are ready for aggregation.<br>
<br>
<font face='courier'>
				$message0<br>
				$message1<br>
				$message2<br>
				$message3<br>
				$message4<br>
				$message5<br>
				$message6<br>
				$message7<br>
				$message8<br>
				$message9<br>
				$messageX<br>
				$messageY<br>
				$messageZ<br>
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
			If ($(Test-Path -Path $($archiveRootPath + $processDate)) -eq $true) {
				Add-Content -Value "$(Create-TimeStamp)  Removing folder: $($archiveRootPath + $processDate)..." -Path $opsLog
				Remove-Item -Path $($archiveRootPath + $processDate) -Force -ErrorAction Stop
				Add-Content -Value "$(Create-TimeStamp)  Folder removed successfully." -Path $opsLog
			}
			Add-Content -Value "$(Create-TimeStamp)  Moving folder to archive: $($destinationRootPath + $processDate)..." -Path $opsLog
			Move-Item -Path $($destinationRootPath + $processDate) -Destination $archiveRootPath -Force -ErrorAction Stop
			Add-Content -Value '::ETL SUCCESSFUL::' -Path $opsLog
			Write-Output "Starting next day in 5..."
			Start-Sleep -Seconds 1
			Write-Output "4..."
			Start-Sleep -Seconds 1
			Write-Output "3..."
			Start-Sleep -Seconds 1
			Write-Output "2..."
			Start-Sleep -Seconds 1
			Write-Output "1..."
			Start-Sleep -Seconds 1
			$i++
		}
	}
	Catch [System.InvalidOperationException] {
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
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
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
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
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
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
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
			BodyAsHtml = $true;
			Subject = "BITC: ::ERROR:: FAILED For $processDate!!!";
			Body = @"
<font face='consolas'>
Something bad happened!!!<br><br>
Failed Command:  BCP<br>
<br>
$($bcpError.Exception.Message)<br>
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
		Add-Content -Value $($Error[0].CategoryInfo.Activity) -Path $opsLog
		Add-Content -Value $($Error[0].Exception.Message) -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
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
}

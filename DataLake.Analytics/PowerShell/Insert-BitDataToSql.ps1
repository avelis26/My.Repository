# Init  --  v1.3.0.0
#######################################################################################################
#######################################################################################################
##   Enter your 7-11 user name without domain:
[string]$global:userName = 'gpink003'
##   Enter the range of aggregate files you want to download in mm-dd-yyyy format:
[string]$global:startDate = '02-15-2017'
[string]$global:endDate   = '03-21-2017'
##   Enter the transactions you would like to filter for:
[string]$global:transTypes = 'D1121,D1122,D1124'
##   Enter the path where you want the raw files to be downloaded on your local machine:
[string]$global:destinationRootPath = 'H:\BIT_CRM\'
##   Enter the path where you want the operations logs to be stored:
[string]$global:opsLogRootPath = 'H:\Ops_Log\'
##   Enter the path where you want the error logs to be stored:
[string]$global:errLogRootPath = 'H:\Err_Log\'
##   Enter the email address desired for notifications:
[string[]]$global:emailList = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
######################################################
## create failure email list and add megan and ravi ##
######################################################
##   Enter $true for verbose information output, $false faster speed:
[bool]$global:verbose = $false
## Name of staging tables to insert data to
[string]$global:table121 = 'stg_121_Headers'
[string]$global:table122 = 'stg_122_Details'
[string]$global:table124 = 'stg_124_Media'
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
		$timeStamp = '_' + $year + $month + $day + '_' + $hour + $minute + $second + '_'
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
	$global:fileCount = $null
	$global:emptyFileCount = $null
	$global:emptyFileList = @()
	$files = Get-ChildItem -Path $inFolder -File -ErrorAction Stop
	$emptyFiles = Get-ChildItem -Path $inFolder -File | Where-Object -FilterScript {$_.Length -lt 1500}
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
			#Add-Content -Value $message -Path $opsLog
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
	$folders = Get-ChildItem -Path $inFolder -Directory
	ForEach ($folder in $folders) {
		$outputPath = $($folder.Parent.FullName) + '\' + $($folder.Name) + '_Output\'
		If ($(Test-Path -Path $outputPath) -eq $false) {
			$message = "$(Create-TimeStamp)  Creating folder:  $outputPath ..."
			Write-Verbose -Message $message
			#Add-Content -Value $message -Path $opsLog
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
	###################################################
	## Add logic to check bcp error file for content ##
	###################################################
	ForEach ($file in $structuredFiles) {
		If ($file.Name -like "*D1_121*") {
			$table = $table121
			$formatFile = "C:\Scripts\XML\format121.xml"
		}
		ElseIf ($file.Name -like "*D1_122*") {
			$table = $table122
			$formatFile = "C:\Scripts\XML\format122.xml"
		}
		ElseIf ($file.Name -like "*D1_124*") {
			$table = $table124
			$formatFile = "C:\Scripts\XML\format124.xml"
		}
		Else {
			throw [System.FormatException] "ERROR:: $($file.FullName) didn't mach any patteren!"
		}
		$block = {
			[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
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
			$errLogFile = $args[0] + $args[1] + '_' + $args[10] + '_BCP_Error.log'
			$command = "bcp $($args[2]) in $($args[3]) -S $($args[4]) -d $($args[5]) -U $($args[6]) -P $($args[7]) -f $($args[8]) -F 2 -t ',' -q -e '$errLogFile'"
			$result = Invoke-Expression -Command $command
			$message1 = "$(Create-TimeStamp)  $command"
			$message2 = "$(Create-TimeStamp)  $($result[$($result.Length - 3)])"
			Add-Content -Value $message1 -Path $($args[9])
			Add-Content -Value $message2 -Path $($args[9])
			Return $message
		}
		Start-Job -ScriptBlock $block -ArgumentList `
		"$errLogRoot", ` #0
		"$($file.BaseName)", ` #1
		"$table", ` #2
		"$($file.FullName)", ` #3
		"$sqlServer", ` #4
		"$database", ` #5
		"$sqlUser", ` #6
		"$sqlPass", ` #7
		"$formatFile", ` #8
		"$opsLog", ` #9
		"$($file.Directory.Name)" #10
		Start-Sleep -Seconds 3
	}
	Write-Output "$(Create-TimeStamp)  Inserting..."
	Get-Job | Wait-Job
	Get-Job | Remove-Job
}
Function Confirm-Run {
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Start Date    ::  $startDate"
	Write-Host "End Date      ::  $endDate"
	Write-Host "Transactions  ::  $transTypes"
	Write-Host "Verbose       ::  $verbose"
    $global:report = Read-Host -Prompt "Store report or CEO dashboard? (s/c)"
	If ($report -eq 's') {
		$global:moveSp = 'sp_Move_STG_To_PROD'
	}
	ElseIf ($report -eq 'c') {
		$global:moveSp = 'sp_Move_STG_To_PROD_CEO'
	}
	Else {
		[System.ArgumentOutOfRangeException] "Only 's' or 'c' accepted!!!"
	}
	Write-Host "Table121      ::  $table121"
	Write-Host "Table122      ::  $table122"
	Write-Host "Table124      ::  $table124"
	Write-Host '********************************************************************' -ForegroundColor Magenta
	$answer = Read-Host -Prompt "Are you sure you want to start? (y/n)"
	Return $answer
}
$continue = Confirm-Run
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
$global:sqlPass = 'Password20!7!'
$global:sqlServer = 'mstestsqldw.database.windows.net'
$global:user = $userName + '@7-11.com'
$global:dataLakeSearchPathRoot = '/BIT_CRM/'
$global:dataLakeStoreName = '711dlprodcons01'
$global:extractorExe = 'C:\Scripts\C#\Debug\Ansira.Sel.fileExtractor.exe'
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
	Write-Verbose -Message "$(Create-TimeStamp)  Logging into Azure..."
	Login-AzureRmAccount -Credential $credential -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop
	If ($(Test-Path -Path $destinationRootPath) -eq $false) {
		Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $destinationRootPath..."
		New-Item -ItemType Directory -Path $destinationRootPath -Force | Out-Null
	}
	If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
		Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $opsLogRootPath..."
		New-Item -ItemType Directory -Path $opsLogRootPath -Force | Out-Null
	}
	If ($(Test-Path -Path $errLogRootPath) -eq $false) {
		Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $errLogRootPath..."
		New-Item -ItemType Directory -Path $errLogRootPath -Force | Out-Null
	}
	Try {
# Get raw files
		$startDateObj = Get-Date -Date $startDate
		$endDateObj = Get-Date -Date $endDate
		$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
		While ($i -lt $range) {
			$startTime = Get-Date
			$day = $($startDateObj.AddDays($i)).day.ToString("00")
			$month = $($startDateObj.AddDays($i)).month.ToString("00")
			$year = $($startDateObj.AddDays($i)).year.ToString("0000")
			$global:processDate = $year + $month + $day
			$global:opsLog = $opsLogRootPath + $processDate + $(Create-TimeStamp -forFileName) + '_BITC.log'
			$message = "Range: $startDate - $endDate"
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
				query = "TRUNCATE TABLE [dbo].[stg_121_Headers]; TRUNCATE TABLE [dbo].[stg_122_Details]; TRUNCATE TABLE [dbo].[stg_124_Media];";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			Invoke-Sqlcmd @sqlTruncateParams
			$message = "$(Create-TimeStamp)  Truncating staging tables successful"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			$structuredFiles = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Recurse -File
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
				$files = Get-ChildItem -Recurse -File -Path $($args[0])
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
			$sql124Params = @{
				query = "SELECT COUNT([RecordID]) AS [Count] FROM [dbo].[stg_124_Media]";
				ServerInstance = $sqlServer;
				Database = $database;
				Username = $sqlUser;
				Password = $sqlPass;
				QueryTimeout = 0;
				ErrorAction = 'Stop';
			}
			$124countResults = Invoke-Sqlcmd @sql124Params
			Write-Output "$(Create-TimeStamp)  Counting and comparing..."
			Get-Job | Wait-Job
			$totalFileRowCount = $(Receive-Job $job121122124) - 15
			Get-Job | Remove-Job
			$totalSqlRowCount = $($121CountResults.Count) + $($122CountResults.Count) + $($124countResults.Count)
			$message = "$(Create-TimeStamp)  Total File Rows: $totalFileRowCount  |  Total DB Rows: $totalSqlRowCount"
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
			If ($totalFileRowCount -ne $totalSqlRowCount) {
				throw [System.InvalidOperationException] "ROW COUNT MISMATCH"
			}
# Move data in DB from stg to prod
			$milestone_5 = Get-Date
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
			$htmlEmptyFileList = @()
			ForEach ($item in $emptyFileList) {
				$htmlEmptyFileList += $item + '<br>'
			}
			$rawTime = New-TimeSpan -Start $startTime -End $milestone_1
			$sepTime = New-TimeSpan -Start $milestone_1 -End $milestone_2
			$exeTime = New-TimeSpan -Start $milestone_2 -End $milestone_3
			$insTime = New-TimeSpan -Start $milestone_3 -End $milestone_4
			$couTime = New-TimeSpan -Start $milestone_4 -End $milestone_5
			$movTime = New-TimeSpan -Start $milestone_5 -End $endTime
			$totTime = New-TimeSpan -Start $startTime -End $endTime
			$message0 = "Start Time-----------:  $($startTime.DateTime)"
			$message1 = "End Time-------------:  $($endTime.DateTime)"
			$message2 = "Raw File Download----:  $($rawTime.Hours.ToString("00")) hours $($rawTime.Minutes.ToString("00")) minutes $($rawTime.Seconds.ToString("00")) seconds"
			$message3 = "File Decompression---:  $($sepTime.Hours.ToString("00")) hours $($sepTime.Minutes.ToString("00")) minutes $($sepTime.Seconds.ToString("00")) seconds"
			$message4 = "File Processing------:  $($exeTime.Hours.ToString("00")) hours $($exeTime.Minutes.ToString("00")) minutes $($exeTime.Seconds.ToString("00")) seconds"
			$message5 = "Insert To SQL DB-----:  $($insTime.Hours.ToString("00")) hours $($insTime.Minutes.ToString("00")) minutes $($insTime.Seconds.ToString("00")) seconds"
			$message6 = "Count Stores---------:  $($couTime.Hours.ToString("00")) hours $($couTime.Minutes.ToString("00")) minutes $($couTime.Seconds.ToString("00")) seconds"
			$message7 = "Move Data To Prod----:  $($movTime.Hours.ToString("00")) hours $($movTime.Minutes.ToString("00")) minutes $($movTime.Seconds.ToString("00")) seconds"
			$message8 = "Total Run Time-------:  $($totTime.Hours.ToString("00")) hours $($totTime.Minutes.ToString("00")) minutes $($totTime.Seconds.ToString("00")) seconds"
			$message9 = "Total File Count-----:  $fileCount"
			$messageX = "Empty File Count-----:  $emptyFileCount"
			$messageY = "Total Row Count------:  $totalFileRowCount"
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
			Add-Content -Value $emptyFileList -Path $opsLog
			$params = @{
				SmtpServer = $smtpServer;
				Port = $port;
				UseSsl = 0;
				From = $fromAddr;
				To = $emailList;
				BodyAsHtml = $true;
				Subject = "BITC: Finished Processing and Inserting Files From The $processDate Folder";
				Body = @"
Raw files from the 7-11 data lake have been processed and inserted into the database and are ready for aggregation.<br>
<br>
<font face='consolas'>
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
				<br>
				Store Count By Day In Folder $processDate :<br>
				$storeCountHtml
				<br>
				Empty File List:<br>
				$htmlEmptyFileList<br>
</font>
"@
			}
			Send-MailMessage @params
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
		Write-Error -Message 'Something bad happened!!!' -Exception $Error[0].Exception
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

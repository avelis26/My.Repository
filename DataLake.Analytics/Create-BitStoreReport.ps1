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
Function Get-DataLakeRawFiles {
	[CmdletBinding()]
	Param(
		[string]$dataLakeSearchPath, # /BIT_CRM/20171216
		[string]$destinationRootPath, # H:\BIT_CRM\20171216
		[string]$dataLakeStoreName, # 711dlprodcons01
		[string]$opsLog # H:\Ops_Log\20171216_BITC.log
	)
	Try {
		$message = "$(Create-TimeStamp)  Getting list of files in $dataLakeSearchPath ..."
		Write-Verbose -Message $message
		Set-Content -Value $message -Path $opsLog
		$getParams = @{
			Account = $dataLakeStoreName;
			Path = $dataLakeSearchPath;
			ErrorAction = 'SilentlyContinue';
		}
		$dataLakeFolder = Get-AzureRmDataLakeStoreItem @getParams
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
Function DeGZip-File {
	[CmdletBinding()]
	Param(
		[string]$inFile,
		[string]$opsLog # H:\Ops_Log\20171216_BITC.log
	)
	$outfile = $inFile -replace '\.gz$',''
	$message = "$(Create-TimeStamp)  Uncompressing $inFile..."
	Write-Verbose -Message $message
	$input = New-Object System.IO.FileStream $inFile, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
	$output = New-Object System.IO.FileStream $outFile, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
	$outputFile = $output.Name
	$gzipStream = New-Object System.IO.Compression.GzipStream $input, ([IO.Compression.CompressionMode]::Decompress)
	$buffer = New-Object byte[](1024)
	while($true) {
		$read = $gzipstream.Read($buffer, 0, 1024)
		if ($read -le 0){break}
		$output.Write($buffer, 0, $read)
	}
	$gzipStream.Close()
	$output.Close()
	$input.Close()
	$message = "$(Create-TimeStamp)  Deleting $inFile..."
	Write-Verbose -Message $message
	Remove-Item -Path $inFile -Force -ErrorAction Stop
	Return $outputFile
}
Function Split-FilesIntoFolders {
	[CmdletBinding()]
	Param(
		[string]$inFolder, # H:\BIT_CRM\20171216\
		[string]$opsLog # H:\Ops_Log\20171216_BITC.log
	)
	$files = Get-ChildItem -Path $inFolder -File -ErrorAction Stop
	$message = "$(Create-TimeStamp)  Found $($files.Count) number of files..."
	Write-Verbose -Message $message
	Add-Content -Value $message -Path $opsLog
	$i = 1
	$count = 5
	$folderPreFix = 'bucket_'
	While ($i -lt $($count + 1)) {
		$dirName = $folderPreFix + $i
		$dirPath = $inFolder + $dirName
		If ($(Test-Path -Path $dirPath) -eq $false) {
			$message = "$(Create-TimeStamp)  Creating folder:  $dirPath ..."
			Write-Verbose -Message $message
			Add-Content -Value $message -Path $opsLog
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
			$path = $args[0]
			$files = Get-ChildItem -Path $path -Filter '*.gz' -File
			ForEach ($file in $files) {
				Expand-7Zip -ArchiveFileName $($file.FullName) -TargetPath $path -ErrorAction Stop
				Remove-Item -Path $($file.FullName) -Force -ErrorAction Stop
			}
		}
		$message = "$(Create-TimeStamp)  Starting job:  $($folder.FullName)..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog
		Start-Job -ScriptBlock $block -ArgumentList $($folder.FullName)
	}
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
			Add-Content -Value $message -Path $opsLog
			New-Item -ItemType Directory -Path $outputPath -Force -ErrorAction Stop | Out-Null
		}
		$block = {
			& "$extractorExe" $args;
			Remove-Item -Path $($args[0]) -Recurse -Force;
		}
		$message = "$(Create-TimeStamp)  Starting job:  $($folder.Name)..."
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog
		Start-Job -ScriptBlock $block -ArgumentList "$($folder.FullName)", "$outputPath", "$transTypes", "$filePrefix"
	}
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
	ForEach ($file in $structuredFiles) {
	## move hard code outside of fuction with global var's
		If ($file.Name -like "*D1_121*") {
			$table = 'stg_TXNHeader_121'
			$formatFile = "C:\Scripts\XML\format121.xml"
		}
		ElseIf ($file.Name -like "*D1_122*") {
			$table = 'stg_TXNDetails_122'
			$formatFile = "C:\Scripts\XML\format122.xml"
		}
		ElseIf ($file.Name -like "*D1_124*") {
			$table = 'stg_Media_124'
			$formatFile = "C:\Scripts\XML\format124.xml"
		}
		ElseIf ($file.Name -like "*D1_136*") {
			$table = 'stg_PromoSales_136'
			$formatFile = "C:\Scripts\XML\format136.xml"
		}
		ElseIf ($file.Name -like "*D1_137*") {
			$table = 'stg_PromoSalesDetails_137'
			$formatFile = "C:\Scripts\XML\format137.xml"
		}	
		ElseIf ($file.Name -like "*D1_409*") {
			$table = 'stg_CouponSales_409'
			$formatFile = "C:\Scripts\XML\format409.xml"
		}
		ElseIf ($file.Name -like "*D1_410*") {
			$table = 'stg_CouponSalesDetails_410'
			$formatFile = "C:\Scripts\XML\format410.xml"
		}
		Else {
			throw [System.FormatException] "ERROR:: $($file.FullName) didn't mach any patteren!"
		}
		$errLogFile = $errLogRoot + $file.BaseName + '_BCP_Error.log'
		$command = "bcp $table in #($file.FullName) -S $server -d $database -U $sqlUser -P $sqlPass -f $formatFile -x -F 2 -t ',' -q -e '$errLogFile'"
		$message = "$(Create-TimeStamp)  $command"
		Write-Verbose -Message $message
		Add-Content -Value $message -Path $opsLog
		$result = Invoke-Expression -Command $command
		$global:bcpResult = $result
		If ([int]$($result[3].SubString(0, 1)) -gt 0) {
			Write-Verbose $result[3]
			Write-Verbose "Deleting $file ..."
			Remove-Item -Path $file -Force -ErrorAction Stop
		}
		Else {
			throw [System.ArgumentOutOfRangeException] $bcpResult
		}
		$global:goodFile = $file.FullName
	}
}
Function Confirm-Run {
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Start Date          :: $startDate"
	Write-Host "End Date            :: $endDate"
	Write-Host "Transactions        :: $transTypes"
	Write-Host '********************************************************************' -ForegroundColor Magenta
    $answer = Read-Host -Prompt "Are you sure you want to start? (y/n)"
	Return $answer
}

# Init
#######################################################################################################
#######################################################################################################
##   Enter the path where you want the raw files to be downloaded on your local machine:
[string]$destinationRootPath = 'H:\BIT_CRM\'
##   Enter the path where you want the operations logs to be stored:
[string]$opsLogRootPath = 'H:\Ops_Log\'
##   Enter the path where you want the error logs to be stored:
[string]$errLogRootPath = 'H:\Err_Log\'
##   Enter the range of aggregate files you want to download in mm-dd-yyyy format:
[string]$startDate = '12-16-2017'
[string]$endDate = '12-16-2017'
##   Enter the transactions you would like to filter for:
[string]$transTypes = 'D1121,D1122,D1124'
##   Enter your 7-11 user name without domain:
[string]$userName = 'gpink003'
#######################################################################################################
#######################################################################################################
$startTime = Get-Date
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
$global:database = '7ELE'
$global:sqlUser = 'sqladmin'
$global:sqlPass = 'Password20!7!'
$global:server = 'mstestsqldw.database.windows.net'
$user = $userName + '@7-11.com'
$dataLakeSearchPathRoot = '/BIT_CRM/'
$dataLakeStoreName = '711dlprodcons01'
$extractorExe = 'C:\Scripts\C#\Debug\Ansira.Sel.fileExtractor.exe'
$i = 0
$table = $null
$file = $null
$goodFile = $null
Write-Verbose -Message "$(Create-TimeStamp)  Importing AzureRm and 7Zip module..."
Import-Module AzureRM -ErrorAction Stop
Import-Module 7Zip -ErrorAction Stop
$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Write-Verbose -Message "$(Create-TimeStamp)  Logging into Azure..."
Login-AzureRmAccount -Credential $credential -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop
Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $destinationRootPath..."
If ($(Test-Path -Path $destinationRootPath) -eq $false) {
	New-Item -ItemType Directory -Path $destinationRootPath -Force | Out-Null
}
Else {
	Get-ChildItem -Path $destinationRootPath | Remove-Item -Recurse -Force
}
Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $opsLogRootPath..."
If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
	New-Item -ItemType Directory -Path $opsLogRootPath -Force | Out-Null
}
Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $errLogRootPath..."
If ($(Test-Path -Path $errLogRootPath) -eq $false) {
	New-Item -ItemType Directory -Path $errLogRootPath -Force | Out-Null
}
$continue = Confirm-Run
If ($continue -eq 'y') {
	Try {
# Get raw files
		$startDateObj = Get-Date -Date $startDate
		$endDateObj = Get-Date -Date $endDate
		$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
		While ($i -lt $range) {
			$day = $($startDateObj.AddDays($i)).day.ToString("00")
			$month = $($startDateObj.AddDays($i)).month.ToString("00")
			$year = $($startDateObj.AddDays($i)).year.ToString("0000")
			$processDate = $year + $month + $day
			$opsLog = $opsLogRootPath + $processDate + '_BITC.log'
			$getDataLakeRawFilesParams = @{
				dataLakeSearchPath = $($dataLakeSearchPathRoot + $processDate);
				destinationRootPath = $($destinationRootPath + $processDate + '\');
				dataLakeStoreName = $dataLakeStoreName;
				opsLog = $opsLog;
				Verbose = $true;
			}
			Get-DataLakeRawFiles @getDataLakeRawFilesParams
# Seperate files into 5 seperate folders for paralell processing
			$splitFilesIntoFoldersParams = @{
				inFolder = $($destinationRootPath + $processDate + '\');
				opsLog = $opsLog;
				Verbose = $true;
			}
			Split-FilesIntoFolders @splitFilesIntoFoldersParams
# Execute C# app as job on raw files to create CSV's
			$convertBitFilesToCsvParams = @{
				inFolder = $($destinationRootPath + $processDate + '\');
				transTypes = $transTypes;
				extractorExe = $extractorExe;
				filePrefix = $processDate;
				opsLog = $opsLog;
				Verbose = $true;
			}
			Convert-BitFilesToCsv @convertBitFilesToCsvParams
# Insert CSV's to DB
			$structuredFiles = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Recurse -File
			$addCsvsToSqlParams = @{
				structuredFiles = $structuredFiles;
				errLogRoot = $errLogRootPath;
				opsLog = $opsLog;
				Verbose = $true;
			}
			Add-CsvsToSql @addCsvsToSqlParams
			$i++
		}
	}
	Catch [System.FormatException] {
		Write-Error -Exception $Error[0].Exception
		$opsLog = $opsLogRootPath + $processDate + '_BITC.log'
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
	}
	Catch [System.ArgumentOutOfRangeException] {
		Write-Error -Exception $Error[0].Exception
		$opsLog = $opsLogRootPath + $processDate + '_BITC.log'
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
	}
	Catch {
		Write-Error -Message 'Something bad happened!!!'
	}
}
Write-Output "Start Time: $($startTime.DateTime)"
$endTime = Get-Date
Write-Output "End Time: $($endTime.DateTime)"
New-TimeSpan -Start $startTime -End $endTime

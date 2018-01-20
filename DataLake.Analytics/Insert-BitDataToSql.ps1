# Init
#######################################################################################################
#######################################################################################################
##   Enter your 7-11 user name without domain:
[string]$global:userName = 'gpink003'
##   Enter the range of aggregate files you want to download in mm-dd-yyyy format:
[string]$global:startDate = '01-16-2018'
[string]$global:endDate = '01-19-2018'
##   Enter the transactions you would like to filter for:
[string]$global:transTypes = 'D1121,D1122,D1124'
##   Enter $true for verbose information output, $false faster speed:
[bool]$global:verbose = $false
##   Enter the path where you want the raw files to be downloaded on your local machine:
[string]$global:destinationRootPath = 'H:\BIT_CRM\'
##   Enter the path where you want the operations logs to be stored:
[string]$global:opsLogRootPath = 'H:\Ops_Log\'
##   Enter the path where you want the error logs to be stored:
[string]$global:errLogRootPath = 'H:\Err_Log\'
##   Enter the email address desired for notifications:
[string[]]$global:emailList = 'graham.pinkston@ansira.com', 'scott.hall@ansira.com', 'mayank.minawat@ansira.com', 'megan.morace@ansira.com', 'tyler.bailey@ansira.com'
#######################################################################################################
#######################################################################################################
##   Enter the table names you would like the data inserted to by transaction type:
##   Trans Type D1 121
[string]$table121 = 'stg_TXNHeader_121'
##   Trans Type D1 122
[string]$table122 = 'stg_TXNDetails_122'
##   Trans Type D1 124
[string]$table124 = 'stg_Media_124'
##   Trans Type D1 136
[string]$table136 = 'stg_PromoSales_136'
##   Trans Type D1 137
[string]$table137 = 'stg_PromoSalesDetails_137'
##   Trans Type D1 409
[string]$table409 = 'stg_CouponSales_409'
##   Trans Type D1 410
[string]$table410 = 'stg_CouponSalesDetails_410'
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
		If ($dataLakeFolder -eq $null) {
			throw [DirectoryNotFoundException] "$dataLakeSearchPath NOT FOUND!!!"
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
		Write-Verbose -Message $i
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
		ElseIf ($file.Name -like "*D1_136*") {
			$table = $table124
			$formatFile = "C:\Scripts\XML\format136.xml"
		}
		ElseIf ($file.Name -like "*D1_137*") {
			$table = $table136
			$formatFile = "C:\Scripts\XML\format137.xml"
		}	
		ElseIf ($file.Name -like "*D1_409*") {
			$table = $table409
			$formatFile = "C:\Scripts\XML\format409.xml"
		}
		ElseIf ($file.Name -like "*D1_410*") {
			$table = $table410
			$formatFile = "C:\Scripts\XML\format410.xml"
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
			$errLogFile = $args[0] + $args[1] + '_' + $args[11] + '_BCP_Error.log'
			$command = "bcp $($args[2]) in $($args[3]) -S $($args[4]) -d $($args[5]) -U $($args[6]) -P $($args[7]) -f $($args[8]) -F 2 -t ',' -q -e '$errLogFile'"
			$message = "$(Create-TimeStamp)  $command"
			Start-Sleep -Seconds $(Get-Random -Minimum 1.0 -Maximum 3.9)
			Add-Content -Value $message -Path $($args[9])
			$result = Invoke-Expression -Command $command
			$message = "$(Create-TimeStamp)  $($result[$($result.Length - 3)])"
			Add-Content -Value $message -Path $($args[9])
		}
		Start-Job -ScriptBlock $block -ArgumentList "$errLogRoot", "$($file.BaseName)", "$table", "$($file.FullName)", "$server", "$database", "$sqlUser", "$sqlPass", "$formatFile", "$opsLog", "$($file.Directory.Name)"
		Start-Sleep -Seconds 5
	}
	Get-Job | Wait-Job
	Get-Job | Remove-Job
}
Function Confirm-Run {
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Start Date    ::  $startDate"
	Write-Host "End Date      ::  $endDate"
	Write-Host "Transactions  ::  $transTypes"
	Write-Host "Verbose       ::  $verbose"
	Write-Host "Table121      ::  $table121"
	Write-Host "Table122      ::  $table122"
	Write-Host "Table124      ::  $table124"
	Write-Host "Table136      ::  $table136"
	Write-Host "Table137      ::  $table137"
	Write-Host "Table409      ::  $table409"
	Write-Host "Table410      ::  $table410"
	Write-Host '********************************************************************' -ForegroundColor Magenta
    $answer = Read-Host -Prompt "Are you sure you want to start? (y/n)"
	Return $answer
}
$continue = Confirm-Run
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
$global:smtpServer = '10.128.1.125'
$global:port = 25
$global:fromAddr = 'noreply@7-11.com'
$global:database = '7ELE'
$global:sqlUser = 'sqladmin'
$global:sqlPass = 'Password20!7!'
$global:server = 'mstestsqldw.database.windows.net'
$global:user = $userName + '@7-11.com'
$global:dataLakeSearchPathRoot = '/BIT_CRM/'
$global:dataLakeStoreName = '711dlprodcons01'
$global:extractorExe = 'C:\Scripts\C#\Debug\Ansira.Sel.fileExtractor.exe'
$i = 0
$table = $null
$file = $null
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
Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $opsLogRootPath..."
If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
	New-Item -ItemType Directory -Path $opsLogRootPath -Force | Out-Null
}
Write-Verbose -Message "$(Create-TimeStamp)  Creating folder:  $errLogRootPath..."
If ($(Test-Path -Path $errLogRootPath) -eq $false) {
	New-Item -ItemType Directory -Path $errLogRootPath -Force | Out-Null
}
If ($continue -eq 'y') {
	Try {
# Get raw files
		$milestone_1 = Get-Date
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
			$getDataLakeRawFilesParams = @{
				dataLakeSearchPath = $($dataLakeSearchPathRoot + $processDate);
				destinationRootPath = $($destinationRootPath + $processDate + '\');
				dataLakeStoreName = $dataLakeStoreName;
				opsLog = $opsLog;
				Verbose = $verbose;
			}
			Get-DataLakeRawFiles @getDataLakeRawFilesParams
# Seperate files into 5 seperate folders for paralell processing
			$milestone_2 = Get-Date
			$splitFilesAmongFoldersParams = @{
				inFolder = $($destinationRootPath + $processDate + '\');
				opsLog = $opsLog;
				Verbose = $verbose;
			}
			Split-FilesAmongFolders @splitFilesAmongFoldersParams
# Execute C# app as job on raw files to create CSV's
			$milestone_3 = Get-Date
			$convertBitFilesToCsvParams = @{
				inFolder = $($destinationRootPath + $processDate + '\');
				transTypes = $transTypes;
				extractorExe = $extractorExe;
				filePrefix = $processDate;
				opsLog = $opsLog;
				Verbose = $verbose;
			}
			Convert-BitFilesToCsv @convertBitFilesToCsvParams
# Insert CSV's to DB
			$milestone_4 = Get-Date
			$structuredFiles = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Recurse -File
			$addCsvsToSqlParams = @{
				structuredFiles = $structuredFiles;
				errLogRoot = $errLogRootPath;
				opsLog = $opsLog;
				Verbose = $verbose;
			}
			Add-CsvsToSql @addCsvsToSqlParams
			$i++
			$endTime = Get-Date
			$rawTime = New-TimeSpan -Start $milestone_1 -End $milestone_2
			$sepTime = New-TimeSpan -Start $milestone_2 -End $milestone_3
			$exeTime = New-TimeSpan -Start $milestone_3 -End $milestone_4
			$insTime = New-TimeSpan -Start $milestone_4 -End $endTime
			$totTime = New-TimeSpan -Start $startTime -End $endTime
			$message1 = "Start Time----------:  $($startTime.DateTime)"
			$message2 = "End Time------------:  $($endTime.DateTime)"
			$message3 = "Raw File Download---:  $($rawTime.Hours.ToString("00")) hours $($rawTime.Minutes.ToString("00")) minutes $($rawTime.Seconds.ToString("00")) seconds"
			$message4 = "File Decompression--:  $($sepTime.Hours.ToString("00")) hours $($sepTime.Minutes.ToString("00")) minutes $($sepTime.Seconds.ToString("00")) seconds"
			$message5 = "File Processing-----:  $($exeTime.Hours.ToString("00")) hours $($exeTime.Minutes.ToString("00")) minutes $($exeTime.Seconds.ToString("00")) seconds"
			$message6 = "Insert To SQL DB----:  $($insTime.Hours.ToString("00")) hours $($insTime.Minutes.ToString("00")) minutes $($insTime.Seconds.ToString("00")) seconds"
			$message7 = "Total Run Time------:  $($totTime.Hours.ToString("00")) hours $($totTime.Minutes.ToString("00")) minutes $($totTime.Seconds.ToString("00")) seconds"
			Write-Output $message1
			Write-Output $message2
			Write-Output $message3
			Write-Output $message4
			Write-Output $message5
			Write-Output $message6
			Write-Output $message7
			Add-Content -Value $message1 -Path $opsLog
			Add-Content -Value $message2 -Path $opsLog
			Add-Content -Value $message3 -Path $opsLog
			Add-Content -Value $message4 -Path $opsLog
			Add-Content -Value $message5 -Path $opsLog
			Add-Content -Value $message6 -Path $opsLog
			Add-Content -Value $message7 -Path $opsLog
			$params = @{
				SmtpServer = $smtpServer;
				Port = $port;
				UseSsl = 0;
				From = $fromAddr;
				To = $emailList;
				BodyAsHtml = $true;
				Subject = "BITC Finished Processing and Inserting $processDate";
				Body = @"
Raw files from the 7-11 data lake have been processed and inserted into the database and are ready for aggregation.
<font face='consolas'>
				$message1
				$message2
				$message3
				$message4
				$message5
				$message6
				$message7
</font>
"@
			}
			Send-MailMessage @params
		}
	}
	Catch [System.DirectoryNotFoundException] {
		Write-Error -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
			BodyAsHtml = $true;
			Subject = "ERROR:: BITC FAILED For Range: $startDate - $endDate!!!";
			Body = "$($Error[0].Exception)"
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
			Subject = "ERROR:: BITC FAILED For Range: $startDate - $endDate!!!";
			Body = "$($Error[0].Exception)"
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
			Subject = "ERROR:: BITC FAILED For Range: $startDate - $endDate!!!";
			Body = "$($Error[0].Exception)"
		}
		Send-MailMessage @params
	}
	Catch {
		Write-Error -Message 'Something bad happened!!!' -Exception $Error[0].Exception
		Add-Content -Value $($Error[0].Exception.ToString()) -Path $opsLog
		Add-Content -Value $($Error[0].CategoryInfo.ToString()) -Path $opsLog
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
			BodyAsHtml = $true;
			Subject = "ERROR:: BITC FAILED For Range: $startDate - $endDate!!!";
			Body = @"
Something bad happened!!!
$($Error[0].Exception.ToString())
$($Error[0].CategoryInfo.ToString())
"@
		}
		Send-MailMessage @params
	}
}

# Version  --  v1.0.4.1
#######################################################################################################
#
#######################################################################################################
[CmdletBinding()]
Param(
	[switch]$autoDate,
	[switch]$noDupeCheck,
	[switch]$test
)
Write-Output "Importing AzureRm and 7Zip modules as well as custom fuctions..."
Import-Module AzureRM -ErrorAction Stop
Import-Module 7Zip4powershell -ErrorAction Stop
. $($PSScriptRoot + '\New-TimeStamp.ps1')
. $($PSScriptRoot + '\Set-SslCertPolicy.ps1')
. $($PSScriptRoot + '\Get-DataLakeRawFiles.ps1')
. $($PSScriptRoot + '\Expand-FilesInParallel.ps1')
. $($PSScriptRoot + '\Split-FilesAmongFolders.ps1')
If ($autoDate.IsPresent -eq $true) {
	$startDate = $endDate = $(Get-Date).Year.ToString('0000') + '-' + $(Get-Date).Month.ToString('00') + '-' + $(Get-Date).Day.ToString('00')
}
Else {
	$startDate = '1984-08-13'
	$endDate = '1984-08-13'
}
If ($test.IsPresent -eq $true) {
	$emailList = 'graham.pinkston@ansira.com'
	$failEmailList = 'graham.pinkston@ansira.com'
	$opsLogRootPath = '\\MS-SSW-CRM-MGMT\Data\Ops_Log\ETL\Hadoop\Test\'
}
Else {
	[string[]]$emailList = 'Catherine.Wells@Ansira.com', 'Britten.Morse@Ansira.com', 'megan.morace@ansira.com', 'Cheong.Sin@Ansira.com', 'Graham.Pinkston@Ansira.com', 'Geri.Shaeffer@Ansira.com'
	[string[]]$failEmailList = $emailList
	$opsLogRootPath = '\\MS-SSW-CRM-MGMT\Data\Ops_Log\ETL\Hadoop\'
}
If ($noDupeCheck.IsPresent -eq $true) {
	$configFile = "C:\Scripts\C#\Optimus\Hadoop\Ansira.Sel.BITC.DataExtract.Optimus.exe.config"
	[xml]$doc = Get-Content -Path $configFile
	$etting = $doc.configuration.applicationSettings.'Ansira.Sel.BITC.DataExtract.Optimus.Properties.Settings'.setting | Where-Object -FilterScript {$_.Name -eq 'DupFileCheck'}
	$etting.value = '0'
	$doc.Save($configFile)
}
$userName = 'gpink003'
$transTypes = 'D1121,D1122'
$destinationRootPath = 'D:\BIT_CRM\'
$dataLakeSubId = 'ee691273-18af-4600-bc24-eb6768bf9cfa'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$dataLakeSearchPathRoot = '/BIT_CRM/'
$dataLakeStoreName = '711dlprodcons01'
$bumblebee = 'C:\Scripts\C#\Bumblebee\Ansira.Sel.Bitc.Bumblebee.exe'
$optimus = 'C:\Scripts\C#\Optimus\Hadoop\Ansira.Sel.BITC.DataExtract.Optimus.exe'
$121blobPath = 'bitc/121header/'
$122blobPath = 'bitc/122detail/'
$y = 0
#######################################################################################################
# Init
[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
$startDateObj = Get-Date -Date $startDate -ErrorAction Stop
$endDateObj = Get-Date -Date $endDate -ErrorAction Stop
Write-Host '********************************************************************' -ForegroundColor Magenta
Write-Host "Start Date    ::  $startDate"
Write-Host "End Date      ::  $endDate"
Write-Host "Transactions  ::  $transTypes"
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
$exitCode = 0
$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj -ErrorAction Stop).Days + 1
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
Set-SslCertPolicy
Connect-AzureRmAccount -Credential $credential -Subscription $dataLakeSubId -Force -ErrorAction Stop
While ($y -lt $range) {
	Try {
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
			Add-Content -Value "$(New-TimeStamp)  Process Date: $processDate" -Path $opsLog -ErrorAction Stop -Encoding Unicode
		}
		If ($(Test-Path -Path $destinationRootPath) -eq $false) {
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Creating $destinationRootPath..."
			New-Item -ItemType Directory -Path $destinationRootPath -Force -ErrorAction Stop > $null
		}
	# Get raw files
		$retry = 0
		While ($retry -lt 3) {
			Try {
				$milestone_0 = Get-Date -ErrorAction Stop
				Get-DataLakeRawFiles -dataLakeStoreName $dataLakeStoreName -destination $($destinationRootPath + $processDate + '\') -source $($dataLakeSearchPathRoot + $processDate) -log $opsLog
				$fileCount = $(Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -File).Count
	# Seperate files into 5 seperate folders for paralell processing
				$milestone_1 = Get-Date
				Split-FilesAmongFolders -rootPath $($destinationRootPath + $processDate + '\') -log $opsLog
	# Decompress files
				Expand-FilesInParallel -rootPath $($destinationRootPath + $processDate + '\') -log $opsLog -processDate $processDate -dataLakeRoot $dataLakeSearchPathRoot
				$retry = 3
			}
			Catch {
				Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  $($Error[0].Exception.Message)"
				Get-Job | Remove-Job -Force
				$retry++
				If ($retry -eq 3) {
					throw $($Error[0].Exception.Message)
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
			Start-Job -ScriptBlock $block -ArgumentList "$optimus", "$($folder.FullName)", "$outputPath", "$transTypes", "$($processDate)_$($folder.Name)" -ErrorAction Stop
			Start-Sleep -Milliseconds 128
		}
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Converting..."
		Get-Job | Wait-Job
		Get-Job | Remove-Job -ErrorAction Stop
		Add-Content -Value "$(New-TimeStamp)  Optimus Report:" -Path $opsLog -ErrorAction Stop -Encoding Unicode
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
				Add-Content -Value "$($folder.FullName)" -Path $opsLog -ErrorAction Stop -Encoding Unicode
				Add-Content -Value "TotalNumRecords: $($jsonObj.TotalNumRecords)" -Path $opsLog -ErrorAction Stop -Encoding Unicode
				Add-Content -Value "TotalNumFiles: $($jsonObj.TotalNumFiles)" -Path $opsLog -ErrorAction Stop -Encoding Unicode
				Add-Content -Value "------------------------------------------------------------------------------------------------------" -Path $opsLog -ErrorAction Stop -Encoding Unicode
			}
		}
	# Concatinate CSV's to one file
		$milestone_3 = Get-Date
		$121files = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Filter "*D1_121*" -Recurse -File -ErrorAction Stop
		$122files = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Filter "*D1_122*" -Recurse -File -ErrorAction Stop
		$121outFile = $($destinationRootPath + $processDate + '\' + $processDate + '_D1_121_Headers.csv')
		$122outFile = $($destinationRootPath + $processDate + '\' + $processDate + '_D1_122_Details.csv')
		Set-Content -Path $121outFile -Value $(Get-Content -Path $121files[0].FullName -TotalCount 1) -ErrorAction Stop
		Set-Content -Path $122outFile -Value $(Get-Content -Path $122files[0].FullName -TotalCount 1) -ErrorAction Stop
		ForEach ($121file in $121files) {
			$121output = $(Get-Content -Path $121file.FullName -ReadCount 0)
			$121output = $121output | Select-Object -Skip 1
			Add-Content -Path $121outFile -Value $121output -ErrorAction Stop
		}
		$121output = $null
		ForEach ($122file in $122files) {
			$122output = $(Get-Content -Path $122file.FullName -ReadCount 0)
			$122output = $122output | Select-Object -Skip 1
			Add-Content -Path $122outFile -Value $122output -ErrorAction Stop
		}
		$122output = $null
	# Upload CSV's to blob storage
		$milestone_4 = Get-Date
		$files = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Filter "*D1*" -File -ErrorAction Stop
		ForEach ($file in $files) {
			If ($file.Name -like "*D1_121*") {
				$destination = $121blobPath
			}
			ElseIF ($file.Name -like "*D1_122*") {
				$destination = $122blobPath
			}
			Else {
				$errorParams = @{
					Message = "ERROR: File name: $($file.FullName) doesn't match any defined pattern!!!";
					ErrorId = "999";
					RecommendedAction = "Fix it.";
					ErrorAction = "Stop";
				}
				Write-Error @errorParams
			}
			$command = "& $bumblebee $($file.FullName) $destination"
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Sending To Blob:  $command"
			$result = Invoke-Expression -Command $command -ErrorAction Stop
			If ($result[$result.Count - 1] -notLike "*Successfully*") {
				$errorParams = @{
					Message = "ERROR: Bumblebee failed to upload $($file.FullName)!!!";
					ErrorId = "888";
					RecommendedAction = "Fix it.";
					ErrorAction = "Stop";
				}
				Write-Error @errorParams
			}
			Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  File uploaded successfully."
		}
	# Send report
		$endTime = Get-Date
		$endTimeText = $(New-TimeStamp -forFileName)
		$iniTime = New-TimeSpan -Start $startTime -End $milestone_0
		$rawTime = New-TimeSpan -Start $milestone_0 -End $milestone_1
		$sepTime = New-TimeSpan -Start $milestone_1 -End $milestone_2
		$exeTime = New-TimeSpan -Start $milestone_2 -End $milestone_3
		$catTime = New-TimeSpan -Start $milestone_3 -End $milestone_4
		$uplTime = New-TimeSpan -Start $milestone_4 -End $endTime
		$totTime = New-TimeSpan -Start $startTime -End $endTime
		$message01 = "Start Time--------:  $startTimeText"
		$message02 = "End Time----------:  $endTimeText"
		$message03 = "Initialization----:  $($iniTime.Hours.ToString("00")) h $($iniTime.Minutes.ToString("00")) m $($iniTime.Seconds.ToString("00")) s"
		$message04 = "Raw File Download-:  $($rawTime.Hours.ToString("00")) h $($rawTime.Minutes.ToString("00")) m $($rawTime.Seconds.ToString("00")) s"
		$message05 = "Decompression-----:  $($sepTime.Hours.ToString("00")) h $($sepTime.Minutes.ToString("00")) m $($sepTime.Seconds.ToString("00")) s"
		$message06 = "File Processing---:  $($exeTime.Hours.ToString("00")) h $($exeTime.Minutes.ToString("00")) m $($exeTime.Seconds.ToString("00")) s"
		$message07 = "Concat CSV Files--:  $($catTime.Hours.ToString("00")) h $($catTime.Minutes.ToString("00")) m $($catTime.Seconds.ToString("00")) s"
		$message08 = "CSV File Upload---:  $($uplTime.Hours.ToString("00")) h $($uplTime.Minutes.ToString("00")) m $($uplTime.Seconds.ToString("00")) s"
		$message09 = "Total Run Time----:  $($totTime.Hours.ToString("00")) h $($totTime.Minutes.ToString("00")) m $($totTime.Seconds.ToString("00")) s"
		$message10 = "Total File Count--:  $fileCount"
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
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
			BodyAsHtml = $true;
			Subject = "AllSpark: $($processDate): Hadoop ETL Process Finished";
			Body = @"
				Optimus has processed the raw files from<b> $($dataLakeSearchPathRoot + $processDate) </b>and uploaded them to blob storage for hadoop.<br>
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
				</font>
"@
		}
		Send-MailMessage @params
		Add-Content -Value '::ETL SUCCESSFUL::' -Path $opsLog -ErrorAction Stop -Encoding Unicode
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
	}
	Catch {
		$y++
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $($Error[0].Message)
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $($Error[0].Exception.Message)
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $($Error[0].Exception.InnerException.Message)
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $($Error[0].Exception.InnerException.InnerException.Message)
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $($Error[0].CategoryInfo.Activity)
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $($Error[0].CategoryInfo.Reason)
		Tee-Object -FilePath $opsLog -Append -ErrorAction Stop -InputObject $($Error[0].InvocationInfo.Line)
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $failEmailList;
			BodyAsHtml = $true;
			Subject = "AllSpark: ::ERROR:: ETL Failed For $processDate!!!";
			Body = @"
				<font face='consolas'>
				Something bad happened!!!<br><br>
				$($Error[0].Message)<br>
				$($Error[0].Exception.Message)<br>
				$($Error[0].Exception.InnerException.Message)<br>
				$($Error[0].Exception.InnerException.InnerException.Message)<br>
				$($Error[0].CategoryInfo.Activity)<br>
				$($Error[0].CategoryInfo.Reason)<br>
				$($Error[0].InvocationInfo.Line)<br>
				</font>
"@
		}
		Send-MailMessage @params
		$exitCode = 1
		Start-Sleep -Seconds 8
	}
	Finally {
		Write-Output 'Finally...'
		# Remove any stale jobs
		Get-Job | Remove-Job -Force
		# Set Optimus config back to DupFileCheck = 1
		$configFile = "C:\Scripts\C#\Optimus\Hadoop\Ansira.Sel.BITC.DataExtract.Optimus.exe.config"
		[xml]$doc = Get-Content -Path $configFile
		$etting = $doc.configuration.applicationSettings.'Ansira.Sel.BITC.DataExtract.Optimus.Properties.Settings'.setting | Where-Object -FilterScript {$_.Name -eq 'DupFileCheck'}
		$etting.value = '1'
		$doc.Save($configFile)
		# Delete data from temp drive
		Remove-Item -Path "$destinationRootPath" -Recurse -Force -ErrorAction Stop
	}
}
Return $exitCode

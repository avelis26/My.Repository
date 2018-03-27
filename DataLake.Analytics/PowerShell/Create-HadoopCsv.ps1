# Version  --  v0.9.0.1
#######################################################################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $true)][string]$startDate,
	[parameter(Mandatory = $true)][string]$endDate
)
$userName = 'gpink003'
$transTypes = 'D1121,D1122'
$destinationRootPath = 'D:\BIT_CRM\Hadoop\'
$archiveRootPath = 'H:\BIT_CRM\Hadoop\'
$emailList = 'graham.pinkston@ansira.com', 'Cheong.Sin@Ansira.com'
$failEmailList = 'graham.pinkston@ansira.com', 'Cheong.Sin@Ansira.com'
$opsLogRootPath = 'H:\Ops_Log\ETL\Hadoop\'
$dataLakeSubId = 'ee691273-18af-4600-bc24-eb6768bf9cfa'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$dataLakeSearchPathRoot = '/BIT_CRM/'
$dataLakeStoreName = '711dlprodcons01'
$extractorExe = "C:\Scripts\C#\Hadoop\Ansira.Sel.BITC.DataExtract.Processor.exe"
$y = 0
#######################################################################################################
Function Create-TimeStamp {
	[CmdletBinding()]
	Param(
		[switch]$forFileName
	)
	$now = Get-Date -ErrorAction Stop
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
Add-Content -Value "$(Create-TimeStamp -forFileName) :: Create-HadoopCsv :: Start" -Path 'H:\Ops_Log\bitc.log'
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
Try {
	Write-Output "$(Create-TimeStamp)  Importing AzureRm, and 7Zip modules..."
	Import-Module AzureRM -ErrorAction Stop
	Import-Module 7Zip -ErrorAction Stop
	$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj -ErrorAction Stop).Days + 1
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
	While ($y -lt $range) {
		$startTime = Get-Date -ErrorAction Stop
		$startTimeText = $(Create-TimeStamp -forFileName)
		$day = $($startDateObj.AddDays($y)).day.ToString("00")
		$month = $($startDateObj.AddDays($y)).month.ToString("00")
		$year = $($startDateObj.AddDays($y)).year.ToString("0000")
		$processDate = $year + $month + $day
		$opsLog = $opsLogRootPath + $processDate + '_' + $startTimeText + '_BITC.log'
		If ($(Test-Path -Path $opsLogRootPath) -eq $false) {
			Write-Output "Creating $opsLogRootPath..."
			New-Item -ItemType Directory -Path $opsLogRootPath -Force -ErrorAction Stop | Out-Null
			Add-Content -Value "$(Create-TimeStamp)  Process Date: $processDate" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "$(Create-TimeStamp)  Created folder: $opsLogRootPath" -Path $opsLog -ErrorAction Stop
		}
		Else {
			Add-Content -Value "$(Create-TimeStamp)  Process Date: $processDate" -Path $opsLog -ErrorAction Stop
		}
		If ($(Test-Path -Path $destinationRootPath) -eq $false) {
			$message = "Creating $destinationRootPath..."
			Write-Output $message
			Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
			New-Item -ItemType Directory -Path $destinationRootPath -Force -ErrorAction Stop | Out-Null
		}
		If ($(Test-Path -Path $archiveRootPath) -eq $false) {
			$message = "Creating $archiveRootPath..."
			Write-Output $message
			Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
			New-Item -ItemType Directory -Path $archiveRootPath -Force -ErrorAction Stop | Out-Null
		}
		$message = "Logging into Azure..."
		Write-Output $message
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
		Login-AzureRmAccount -Credential $credential -Force -ErrorAction Stop
		$message = "Login successful."
		Write-Output $message
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
# Get raw files
		$milestone_0 = Get-Date -ErrorAction Stop
		Set-AzureRmContext -Subscription $dataLakeSubId -ErrorAction Stop
		If ($(Test-Path -Path $($destinationRootPath + $processDate + '\')) -eq $true) {
			$message = "$(Create-TimeStamp)  Removing folder $($destinationRootPath + $processDate + '\') ..."
			Write-Output $message
			Add-Content -Value $message -Path $opsLog -ErrorAction Stop
			Remove-Item -Path $($destinationRootPath + $processDate + '\') -Force -Recurse -ErrorAction Stop | Out-Null
		}
		$message = "$(Create-TimeStamp)  Validating $($dataLakeSearchPathRoot + $processDate) exists in data lake..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		$getParams = @{
			Account = $dataLakeStoreName;
			Path = $($dataLakeSearchPathRoot + $processDate);
			ErrorAction = 'Stop';
		}
		$dataLakeFolder = Get-AzureRmDataLakeStoreItem @getParams
		$message = "$(Create-TimeStamp)  Downloading folder $($dataLakeFolder.Path)..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		$exportParams = @{
			Account = $dataLakeStoreName;
			Path = $($dataLakeFolder.Path);
			Destination = $($destinationRootPath + $processDate + '\');
			Force = $true;
			ErrorAction = 'Stop';
		}
		Export-AzureRmDataLakeStoreItem @exportParams
		$message = "$(Create-TimeStamp)  Folder $($dataLakeFolder.Path) downloaded successfully."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
# Decompress files for processing
		$milestone_1 = Get-Date
		$fileCount = $null
		$files = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Filter '*.gz' -File -ErrorAction Stop
		$fileCount = $files.Count.ToString()
		$message = "$(Create-TimeStamp)  Found $fileCount total files..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		$dirPath = $($destinationRootPath + $processDate + '\bucket_1\')
		If ($(Test-Path -Path $dirPath) -eq $false) {
			$message = "$(Create-TimeStamp)  Creating folder:  $dirPath ..."
			Write-Output $message
			New-Item -ItemType Directory -Path $dirPath -Force -ErrorAction Stop | Out-Null
		}
		Else {
			Get-ChildItem -Path $dirPath -Recurse -ErrorAction Stop | Remove-Item -Force -ErrorAction Stop
		}
		Write-Output "$(Create-TimeStamp)  Decompressing..."
		ForEach ($file in $files) {
			Expand-7Zip -ArchiveFileName $($file.FullName) -TargetPath $dirPath -ErrorAction Stop | Out-Null
			Remove-Item -Path $($file.FullName) -Force -ErrorAction Stop
		}
# Execute C# app as job on raw files to create CSV's
		$milestone_2 = Get-Date
		$message = "$(Create-TimeStamp)  Starting convert job:  $dirPath..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
		& $extractorExe "$dirPath", "$($destinationRootPath + $processDate + '\')", "$transTypes", "$processDate"
		
		
		Add-Content -Value "$(Create-TimeStamp)  Optimus Report:" -Path $opsLog -ErrorAction Stop
		$outputFile = Get-ChildItem -Path $($destinationRootPath + $processDate + '\') -Recurse -File -Filter "*output*" -ErrorAction Stop
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
			Add-Content -Value "TotalNumRecords: $($jsonObj.TotalNumRecords)" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "TotalNumFiles: $($jsonObj.TotalNumFiles)" -Path $opsLog -ErrorAction Stop
			Add-Content -Value "------------------------------------------------------------------------------------------------------" -Path $opsLog -ErrorAction Stop
		}
# Move data from temp drive to archive
		$milestone_3 = Get-Date
		If ($(Test-Path -Path $($archiveRootPath + $processDate)) -eq $true) {
			Add-Content -Value "$(Create-TimeStamp)  Removing folder: $($archiveRootPath + $processDate)..." -Path $opsLog -ErrorAction Stop
			Remove-Item -Path $($archiveRootPath + $processDate) -Recurse -Force -ErrorAction Stop
			Add-Content -Value "$(Create-TimeStamp)  Folder removed successfully." -Path $opsLog -ErrorAction Stop
		}
		Add-Content -Value "$(Create-TimeStamp)  Moving $($destinationRootPath + $processDate) to archive: $($archiveRootPath + $processDate)..." -Path $opsLog -ErrorAction Stop
		Move-Item -Path $($destinationRootPath + $processDate) -Destination $archiveRootPath -Force -ErrorAction Stop
# Send report
		$endTime = Get-Date
		$endTimeText = $(Create-TimeStamp -forFileName)
		$iniTime = New-TimeSpan -Start $startTime -End $milestone_0
		$rawTime = New-TimeSpan -Start $milestone_0 -End $milestone_1
		$sepTime = New-TimeSpan -Start $milestone_1 -End $milestone_2
		$exeTime = New-TimeSpan -Start $milestone_2 -End $milestone_3
		$cleTime = New-TimeSpan -Start $milestone_3 -End $endTime
		$totTime = New-TimeSpan -Start $startTime -End $endTime
		$message01 = "Data Lake Folder--:  $($dataLakeSearchPathRoot + $processDate)"
		$message02 = "Start Time--------:  $startTimeText"
		$message03 = "End Time----------:  $endTimeText"
		$message04 = "Initialization----:  $($iniTime.Hours.ToString("00")) h $($iniTime.Minutes.ToString("00")) m $($iniTime.Seconds.ToString("00")) s"
		$message05 = "Raw File Download-:  $($rawTime.Hours.ToString("00")) h $($rawTime.Minutes.ToString("00")) m $($rawTime.Seconds.ToString("00")) s"
		$message06 = "Decompression-----:  $($sepTime.Hours.ToString("00")) h $($sepTime.Minutes.ToString("00")) m $($sepTime.Seconds.ToString("00")) s"
		$message07 = "File Processing---:  $($exeTime.Hours.ToString("00")) h $($exeTime.Minutes.ToString("00")) m $($exeTime.Seconds.ToString("00")) s"
		$message08 = "Cleanup-----------:  $($cleTime.Hours.ToString("00")) h $($cleTime.Minutes.ToString("00")) m $($cleTime.Seconds.ToString("00")) s"
		$message09 = "Total Run Time----:  $($totTime.Hours.ToString("00")) h $($totTime.Minutes.ToString("00")) m $($totTime.Seconds.ToString("00")) s"
		$message10 = "Total File Count--:  $fileCount"
		Write-Output $message01
		Write-Output $message02
		Write-Output $message03
		Write-Output $message04
		Write-Output $message05
		Write-Output $message06
		Write-Output $message07
		Write-Output $message08
		Write-Output $message09
		Write-Output $message10
		Add-Content -Value $message01 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message02 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message03 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message04 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message05 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message06 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message07 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message08 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message09 -Path $opsLog -ErrorAction Stop
		Add-Content -Value $message10 -Path $opsLog -ErrorAction Stop
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
			BodyAsHtml = $true;
			Subject = "BITC: $($processDate): Hadoop ETL Process Finished";
			Body = @"
				Raw files from the 7-11 data lake have been processed and ready for hadoop.<br>
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
		Add-Content -Value '::ETL SUCCESSFUL::' -Path $opsLog -ErrorAction Stop
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
	Add-Content -Value $($Error[0].CategoryInfo.Activity) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.InnerExceptionMessage) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].RecommendedAction) -Path $opsLog -ErrorAction Stop
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
			$($Error[0].CategoryInfo.Activity)<br>
			$($Error[0].Exception.Message)<br>
			$($Error[0].Exception.InnerExceptionMessage)<br>
			$($Error[0].RecommendedAction)<br>
			$($Error[0].Message)<br>
			</font>
"@
	}
	Send-MailMessage @params
	If ($(Test-Path -Path $($archiveRootPath + 'ERROR')) -eq $false) {
		$message = "Creating $($archiveRootPath + 'ERROR')..."
		Write-Output $message
		Add-Content -Value "$(Create-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
		New-Item -ItemType Directory -Path $($archiveRootPath + 'ERROR') -Force -ErrorAction Stop | Out-Null
	}
	Move-Item -Path $($destinationRootPath + $processDate) -Destination $($archiveRootPath + 'ERROR') -Force -ErrorAction Stop
	$exitCode = 1
}
Finally {
	Write-Output 'Finally...'
	Remove-Item -Path $destinationRootPath -Recurse -Force -ErrorAction Stop
	Add-Content -Value "$(Create-TimeStamp -forFileName) :: Create-HadoopCsv :: End" -Path 'H:\Ops_Log\bitc.log'
	[Environment]::Exit($exitCode)
}

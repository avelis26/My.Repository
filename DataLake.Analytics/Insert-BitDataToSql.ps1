$VerbosePreference = 'Continue'
$DebugPreference = 'Continue'
$startTime = Get-Date
Try {
	Write-Verbose -Message 'Importing AzureRm module...'
	Import-Module AzureRM -ErrorAction Stop
}
Catch {
	throw $_
}
Try {
###########################################################################
	$global:startDate = '10-23-2017'
	$global:endDate = '11-28-2017'
	$global:expected = 3
	$global:searchPattern = "*d1*12*output.csv"
###########################################################################
	$global:userName = 'gpink003'
	$global:dataLakeStoreName = 'mscrmprodadls'
	$global:subscription = 'ee691273-18af-4600-bc24-eb6768bf9cfa'
	$global:dataLakeRootPath = '/BIT_CRM/'
	$global:destinationRoot = 'C:\BIT_CRM\'
	$global:user = $userName + '@7-11.com'
	$global:database = '7ELE'
	$global:schema = 'dbo'
	$global:sqlUser = 'sqladmin'
	$global:sqlPass = 'Password20!7!'
	$global:server = 'mstestsqldw.database.windows.net'
	$global:startDateObj = Get-Date -Date $startDate
	$global:endDateObj = Get-Date -Date $endDate
	$global:range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
	$global:exitCode = 0
	$i = 0
	$command = $null
	$result = $null
	$dataLakeSearchPath = $null
	$structuredFiles = $null
	$processDate = $null
	$global:foundFiles = $null
	$global:goodFile = $null
	$continue = $null
	$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
	If (!(Test-Path -LiteralPath $destinationRoot)) {
		Write-Verbose -Message "Creating folder:  $destinationRoot ..."
		New-Item -ItemType Directory -Path $destinationRoot -Force
	}
}
Catch {
	throw $_
}
Try {
	Write-Verbose -Message 'Logging into Azure...'
	Login-AzureRmAccount -Credential $credential -Subscription $subscription -ErrorAction Stop
}
Catch {
	throw $_
}
Function Get-DataLakeStructuredFiles {
	[CmdletBinding()]
	Param(
		[string]$dataLakeSearchPath,
		[string]$destinationRootPath
	)
	$found = 0
	$dataLakeFiles = $null
	If (!(Test-Path -LiteralPath $destinationRootPath)) {
		Write-Verbose -Message "Creating folder:  $destinationRootPath ..."
		New-Item -ItemType Directory -Path $destinationRootPath -Force
	}
	Write-Verbose -Message "Getting list of files in $dataLakeSearchPath ..."
	While ($found -ne 1) {
		$getParams = @{
			Account = $dataLakeStoreName;
			Path = $dataLakeSearchPath;
			ErrorAction = 'SilentlyContinue';
		}
		$dataLakeFiles = Get-AzureRmDataLakeStoreChildItem @getParams | Where-Object -FilterScript {$_.Name -like $searchPattern}
		$global:foundFiles = $dataLakeFiles
		If ($dataLakeFiles.Count -eq 0) {
			Write-Output "No files found in $dataLakeSearchPath. Waiting 60 seconds..."
			Start-Sleep -Seconds 60
		}
		ElseIf ($dataLakeFiles.Count -lt $expected) {
			Write-Output "Some files found, waiting 30 seconds for others..."
			Start-Sleep -Seconds 30
		}
		ElseIf ($dataLakeFiles.Count -eq $expected) {
			ForEach ($file in $dataLakeFiles) {
				Write-Verbose "Downloading file $($file.Name)..."
				$exportParams = @{
					Account = $dataLakeStoreName;
					Path = $($file.Path);
					Destination = $($destinationRootPath + $($file.Name));
					Force = $true
				}
				Export-AzureRmDataLakeStoreItem @exportParams
			}
			$found = 1
		}
		Else {
			throw New-Object -TypeName System.IO.FileNotFoundException
		}
	}
	Write-Output "All files downloaded successfully."
}
Function Insert-CsvToAzDb {
	[CmdletBinding()]
	Param(
		[string]$file,
		[string]$table
	)
	$global:command = "bcp $table in $file -S $server -d $database -U $sqlUser -P $sqlPass -f $formatFile -F 2 -t ',' -q"
	Write-Debug -Message $command
	Write-Verbose -Message "Inserting $file into AzureDB..."
	$result = Invoke-Expression -Command $command
	$global:bcpResult = $result
	If ([int]$($result[3].SubString(0, 1)) -gt 0) {
		Write-Verbose $result[3]
		Write-Verbose "Deleting $file ..."
		Remove-Item -Path $file -Force -ErrorAction Stop
	}
	Else {
		throw New-Object -TypeName System.ArgumentOutOfRangeException
	}
}
Function Confirm-Run {
	Write-Host '********************************************************************' -ForegroundColor Magenta
	Write-Host "Start Date      :: $startDate"
	Write-Host "End Date        :: $endDate"
	Write-Host "Expected Files  :: $expected"
	Write-Host "Search Pattern  :: $searchPattern"
	Write-Host '********************************************************************' -ForegroundColor Magenta
    $answer = Read-Host -Prompt "Are you sure you want to kick off $($range*$expected) jobs? (y/n)"
	Return $answer
}
$continue = Confirm-Run
If ($continue -eq 'y') {
	Try {	
		While ($i -lt $range) {
			$day = $($startDateObj.AddDays($i)).day.ToString("00")
			$month = $($startDateObj.AddDays($i)).month.ToString("00")
			$year = $($startDateObj.AddDays($i)).year.ToString("0000")
			$processDate = $year + $month + $day
			$dataLakeSearchPath = $dataLakeRootPath + $processDate
			$destinationRootPath = $destinationRoot + $processDate + '\'
			Get-DataLakeStructuredFiles -dataLakeSearchPath $dataLakeSearchPath -destinationRootPath $destinationRootPath -Verbose
			$structuredFiles = Get-ChildItem -Path $destinationRootPath -ErrorAction Stop
			$table = $null
			ForEach ($file in $structuredFiles) {
				If ($file.Name -like "*d1_121*") {
					$table = 'stg_TXNHeader_121'
					$formatFile = "C:\Scripts\XML\format121.xml"
				}
				ElseIf ($file.Name -like "*d1_122*") {
					$table = 'stg_TXNDetails_122'
					$formatFile = "C:\Scripts\XML\format122.xml"
				}
				ElseIf ($file.Name -like "*d1_124*") {
					$table = 'stg_Media_124'
					$formatFile = "C:\Scripts\XML\format124.xml"
				}
				ElseIf ($file.Name -like "*d1_136*") {
					$table = 'stg_PromoSales_136'
					$formatFile = "C:\Scripts\XML\format136.xml"
				}
				ElseIf ($file.Name -like "*d1_137*") {
					$table = 'stg_PromoSalesDetails_137'
					$formatFile = "C:\Scripts\XML\format137.xml"
				}	
				ElseIf ($file.Name -like "*d1_409*") {
					$table = 'stg_CouponSales_409'
					$formatFile = "C:\Scripts\XML\format409.xml"
				}
				ElseIf ($file.Name -like "*d1_410*") {
					$table = 'stg_CouponSalesDetails_410'
					$formatFile = "C:\Scripts\XML\format410.xml"
				}
				Else {
					throw New-Object -TypeName System.FormatException
				}
				Insert-CsvToAzDb -file $file.FullName -table $table -Verbose
				$global:goodFile = $file.Name
			}
			$i++
		}
	}
	Catch [System.IO.FileNotFoundException] {
		$errorParams = @{
			Exception = New-Object -TypeName System.Exception ("InvalidResult")
			Message = 'Failed to find the files in the data lake!';
			Category = 'InvalidResult';
			ErrorId = 477;
		}
		Write-Error @errorParams
		Write-Debug -Message "Files: $foundFiles"
		$exitCode = 1
	}
	Catch [System.FormatException] {
		$errorParams = @{
			Exception = New-Object -TypeName System.Exception ("InvalidResult")
			Message = 'You forgot to update the file and table names!';
			Category = 'InvalidResult';
			ErrorId = 133;
		}
		Write-Error @errorParams
		Write-Debug -Message "Files: $foundFiles"
		$exitCode = 2
	}
	Catch [System.ArgumentOutOfRangeException],[System.Management.Automation.RuntimeException] {
		$errorParams = @{
			Exception = New-Object -TypeName System.Exception ("InvalidResult")
			Message = 'BCP returned unexpected result!';
			Category = 'InvalidResult';
			ErrorId = 256;
		}
		Write-Error @errorParams
		Write-Debug -Message "Result: $bcpResult"
		$exitCode = 3
	}
	Catch {
		$errorParams = @{
			Exception = New-Object -TypeName System.Exception ("InvalidResult")
			Message = 'Unknown Error!';
			Category = 'InvalidResult';
			ErrorId = 444;
		}
		Write-Error @errorParams
		$exitCode = 4
	}
	Finally {
		Write-Output '------------------------------------------------------------------'
		Write-Verbose -Message "Cleaning up $destinationRoot ..."
		Write-Debug -Message "Last good file inserted: $goodFile"
		Remove-Item -Path $destinationRoot -Recurse -Force
		Write-Output "Start Time: $($startTime.DateTime)"
		Write-Output "End Time: $($(Get-Date).DateTime)"
		Write-Output '------------------------------------------------------------------'
		Exit $exitCode
	}
}
Else {
	Write-Output 'Exiting...'
	Exit 0
}
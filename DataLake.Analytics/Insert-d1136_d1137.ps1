Function Get-DataLakeStructuredFiles {
	[CmdletBinding()]
	Param(
		[string]$dataLakeSearchPath
	)
	Try {
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
			$dataLakeFiles = Get-AzureRmDataLakeStoreChildItem @getParams | Where-Object -FilterScript {$_.Name -like "*d1*13*output*"}
			If ($dataLakeFiles.Count -eq 1) {
				Write-Output "No files found. Waiting 60 seconds..."
				Start-Sleep -Seconds 60
			}
			ElseIf ($dataLakeFiles.Count -eq 2) {
				Write-Output "Found one file, waiting on the other..."
				Start-Sleep -Seconds 30
			}
			ElseIf ($dataLakeFiles.Count -eq 3) {
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
				Write-Error 'Something went wrong!!!'
				throw $_
			}
		}
		Write-Output "All files downloaded successfully."
	}
	Catch {
		throw $_
	}
}
Function Insert-CsvToAzDb {
	[CmdletBinding()]
	Param(
		[string]$file
	)
	$command = "bcp $table in $file -S $server -d $database -U $sqlUser -P $sqlPass -q -c -t ',' -F 2"
	Write-Debug -Message $command
	Write-Verbose -Message "Inserting $file into AzureDB..."
	$result = Invoke-Expression -Command $command
	If ($result[3].SubString(0, 1) -gt 0) {
		Write-Verbose "Deleting $file ..."
		Remove-Item -Path $file -Force -ErrorAction Stop
	}
	Else {
		throw $_
	}
}
Try {
	Write-Verbose -Message 'Importing AzureRm module...'
	Import-Module AzureRM -ErrorAction Stop
	$global:startDate = '10-23-2017'
	$global:endDate = '10-23-2017'
	$global:userName = 'gpink003'
	$global:dataLakeStoreName = 'mscrmprodadls'
	$global:dataLakeRootPath = '/BIT_CRM/'
	$global:destinationRootPath = 'C:\BIT_CRM\'
	$global:user = $userName + '@7-11.com'
	$global:database = '7ELE'
	$global:schema = 'dbo'
	$global:table = 'test'
	$global:sqlUser = 'sqladmin'
	$global:sqlPass = 'Password20!7!'
	$global:server = 'mstestsqldw.database.windows.net'
	$global:password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
	$global:credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
	Write-Verbose -Message 'Logging into Azure...'
	Login-AzureRmAccount -Credential $credential -ErrorAction Stop
	Write-Verbose -Message 'Setting subscription...'
	Set-AzureRmContext -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop
	$startDateObj = Get-Date -Date $startDate
	$endDateObj = Get-Date -Date $endDate
	$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
	$i = 0
	$dataLakeSearchPath = $null
	$structuredFiles = $null
	$processDate = $null
	While ($i -lt $range) {
		$day = $($startDateObj.AddDays($i)).day.ToString("00")
		$month = $($startDateObj.AddDays($i)).month.ToString("00")
		$year = $($startDateObj.AddDays($i)).year.ToString("0000")
		$processDate = $year + $month + $day
		$dataLakeSearchPath = $dataLakeRootPath + $processDate
		Get-DataLakeStructuredFiles -dataLakeSearchPath $dataLakeSearchPath -Verbose
		$structuredFiles = Get-ChildItem -Path $($destinationRootPath + $processDate) -ErrorAction Stop
		ForEach ($file in $structuredFiles) {
			Insert-CsvToAzDb -file $file.FullName -Verbose
		}
		$i++
	}
}
Catch {
	throw $_
}

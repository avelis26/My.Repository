Function Get-DataLakeRawFiles {
	[CmdletBinding()]
	Param(
		#######################################################################################################
		#######################################################################################################
		##   Enter the path where you want your aggregate files to be downloaded on your local machine:
		[string]$destinationRootPath = 'C:\BIT_CRM\',
		##   Enter the range of aggregate files you want to download in mm-dd-yyyy format:
		[string]$startDate = '10-23-2017',
		[string]$endDate = '10-23-2017',
		##   Enter your 7-11 user name without domain:
		[string]$userName = 'gpink003'
		#######################################################################################################
		#######################################################################################################
	)
	Try {
		Write-Verbose -Message 'Importing AzureRm module...'
		Import-Module AzureRM -ErrorAction Stop
		$user = $userName + '@7-11.com'
		$dataLakeStoreName = '711dlprodcons01'
		$dataLakeRootPath = "/BIT_CRM/"
		$startDateObj = Get-Date -Date $startDate
		$endDateObj = Get-Date -Date $endDate
		[int]$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
		$i = 0
		$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
		$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
		Write-Verbose -Message 'Logging into Azure...'
		Login-AzureRmAccount -Credential $credential -ErrorAction Stop
		Write-Verbose -Message 'Setting subscription...'
		Set-AzureRmContext -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop
		Write-Verbose -Message "Creating $destinationRootPath folder..."
		If (!(Test-Path -LiteralPath $destinationRootPath)) {
			Write-Verbose -Message "Creating folder:  $destinationRootPath ..."
			New-Item -ItemType Directory -Path $destinationRootPath -Force
		}
		While ($i -lt $range) {
			[string]$day = $($startDateObj.AddDays($i)).day.ToString("00")
			[string]$month = $($startDateObj.AddDays($i)).month.ToString("00")
			[string]$year = $($startDateObj.AddDays($i)).year.ToString("0000")
			$processDate = $year + $month + $day
			$dataLakeSearchPath = $dataLakeRootPath + $processDate
			Write-Verbose -Message "Getting list of files in $dataLakeSearchPath ..."
			$getParams = @{
				Account = $dataLakeStoreName;
				Path = $dataLakeSearchPath;
				ErrorAction = 'SilentlyContinue';
			}
			$dataLakeFolder = Get-AzureRmDataLakeStoreItem @getParams
			Write-Verbose "Downloading folder $($dataLakeFolder.Path)..."
			$exportParams = @{
				Account = $dataLakeStoreName;
				Path = $($dataLakeFolder.Path);
				Destination = $($destinationRootPath + $processDate + '\');
				Force = $true
			}
				Export-AzureRmDataLakeStoreItem @exportParams
			$i++
		}
		Write-Output "All files downloaded successfully."
	}
	Catch {
		throw $_
	}
}
Get-DataLakeRawFiles -Verbose

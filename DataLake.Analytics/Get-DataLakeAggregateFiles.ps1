Function Get-DataLakeAggregateFiles {
	[CmdletBinding()]
	Param(
		#######################################################################################################
		#######################################################################################################
		##   This option is the folder on your local machine where you would like the files to be downloaded:##
		[string]$destinationRootPath = 'C:\BIT_CRM\',                                                        ##
		##   This option is which day you want to be the beginning of your downloads to start at:            ##
		[string]$startDate = '10-23-2017',                                                                   ##
		[string]$endDate = '11-22-2017'                                                                      ##
		#######################################################################################################
		#######################################################################################################
	)
	$dataLakeStoreName = 'mscrmprodadls'
	$dataLakeRootPath = "/BIT_CRM/"
	$startDateObj = Get-Date -Date $startDate
	$endDateObj = Get-Date -Date $endDate
	[int]$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
	$i = 0
	Try {
		Write-Verbose -Message 'Importing AzureRm module...'
		Import-Module AzureRM -ErrorAction Stop
		Write-Verbose -Message 'Logging into Azure...'
		$user = 'gpink003@7-11.com'
		$password = ConvertTo-SecureString -String $(Get-Content -Path 'C:\Users\graham.pinkston\Documents\Secrets\op1.txt')
		$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
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
			$dataLakeFiles = Get-AzureRmDataLakeStoreChildItem @getParams | Where-Object -FilterScript {$_.Name -like "*txn*"}
			ForEach ($file in $dataLakeFiles) {
				Write-Verbose "Downloading file $($file.Name)..."
				$exportParams = @{
					Account = $dataLakeStoreName;
					Path = $($file.Path);
					Destination = $($destinationRootPath + $processDate + '\' + $($file.Name));
					Force = $true
				}
				Export-AzureRmDataLakeStoreItem @exportParams
			}
			$i++
		}
		Write-Output "All files downloaded successfully."
	}
	Catch {
		throw $_
	}
}
Get-DataLakeAggregateFiles -Verbose

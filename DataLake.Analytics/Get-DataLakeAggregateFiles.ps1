Function Get-DataLakeAggregateFiles {
	[CmdletBinding()]
	Param(
	#######################################################################################################
	#######################################################################################################
	##   This option is the folder on your local machine where you would like the files to be downloaded:##
	[string]$destinationRootPath = 'C:\BIT_CRM\',                                                        ##
	##   This option is which day you want to be the beginning of your downloads to start at:            ##
	[string]$startDate = '10-27-2017',                                                                   ##
	##   This option is how many days ahead you want to download (1 = one day only):                     ##
	[int]$range = 3                                                                                      ##
	#######################################################################################################
	#######################################################################################################
	)
	$seiDataLakeName = '711dlprodcons01'
	$ansiraDataLakeName = 'mscrmprodadls'
	$dataLakeRootPath = "/BIT_CRM/Aggregates/"
	$i = 0
	Try {
		Write-Verbose -Message 'Importing AzureRm module...'
		Import-Module AzureRM

		Write-Verbose -Message 'Logging into Azure...'
		Login-AzureRmAccount -ErrorAction Stop

		Write-Verbose -Message 'Setting subscription...'
		Set-AzureRmContext -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop

		Write-Verbose -Message "Creating $destinationRootPath folder..."
		If (!(Test-Path -LiteralPath $destinationRootPath)) {
			Write-Verbose -Message "Creating folder:  $destinationRootPath ..."
			New-Item -ItemType Directory -Path $destinationRootPath -Force
		}
		While ($i -lt $range) {
			$date = Get-Date -Date $startDate
			[string]$day = $($date.AddDays($i)).day.ToString("00")
			[string]$month = $($date.AddDays($i)).month.ToString("00")
			[string]$year = $($date.AddDays($i)).year.ToString("0000")
			$processDate = $year + $month + $day
			$dataLakeSearchPath = $dataLakeRootPath + $processDate
			Write-Verbose -Message "Getting list of files in $dataLakeSearchPath ..."
			$dataLakeFiles = Get-AzureRmDataLakeStoreChildItem -Account $seiDataLakeName -Path $dataLakeSearchPath -ErrorAction SilentlyContinue
			ForEach ($file in $dataLakeFiles) {
				Write-Verbose "Downloading file $($file.Name)..."
				$params = @{
					Account = $seiDataLakeName;
					Path = $($file.Path);
					Destination = $($destinationRootPath + $processDate + '\' + $($file.Name))
				}
				Export-AzureRmDataLakeStoreItem @params
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

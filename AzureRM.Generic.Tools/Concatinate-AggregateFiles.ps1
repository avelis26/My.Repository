Function Concatinate-AggregateFiles {
	[CmdletBinding()]
	Param(
		#######################################################################################################
		#######################################################################################################
		##   This option is the folder on your local machine where you would like the files to be downloaded:
		[string]$destinationRootPath = 'C:\BIT_CRM\',
		##   This option is which day you want to be the beginning of your downloads to start at:
		[string]$startDate = '10-23-2017',
		[string]$endDate = '11-22-2017'
		#######################################################################################################
		#######################################################################################################
	)
	$startDateObj = Get-Date -Date $startDate
	$endDateObj = Get-Date -Date $endDate
	$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
	$i = 0
	Try {
		$startYear = $startDateObj.Year.ToString("0000")
		$startMonth = $startDateObj.Month.ToString("00")
		$startDay = $startDateObj.Day.ToString("00")
		$endYear = $endDateObj.Year.ToString("0000")
		$endMonth = $endDateObj.Month.ToString("00")
		$endDay = $endDateObj.Day.ToString("00")
		$destinationFolder = $destinationRootPath + $startYear + $startMonth + $startDay + '-' + $endYear + $endMonth + $endDay + '\'
		If (!(Test-Path -LiteralPath $destinationFolder)) {
			Write-Verbose -Message "Creating folder:  $destinationFolder ..."
			New-Item -ItemType Directory -Path $destinationFolder -Force
		}
		While ($i -lt $range) {
			$day = $($startDateObj.AddDays($i)).Day.ToString("00")
			$month = $($startDateObj.AddDays($i)).Month.ToString("00")
			$year = $($startDateObj.AddDays($i)).Year.ToString("0000")
			$processDate = $year + $month + $day
			$folder = $destinationRootPath + $processDate
			'_Product_Daypart_TxnDetails.csv'
			'_Store_Item_TxnTotal.csv'
			'_Tender_Types_TxnType.csv'

		}
	}
	Catch {
		throw $_
	}
}
Concatinate-AggregateFiles -Verbose
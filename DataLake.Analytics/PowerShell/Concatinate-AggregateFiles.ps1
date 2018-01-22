Function Concatinate-AggregateFiles {
	[CmdletBinding()]
	Param(
		#######################################################################################################
		#######################################################################################################
		##   Enter folder where aggregate files were downloaded (include backslash at end):
		[string]$destinationRootPath = 'C:\BIT_CRM\',
		##   Enter the range you want to concatenate in mm-dd-yyyy format:
		[string]$startDate = '10-23-2017',
		[string]$endDate = '11-22-2017'
		#######################################################################################################
		#######################################################################################################
	)
	$startDateObj = Get-Date -Date $startDate
	$endDateObj = Get-Date -Date $endDate
	$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
	$i = 0
	$prodSuffix = '_Product_Daypart_TxnDetails.csv'
	$storSuffix = '_Store_Item_TxnTotal.csv'
	$tendSuffix = '_Tender_Types_TxnType.csv'
	$startYear = $startDateObj.Year.ToString("0000")
	$startMonth = $startDateObj.Month.ToString("00")
	$startDay = $startDateObj.Day.ToString("00")
	$endYear = $endDateObj.Year.ToString("0000")
	$endMonth = $endDateObj.Month.ToString("00")
	$endDay = $endDateObj.Day.ToString("00")
	$destinationFolder = $destinationRootPath + $startYear + $startMonth + $startDay + '-' + $endYear + $endMonth + $endDay + '\'
	$prodOutFile = $destinationFolder + $startYear + $startMonth + $startDay + '-' + $endYear + $endMonth + $endDay + $prodSuffix
	$storOutFile = $destinationFolder + $startYear + $startMonth + $startDay + '-' + $endYear + $endMonth + $endDay + $storSuffix
	$tendOutFile = $destinationFolder + $startYear + $startMonth + $startDay + '-' + $endYear + $endMonth + $endDay + $tendSuffix
	Try {
		If (!(Test-Path -LiteralPath $destinationFolder)) {
			Write-Verbose -Message "Creating folder:  $destinationFolder ..."
			New-Item -ItemType Directory -Path $destinationFolder -Force -ErrorAction Stop
		}
		While ($i -lt $range) {
			$day = $($startDateObj.AddDays($i)).Day.ToString("00")
			$month = $($startDateObj.AddDays($i)).Month.ToString("00")
			$year = $($startDateObj.AddDays($i)).Year.ToString("0000")
			$processDate = $year + $month + $day
			$folder = $destinationRootPath + $processDate + '\'
			Write-Verbose -Message "Adding content from $($folder + $processDate + $prodSuffix) to $prodOutFile..."
			$prodContent = Get-Content -Path $($folder + $processDate + $prodSuffix)
			$lastLine = $null
			If ($prodContent.Length -eq $null) {
				$lastLine = $prodContent.Length - 1
			}
			ElseIf ($prodContent.Length -eq '') {
				$lastLine = $prodContent.Length - 1
			}
			Else {
				$lastLine = $prodContent.Length
			}
			Add-Content -Value $prodContent[1..$lastLine] -Path $prodOutFile -ErrorAction Stop
			Write-Verbose -Message "Adding content from $($folder + $processDate + $storSuffix) to $storOutFile..."
			$storContent = Get-Content -Path $($folder + $processDate + $storSuffix)
			$lastLine = $null
			If ($storContent.Length -eq $null) {
				$lastLine = $storContent.Length - 1
			}
			ElseIf ($storContent.Length -eq '') {
				$lastLine = $storContent.Length - 1
			}
			Else {
				$lastLine = $storContent.Length
			}
			Add-Content -Value $storContent[1..$lastLine] -Path $storOutFile -ErrorAction Stop
			Write-Verbose -Message "Adding content from $($folder + $processDate + $tendSuffix) to $tendOutFile..."
			$tendContent = Get-Content -Path $($folder + $processDate + $tendSuffix)
			$lastLine = $null
			If ($tendContent.Length -eq $null) {
				$lastLine = $tendContent.Length - 1
			}
			ElseIf ($tendContent.Length -eq '') {
				$lastLine = $tendContent.Length - 1
			}
			Else {
				$lastLine = $tendContent.Length
			}
			Add-Content -Value $tendContent[1..$lastLine] -Path $tendOutFile -ErrorAction Stop
			$i++
		}
	}
	Catch {
		throw $_
	}
}
Concatinate-AggregateFiles -Verbose

$VerbosePreference = 'Continue'
Try {
	Import-Module AzureRM -ErrorAction Stop
}
Catch {
	$_
}
$startDate = '10-26-2017'
$subId = 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$rg = 'CRM-ADLA-RG'
$adla = 'mscrmprodadla'
$adls = 'mscrmprodadls'
$location = 'East US 2'
$usqlRootPath = 'C:\Users\avelis\source\repos\SEI_Data_Lake_Analyitcs\Aggregate_SEI_BIT_Data\'
#$usqlRootPath = 'C:\Users\avelis\source\repos\SEI_Data_Lake_Analyitcs\Parse_SEI_BIT_Data\'
$scripts = Get-ChildItem -Path $usqlRootPath -Filter "*Txn*.usql" -File
#$scripts = Get-ChildItem -Path $usqlRootPath -Filter "*12*.usql" -File | Where-Object -FilterScript {$_.Name -like "*121*" -or $_.Name -like "*122*" -or $_.Name -like "*124*"}
$alter = 12
#$alter = 3
$parallel = 5
$range = 1
$i = 0
$x = $i
Try {
	Get-AzureRmContext 
	Login-AzureRmAccount -SubscriptionId $subId -ErrorAction Stop
	Set-AzureRmContext -Subscription $subId
	While ($i -lt $range) {
		$date = Get-Date -Date $startDate
		[string]$day = $($date.AddDays($i)).day.ToString("00")
		[string]$month = $($date.AddDays($i)).month.ToString("00")
		[string]$year = $($date.AddDays($i)).year.ToString("0000")
		$processDate = $year + $month + $day
		ForEach ($script in $scripts) {
			$x++
			$code = Get-Content -Path $script.FullName
			$code[$alter] = "DECLARE @datedFolder string = ""$processDate"";"
			$scratchPad = "c:\temp\$processDate-$($script.Name)"
			$code | Set-Content -Path $scratchPad -Force
			Write-Verbose "----------------------------------------------------------------"
			Write-Verbose "Starting job $x of $($range*3) :: $($script.BaseName + '-' +$processDate)..."
			Submit-AdlJob -Account $adla -Name $($script.BaseName + '-' +$processDate) -ScriptPath $scratchPad -DegreeOfParallelism $parallel
			Start-Sleep -Seconds 2
		}
		$i++
	}
}
Catch {
	$_
}
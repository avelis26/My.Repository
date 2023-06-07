$begin = Get-Date
$total = 9999
$min = 0
$max = 999999
$pivot = 555555
$i = 0
$above = @()
$below = @()
Function Get-Percentage {
	Param (
		[int]$value,
		[int]$total
	)
	Return $(($value / $total) * 100).ToString("#.#")
}
Try {
	While ($i -lt $total) {
		$number = Get-Random -Minimum $min -Maximum $max
		Write-Host $number -NoNewline
		If ($number -lt $pivot) {
			$below += $number
			Write-Host -ForegroundColor Red "	The number is below $pivot"
		} Else {
			$above += $number
			Write-Host -ForegroundColor Green "	The number is above $pivot"
		}
		$i++
	}
	Write-Host -ForegroundColor Red "The below count was: $($below.Count) out of $total, or $(Get-Percentage -value $below.Count -total $total)%"
	Write-Host -ForegroundColor Green "The above count was: $($above.Count) out of $total, or $(Get-Percentage -value $above.Count -total $total)%"
} Catch {
	Write-Error "Something went wrong!!!"
} Finally {
	$runTime = New-TimeSpan -Start $begin -End $(Get-Date)
	Write-Host -ForegroundColor Cyan "The run time was: $runTime"
}

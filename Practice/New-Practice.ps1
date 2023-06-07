$total = 78
$i = 0
$above = @()
$below = @()
While ($i -lt $total) {
	$number = Get-Random -Minimum 0 -Maximum 999
	Write-Host $number -NoNewline
	If ($number -lt 500) {
		$below += $number
		Write-Host -ForegroundColor Red "	The number is below 500"
	} Else {
		$above += $number
		Write-Host -ForegroundColor Green "	The number is above 500"
	}
	$i++
}
function Get-Percentage {
	param (
		[int]$value,
		[int]$total
	)
	Return $(($value / $total) * 100).ToString("#.#")
}
Write-Host -ForegroundColor Red "The below count was: $($below.Count) out of $total, or $(Get-Percentage -value $below.Count -total $total)%"
Write-Host -ForegroundColor Green "The above count was: $($above.Count) out of $total, or $(Get-Percentage -value $above.Count -total $total)%"

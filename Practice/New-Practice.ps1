Clear-Host
$total = 10
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
Write-Host -ForegroundColor Red "The below count was: $($below.Count) out of $total, or $(($below.Count / $total) * 100)%"
Write-Host -ForegroundColor Green "The above count was: $($above.Count) out of $total, or $(($above.Count / $total) * 100)%"

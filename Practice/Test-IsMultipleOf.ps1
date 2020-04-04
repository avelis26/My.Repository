Function Test-IsMultipleOf {
	param(
		[Parameter(Mandatory=$true)]
		[int]
		$inputValue,
		[Parameter(Mandatory=$true)]
		[int]
		$multipleValue
	)
	$num = $inputValue
	$mul = $multipleValue
	while ($num -gt 0) {
		$num = $num - $mul
	}
	if ($num -eq 0) {
		Write-Output -InputObject $true
	} else {
		Write-Output -InputObject $false
	}
}
Clear-Host
$multiples = 3, 5
$range = 1..999
$results = @()
ForEach ($number in $range) {
	ForEach ($multiple in $multiples) {
		if ($(Test-IsMultipleOf -inputValue $number -multipleValue $multiple) -eq $true) {
			Write-Host -BackgroundColor Black -ForegroundColor Green "$number is a multiple of $multiple."
			$results += $number
		} else {
			Write-Host -BackgroundColor Black -ForegroundColor Red "$number is NOT a multiple of $multiple."
		}
	}
}

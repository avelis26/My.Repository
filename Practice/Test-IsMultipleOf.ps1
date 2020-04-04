<#
  .SYNOPSIS
  This script is the answer to a pre-interview question asked Loan Depot.

  .DESCRIPTION
  The original question asked was: "If we list all the natural numbers below 10
  that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these 
  multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000."

  .NOTES
  Version 1.0.0

  .INPUTS
  Inputs are hard coded values.

  .OUTPUTS
  The sum of a list of natrual numbers.

  .EXAMPLE
  C:\PS> .\Test-IsMultipoleOf.ps1
#>
Clear-Host
$multiples = 3, 5
$range = 1..999
$sum = 0
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
ForEach ($number in $range) {
	ForEach ($multiple in $multiples) {
		if ($(Test-IsMultipleOf -inputValue $number -multipleValue $multiple) -eq $true) {
			Write-Host -BackgroundColor Black -ForegroundColor Green "$number is a multiple of $multiple."
			$sum += $number
		} else {
			Write-Host -BackgroundColor Black -ForegroundColor Red "$number is NOT a multiple of $multiple."
		}
	}
}
Write-Host -BackgroundColor Black -ForegroundColor Cyan "The sum of all the multiples of 3 OR 5 found between 1 and 999 is $($sum.ToString('N0'))."

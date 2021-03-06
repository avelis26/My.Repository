<#
  .SYNOPSIS
  This script is the submitted answer to a pre-interview question.

  .DESCRIPTION
  The original question asked was: "If we list all the natural numbers below 10
  that are multiples of 3 or 5, we get [3, 5, 6, 9]. The sum of these 
  multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000."

  .NOTES
  Version 1.0.3

  .INPUTS
  Inputs are hard coded values.

  .OUTPUTS
  The sum of a list of natrual numbers.

  .EXAMPLE
  C:\PS> .\Test-IsMultipoleOf.ps1
#>
Clear-Host
$multiples = 3, 5
$range = 0..999
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
	while ($inputValue -gt 0) {
		$inputValue = $inputValue - $multipleValue
	}
	if ($inputValue -eq 0) {
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
Write-Host -BackgroundColor Black -ForegroundColor Cyan "The sum of all multiples of 3 OR 5 found between $($range[0]) and $($range[-1]) is $($sum.ToString('N0'))."

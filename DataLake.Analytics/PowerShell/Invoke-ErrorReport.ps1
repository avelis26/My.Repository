Function Invoke-ErrorReport {
	[CmdletBinding()]
	Param(
		[string]$subject,
		[string]$log
	)
	Add-Content -Value $subject -Path $log -ErrorAction Stop
	$errorInfo = $($Error[0].Exception.Message), `
		$($Error[0].Exception.InnerException.Message), `
		$($Error[0].Exception.InnerException.InnerException.Message), `
		$($Error[0].CategoryInfo.Activity), `
		$($Error[0].CategoryInfo.Reason), `
		$($Error[0].InvocationInfo.Line)
	ForEach ($line in $errorInfo) {
		Add-Content -Value $line -Path $log -ErrorAction Stop
	}
	$exitCode = 1
}
Try {
	$userName = Read-Host -Prompt "Please enter your 7-11 username without the domain."
	$passFileName = "$userName.cred"
	$passFileRootPath = "C:\Scripts\Secrets\"
	If (!(Test-Path -LiteralPath $passFileRootPath)) {
		Write-Verbose -Message "Creating folder:  $passFileRootPath"
		New-Item -ItemType Directory -Path $passFileRootPath -Force -ErrorAction Stop
	}
	$secPass = Read-Host -Prompt "Please enter your 7-11 password." -AsSecureString
	$encPass = ConvertFrom-SecureString -SecureString $secPass
	Set-Content -Value $encPass -LiteralPath $($passFileRootPath + $passFileName) -ErrorAction Stop
	Write-Output $($passFileRootPath + $passFileName)
}
Catch {
	throw $_
	Write-Host -ForegroundColor Magenta 'Run PowerShell ISE as Administrator'
}

Function Create-EncryptedCreds {
	[CmdletBinding()]
	Param(
		#######################################################################################################
		#######################################################################################################
		## Enter your 7-11 username without the domain:
		$userName = 'gpink003'
		#######################################################################################################
		#######################################################################################################
	)
	Try {
		$passFileName = "$userName.cred"
		$passFileRootPath = "C:\Scripts\Secrets\"
		If (!(Test-Path -LiteralPath $passFileRootPath)) {
			Write-Verbose -Message "Creating folder:  $passFileRootPath"
			New-Item -ItemType Directory -Path $passFileRootPath -Force -ErrorAction Stop
		}
		$secPass = Read-Host -Prompt "Please type your 7-11 password and hit 'Enter'..." -AsSecureString
		$encPass = ConvertFrom-SecureString -SecureString $secPass
		Set-Content -Value $encPass -LiteralPath $($passFileRootPath + $passFileName) -ErrorAction Stop
		Write-Output $($passFileRootPath + $passFileName)
	}
	Catch {
		throw $_
		Write-Host -ForegroundColor Magenta 'Run PowerShell ISE as Administrator'
	}
}
Create-EncryptedCreds -Verbose

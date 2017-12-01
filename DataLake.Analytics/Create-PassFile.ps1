#####################################################################################
$clrPass = '9uNb0u|\|d><2600@' ##-Don't save file with password, clear before save-##
#####################################################################################
$passFileName = 'op1.txt'
$passFileRootPath = 'C:\Users\graham.pinkston\Documents\Secrets\'
If (!(Test-Path -LiteralPath $passFileRootPath)) {
	Write-Verbose -Message "Creating folder:  $passFileRootPath"
	New-Item -ItemType Directory -Path $passFileRootPath -Force
}
$secPass = ConvertTo-SecureString -String $clrPass -AsPlainText -Force
$encPass = ConvertFrom-SecureString -SecureString $secPass
Set-Content -Value $encPass -LiteralPath $($passFileRootPath + $passFileName)
#####################################################################################
$clrPass = '' ##-Don't save file with password, clear before save-##
#####################################################################################
$passFileName = 'op1.txt'
$passFileRootPath = 'C:\Users\graham.pinkston\Documents\Secrets\'
$secPass = ConvertTo-SecureString -String $clrPass -AsPlainText -Force
$encPass = ConvertFrom-SecureString -SecureString $secPass
Set-Content -Value $encPass -LiteralPath $($passFileRootPath + $passFileName)
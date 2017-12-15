$path = 'C:\Users\graham.pinkston\secrets\'
$user = Get-Content -Path ($path + 'user.txt')
$pass = Get-Content -Path ($path + 'pass.txt')
$secUser = ConvertTo-SecureString -String $user -AsPlainText -Force
$secPass = ConvertTo-SecureString -String $pass -AsPlainText -Force
$encUser = ConvertFrom-SecureString -SecureString $secUser
$encPass = ConvertFrom-SecureString -SecureString $secPass
Set-Content -Value $encUser -Path ($path + 'encUser.txt')
Set-Content -Value $encPass -Path ($path + 'encPass.txt')
$user = Get-Content -Path ($path + 'encUser.txt') | ConvertTo-SecureString
$pass = Get-Content -Path ($path + 'encPass.txt') | ConvertTo-SecureString
$pair = "${user}:${pass}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes) 
Set-Content -Value $base64 -Path ($path + 'base64Creds.txt')
Write-Output '----------------------------'
Write-Output -InputObject $base64
Write-Output '----------------------------'
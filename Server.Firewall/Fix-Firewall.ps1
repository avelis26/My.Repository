Import-Module AzureRM
$password = Get-Content "C:\Users\graham.pinkston\Documents\Secrets\op1.txt" | ConvertTo-SecureString
$user = "gpink003@7-11.com"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Login-AzureRmAccount -Credential $credential
Set-AzureRmContext -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$statusObj = Get-AzureRmVM -ResourceGroupName crm-firewall2-rg -Name mssslcrmfw2 -Status
Write-Host 'god just killed a kitten'
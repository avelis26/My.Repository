Clear-Host
Login-AzureRmAccount
Set-AzureRmContext –SubscriptionID 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$encPass = Get-Content -Path 'C:\Users\graham.pinkston\Documents\Secrets\op1.txt'
$passwd = ConvertTo-SecureString $encPass
$mysecret = New-Object System.Management.Automation.PSCredential("gpink003", $passwd)
$params = {
    Database = '7ELE'
    Host = 'msprodsqldw.database.windows.net'
    Port = 1433
    Secret = $mysecret
    AccountName = 'mscrmprodadla'
}
New-AzureDataLakeAnalyticsCatalogSecret @params
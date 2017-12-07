Clear-Host
Import-Module AzureRm
Login-AzureRmAccount
Set-AzureRmContext -SubscriptionID 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$encPass = Get-Content -Path 'C:\Users\graham.pinkston\Documents\Secrets\op1.txt'
$passwd = ConvertTo-SecureString $encPass
$cred = New-Object System.Management.Automation.PSCredential('gpink003@7-11.com', $passwd)
$params = @{
	Account = 'mscrmprodadla';    
	DatabaseName = 'master';
	CredentialName = 'gpink003';
	Credential = $cred;
	DatabaseHost = 'msprodsqldw.database.windows.net';
	Port = 1433
}
New-AzureRmDataLakeAnalyticsCatalogCredential @params

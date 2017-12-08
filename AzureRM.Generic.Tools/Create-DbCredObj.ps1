Clear-Host
Import-Module AzureRm
Login-AzureRmAccount
Set-AzureRmContext -SubscriptionID 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$encPass = Get-Content -Path 'C:\Users\graham.pinkston\Documents\Secrets\op1.txt'
$passwd = ConvertTo-SecureString $encPass
$cred1 = New-Object System.Management.Automation.PSCredential('gpink003@7-11.com', $passwd)
$cred2 = New-Object System.Management.Automation.PSCredential('gpink003@7-11.com@msprodsqldw', $passwd)
$createParams1 = @{
	Account = 'mscrmprodadla';
	DatabaseName = 'master';
	CredentialName = 'gpink003';
	Credential = $cred;
	DatabaseHost = 'msprodsqldw.database.windows.net';
	Port = 1433
}
$createParams2 = @{
	Account = 'mscrmprodadla';
	DatabaseName = 'master';
	CredentialName = 'gpink003_instance';
	Credential = $cred;
	DatabaseHost = 'msprodsqldw.database.windows.net';
	Port = 1433
}
$removeParams = @{
	Account = 'mscrmprodadla';
	DatabaseName = 'master';
	Name = 'gpink003';
}
Remove-AzureRmDataLakeAnalyticsCatalogCredential @removeParams
Start-Sleep -Seconds 3
New-AzureRmDataLakeAnalyticsCatalogCredential @createParams2

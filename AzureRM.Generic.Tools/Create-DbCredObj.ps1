Clear-Host
Import-Module AzureRm -ErrorAction Stop
Login-AzureRmAccount -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$encPass = Get-Content -Path 'C:\Users\gpink003\Documents\Secrets\sqladmin.cred'
$passwd = ConvertTo-SecureString $encPass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential('sqladmin', $passwd)
$credParams = @{
	Account = 'mscrmprodadla';
	DatabaseName = 'master';
	CredentialName = 'MsTestSqlDw_7ELE';
	Credential = $cred;
	DatabaseHost = 'mstestsqldw.database.windows.net';
	Port = 1433
}
New-AzureRmDataLakeAnalyticsCatalogCredential @credParams

<#
$removeParams = @{
	Account = 'mscrmprodadla';
	DatabaseName = 'master';
	Name = 'MsTestSqlDw-7ELE';
	Force = $true;
	Password = $cred
}
Remove-AzureRmDataLakeAnalyticsCatalogCredential @removeParams
#>
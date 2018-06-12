Function Copy-SqlDataFromProd {
	Import-Module SqlServer -ErrorAction Stop
	$sqlServer = 'MS-SSW-CRM-SQL'
	$database = '7ELE'
	$sqlUser = 'sqladmin'
	$sqlPass = Get-Content -Path 'C:\Scripts\Secrets\sqlAdmin.txt' -ErrorAction Stop
	$query = @"
	TRUNCATE TABLE [7ELE].[dbo].[COMN_Address]
	TRUNCATE TABLE [7ELE].[dbo].[RPTS_Calendar]
	TRUNCATE TABLE [7ELE].[dbo].[STOR_Master]
	TRUNCATE TABLE [7ELE].[dbo].[TRNS_ProductMaster]
"@
	$sqlTruncateParams = @{
		query = $query;
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @sqlTruncateParams
	Start-Sleep -Seconds 1
	$DTExec = "C:\Program Files\Microsoft SQL Server\140\DTS\Binn\DTExec.exe"
	$package = "C:\Scripts\SQL\CopyDataFromProd.dtsx"
	$params = "/f $package /Decrypt $sqlPass"
	& $DTExec $params
	Start-Sleep -Seconds 1
}
$startTime = Get-Date
$global:smtpServer = '10.128.1.125'
$global:port = 25
$global:fromAddr = 'noreply@7-11.com'
$global:toAddr = 'graham.pinkston@ansira.com', 'mayank.minawat@ansira.com', 'tyler.bailey@ansira.com'
$global:userName = 'gpink003'
$global:user = $userName + '@7-11.com'
$global:database = '7ELE'
$global:sqlUser = 'sqladmin'
$global:sqlPass = 'Password20!7!'
$global:sqlServer = 'mstestsqldw.database.windows.net'
$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
If ($policy -ne 'TrustAllCertsPolicy') {
	add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
	public bool CheckValidationResult(
		ServicePoint srvPoint, X509Certificate certificate,
		WebRequest request, int certificateProblem
	) {
		return true;
	}
}
"@
	[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}
Import-Module -Name AzureRM -ErrorAction Stop
Import-Module -Name SqlServer -ErrorAction Stop
$sqlAggTwoParams = @{
	query = "DBCC SHRINKFILE (log, 0) WITH NO_INFOMSGS";
	ServerInstance = $sqlServer;
	Database = $database;
	Username = $sqlUser;
	Password = $sqlPass;
	QueryTimeout = 0;
	ErrorAction = 'Stop';
}
$result = Invoke-Sqlcmd @sqlAggTwoParams
Login-AzureRmAccount -Credential $credential -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec' -ErrorAction Stop
$params = @{
    ResourceGroupName = 'CRM-TEST-RG';
    ServerName = 'mstestsqldw';
    DatabaseName = '7ELE';
    Edition = 'Premium';
    RequestedServiceObjectiveName = 'P15';
}
Set-AzureRmSqlDatabase @params
$endTime = Get-Date
$span = New-TimeSpan -Start $startTime -End $endTime
Write-Output $span
$params = @{
	SmtpServer = $smtpServer;
	Port = $port;
	UseSsl = 0;
	From = $fromAddr;
	To = $toAddr;
	BodyAsHtml = $true;
	Subject = "BITC: $message";
	Body = "BITC: Database has been scaled up to a p15 successfully."
}
Send-MailMessage @params
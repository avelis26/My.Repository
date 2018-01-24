$server = 'ms-ssw-crm-bitc'
$resourceGroup = 'CRM-Production-RG'
$user = $userName + '@7-11.com'
$userName = 'gpink003'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$emailList = 'graham.pinkston@ansira.com'
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
$params = @{
	SmtpServer = $smtpServer;
	Port = $port;
	UseSsl = 0;
	From = $fromAddr;
	To = $emailList;
	Subject = "$env:USERNAME Has Initiated $server Startup";
	Body = "$server is starting up."
}
Send-MailMessage @params
Import-Module AzureRM -ErrorAction Stop
$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Login-AzureRmAccount -Credential $credential -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec' -ErrorAction Stop
Start-AzureRmVM -ResourceGroupName $resourceGroup -Name $server -Force
$params = @{
	SmtpServer = $smtpServer;
	Port = $port;
	UseSsl = 0;
	From = $fromAddr;
	To = $emailList;
	Subject = "$server Startup Successful";
	Body = "Have a nice day."
}
Send-MailMessage @params
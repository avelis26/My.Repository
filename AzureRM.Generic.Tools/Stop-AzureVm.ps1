$server = 'ms-ssw-crm-bitc'
$currentUser = $env:USERNAME
$userName = 'gpink003@7-11.com'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$emailList = 'graham.pinkston@ansira.com'
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
$params = @{
	SmtpServer = $smtpServer;
	Port = $port;
	UseSsl = 0;
	From = $fromAddr;
	To = $emailList;
	Subject = "$currentUser Has Initiated $server Shutdown";
	Body = "$server is shutting down."
}
Send-MailMessage @params
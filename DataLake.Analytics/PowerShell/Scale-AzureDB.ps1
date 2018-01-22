$startTime = Get-Date
[string]$global:userName = 'gpink003'
$global:user = $userName + '@7-11.com'
$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Import-Module -Name AzureRM
Login-AzureRmAccount -Credential $credential -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec' -ErrorAction Stop
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
    ResourceGroupName = 'CRM-TEST-RG';
    ServerName = 'mstestsqldw';
    DatabaseName = '7ELE';
    Edition = 'Premium';
    RequestedServiceObjectiveName = 'P10';
}
Set-AzureRmSqlDatabase @params
$endTime = Get-Date
$span = New-TimeSpan -Start $startTime -End $endTime
Write-Output $span
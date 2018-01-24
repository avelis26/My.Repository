$server = 'MS-SSW-CRM-BITC'
$resourceGroup = 'CRM-Production-RG'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$emailList = 'graham.pinkston@ansira.com'
Try {
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
		Subject = "$env:USERNAME Has Initiated $server Shutdown";
		Body = "$server is shutting down."
	}
	Send-MailMessage @params
	Import-Module AzureRM -ErrorAction Stop
	$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\gpink003\Documents\Secrets\gpink003.cred")
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'gpink003@7-11.com', $password
	Login-AzureRmAccount -Credential $credential -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec' -ErrorAction Stop
	$continue = Read-Host -Prompt "Are you super super sure you want to SHUTDOWN $server? (y/n)"
	If ($continue -eq 'y') {
		Stop-AzureRmVM -ResourceGroupName $resourceGroup -Name $server -Force
	}
	Else {
		Write-Output "You choose something other than 'y' sooooo have a nice day :)"
	}
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		Subject = "$server Shutdown Successful";
		Body = "Have a nice day."
	}
	Send-MailMessage @params
}
Catch {
	Write-Error -Message 'Something bad happened!!!' -Exception $($Error[0].Exception)
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "$server FAILED TO START UP!!!";
		Body = @"
<font face='consolas'>
Something bad happened!!!<br><br>
Failed Command:  $($Error[0].CategoryInfo.Activity)<br>
<br>
         Error:  $($Error[0].Exception.Message)<br>
</font>
"@
	}
	Start-Sleep -Seconds 2
	Send-MailMessage @params
}
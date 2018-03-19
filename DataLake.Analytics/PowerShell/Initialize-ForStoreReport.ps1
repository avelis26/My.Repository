# Version  --  v1.0.0.0
######################################################
######################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $false)][switch]$autoDate,
	[parameter(Mandatory = $false)][switch]$test,
	[parameter(Mandatory = $false)][switch]$scale
)
Try {
# Init
	[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
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
	Import-Module SqlServer -ErrorAction Stop
	Import-Module AzureRM -ErrorAction Stop
	$size = 'p15'
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $failEmailList;
		BodyAsHtml = $true;
		Subject = "BITC: Scaling Database to $size";
		Body = "$(Create-TimeStamp -forFileName)"
	}
	Send-MailMessage @params
	$params = @{
		ResourceGroupName = 'CRM-TEST-RG';
		ServerName = 'mstestsqldw';
		DatabaseName = '7ELE';
		Edition = 'Premium';
		RequestedServiceObjectiveName = $size;
	}
	Set-AzureRmSqlDatabase @params
	Start-Sleep -Seconds 420



	$sqlTruncateParams = @{
		query = "EXECUTE [dbo].[usp_Delete_Old_Data]";
		ServerInstance = $sqlServer;
		Database = $database;
		Username = $sqlUser;
		Password = $sqlPass;
		QueryTimeout = 0;
		ErrorAction = 'Stop';
	}
	Invoke-Sqlcmd @sqlTruncateParams
}
Catch {

}

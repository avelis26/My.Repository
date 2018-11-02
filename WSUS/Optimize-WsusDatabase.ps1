# -------------------------------------------
# Script: wsus-maintenance.ps1
# Version: 1.1
# Author: Mike Galvin twitter.com/digressive
# Date: 24/04/2017
# -------------------------------------------
 
##Set Variables
$wsussrvr = "MS-SSW-CRM-WSUS"
$wsusport = "8530"
 
##Set Log Location
$log = "C:\scripts\wsus-maintenance.log"

##Start Log
Start-Transcript $log
 
Get-WsusServer -Name $wsussrvr -PortNumber $wsusport
Get-WsusServer | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
 
##Stop Log
Stop-Transcript
$body = Get-Content -Path $log | Out-String

##Send Mail
$params = @{
	SmtpServer = '10.128.1.125';
	Port = '25';
	UseSsl = 0;
	From = 'no-reply@7-11.com';
	To = 'graham.pinkston@ansira.com';
	BodyAsHtml = $true;
	Subject = 'WSUS Maintenance';
	Body = $body
}
Send-MailMessage @params

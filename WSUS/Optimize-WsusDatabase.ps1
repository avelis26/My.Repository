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
 
##Set Mail Config
$toaddress = "graham.pinkston@ansira.com"
$fromaddress = $wsussrvr + "@ansira.com"
$subject = "WSUS Maintenance"
$mailserver = '10.128.1.125'

##Start Log
Start-Transcript $log
 
Get-WsusServer -Name $wsussrvr -PortNumber $wsusport
Get-WsusServer | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
 
##Stop Log
Stop-Transcript
 
##Send Mail
$body = Get-Content -Path $log | Out-String
Send-MailMessage -To $toaddress -From $fromaddress -Subject $subject -Body $body -SmtpServer $mailserver
 
##END
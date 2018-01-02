$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$toAddr = 'graham.pinkston@ansira.com','john.turner@ansira.com'
$params = @{
    SmtpServer = $smtpServer;
    Port = $port;
    UseSsl = 0;
    From = $fromAddr;
    To = $toAddr;
    Subject = 'Testing Send-MailMessage';
    Body = 'This is a test of the emergency broadcasting system.'
}
Send-MailMessage @params
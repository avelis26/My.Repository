$user = '********'
$password = '********'
$smtpServer = 'smtp.sendgrid.net'
$port = 25
$fromAddr = 'user01@domain.com'
$toAddr = 'user01@domain.com','user02@domain.com'
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $password -AsPlainText -Force)
$params = @{
    SmtpServer = $smtpServer;
    Port = $port;
    UseSsl = 0;
    From = $fromAddr;
    To = $toAddr;
    Subject = 'Testing Send-MailMessage';
    Body = 'This is a test of the emergency broadcasting system.';
    Credential = $credential
}
Send-MailMessage @params
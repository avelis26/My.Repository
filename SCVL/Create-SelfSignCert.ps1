# https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-configure-ldaps
$subject = '*.ansirascvl.com'
$years = 3
$secret = 'C:\tmp\secret.txt'
$certPath = 'cert:\localmachine\my\'
$filePath = 'c:\tmp\ansira_scvl_ldap.pfx'
$params = @{
	CertStoreLocation = $certPath;
	Subject = $subject;
	NotAfter = $($(Get-Date).AddYears($years));
}
$certificate = New-SelfSignedCertificate @params
$password = ConvertTo-SecureString -String $(Get-Content -Path $secret) -Force -AsPlainText
$path = $certPath + $certificate.thumbprint
Export-PfxCertificate -cert $path -FilePath $filePath -Password $password

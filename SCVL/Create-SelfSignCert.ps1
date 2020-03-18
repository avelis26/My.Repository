# https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-configure-ldaps
# https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-certificates-point-to-site
# v1.0 - Graham Pinkston
# Secret file should contain password to be used for encrypting keys
# Be sure to populate the paths for where you want the files to save
# The CER file is for grabbing the pub key for populating the Azure portal
# Default expiration date applied is today + 3 years
# 
# 
# # Variables
$years = 3
$password = ConvertTo-SecureString -String $(Get-Content -Path 'C:\Users\Avelis\OneDrive - Ansira.com\Secrets\tmp\secret.txt') -Force -AsPlainText
$certPath = 'Cert:\CurrentUser\My\'
$ldapPath = 'C:\Users\Avelis\OneDrive - Ansira.com\Secrets\tmp\Ansira_LDAP_Azure_Root.pfx'
$cerPath = 'C:\Users\Avelis\OneDrive - Ansira.com\Secrets\tmp\Ansira_P2S_Azure_Root.cer'
$rootPath = 'C:\Users\Avelis\OneDrive - Ansira.com\Secrets\tmp\Ansira_P2S_Azure_Root.pfx'
$childPath = 'C:\Users\Avelis\OneDrive - Ansira.com\Secrets\tmp\Ansira_P2S_Azure_Child.pfx'

# LDAP Root Cert
$params = @{
	CertStoreLocation = $certPath;
	Subject = '*.ansirascvl.com';
	NotAfter = $($(Get-Date).AddYears($years));
}
$certificate = New-SelfSignedCertificate @params
Export-PfxCertificate -cert $($certPath + $certificate.thumbprint) -FilePath $ldapPath -Password $password

# VPN Root Cert
$params = @{
	Type = 'Custom';
	KeySpec = 'Signature';
	Subject = 'CN=Ansira_P2S_Azure_Root';
	KeyExportPolicy = 'Exportable';
	HashAlgorithm = 'sha256';
	KeyLength = 2048;
	CertStoreLocation = $certPath;
	KeyUsageProperty = 'Sign';
	KeyUsage = 'CertSign';
	NotAfter = $($(Get-Date).AddYears($years));
}
$certificate = New-SelfSignedCertificate @params
Export-PfxCertificate -cert $($certPath + $certificate.thumbprint) -FilePath $rootPath -Password $password
$content = @(
	'-----BEGIN CERTIFICATE-----'
	[System.Convert]::ToBase64String($certificate.RawData, 'InsertLineBreaks')
	'-----END CERTIFICATE-----'
)
$content | Out-File -FilePath $cerPath -Encoding ascii

# VPN Child Cert
$params = @{
	Type =  'Custom';
	DnsName = 'Ansira_P2S_Azure_Child';
	KeySpec = 'Signature';
	Subject = 'CN=Ansira_P2S_Azure_Child';
	KeyExportPolicy = 'Exportable';
	HashAlgorithm = 'sha256';
	KeyLength = 2048;
	CertStoreLocation = $certPath;
	Signer = $certificate;
	TextExtension = @('2.5.29.37={text}1.3.6.1.5.5.7.3.2');
	NotAfter = $($(Get-Date).AddYears($years));
}
New-SelfSignedCertificate @params
Export-PfxCertificate -cert $($certPath + $certificate.thumbprint) -FilePath $childPath -Password $password
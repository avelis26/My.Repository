# https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-configure-ldaps
Function New-SelfSignedCertForLdap {
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
}
Function New-SelfSignedRootCertForVpn {
	$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
	-Subject "CN=P2SRootCert_Ansira" -KeyExportPolicy Exportable `
	-HashAlgorithm sha256 -KeyLength 2048 `
	-CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign
}
Function New-SelfSignedChildCertForVpn {
	New-SelfSignedCertificate -Type Custom -DnsName P2SChildCert_Ansira -KeySpec Signature `
	-Subject "CN=P2SChildCert_Ansira" -KeyExportPolicy Exportable `
	-HashAlgorithm sha256 -KeyLength 2048 `
	-CertStoreLocation "Cert:\CurrentUser\My" `
	-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
}
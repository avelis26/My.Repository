# https://medium.com/the-new-control-plane/generating-self-signed-certificates-on-windows-7812a600c2d8
$cert = New-SelfSignedCertificate -CertStoreLocation 'cert:\localmachine\my' -DnsName 'ansirascvl.com' -Subject 'ansirascvl.com' -NotAfter $($(Get-Date).AddYears(3))
$pwd = ConvertTo-SecureString -String 'ansira' -Force -AsPlainText
$path = 'cert:\localMachine\my\' + $cert.thumbprint
Export-PfxCertificate -cert $path -FilePath 'c:\temp\ansirascvl.pfx' -Password $pwd

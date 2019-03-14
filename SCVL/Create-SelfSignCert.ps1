$cert = New-SelfSignedCertificate -CertStoreLocation 'cert:\localmachine\my' -DnsName 'ansirascvl.com' -Subject 'ansirascvl.com' -NotAfter $($(Get-Date).AddYears(3))
$pwd = ConvertTo-SecureString -String 'Pkh5N.>EnHF{!75f' -Force -AsPlainText
$path = 'cert:\localMachine\my\' + $cert.thumbprint
Export-PfxCertificate -cert $path -FilePath 'c:\temp\ansirascvl.pfx' -Password $pwd

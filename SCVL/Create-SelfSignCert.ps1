# https://medium.com/the-new-control-plane/generating-self-signed-certificates-on-windows-7812a600c2d8

$cert = New-SelfSignedCertificate -certstorelocation 'cert:\localmachine\my' -dnsname 'CN=ansirascvl.com' -notafter $($(Get-Date).AddYears(3))
$pwd = ConvertTo-SecureString -String 'Pkh5N.>EnHF{!75f' -Force -AsPlainText
$path = 'cert:\localMachine\my\' + $cert.thumbprint
Export-PfxCertificate -cert $path -FilePath 'c:\temp\ansirascvl.pfx' -Password $pwd

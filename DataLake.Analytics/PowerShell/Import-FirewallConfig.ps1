# v0.9.0
# info https://cwiki.apache.org/confluence/download/attachments/30753712/XML_API_Training.pdf?version=1&modificationDate=1366305635000
########################################################################################################################################
. $($PSScriptRoot + '\Set-SslCertPolicy.ps1')
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
Set-SslCertPolicy
$key1 = Get-Content -Path 'C:\Scripts\Secrets\firewall_1_key.txt'
$key2 = Get-Content -Path 'C:\Scripts\Secrets\firewall_2_key.txt'
$exportUrl = "https://172.22.162.133/api/?type=export&category=configuration&key=$key1"
[xml]$config = Invoke-WebRequest -Uri $exportUrl
$importUrl = "https://172.22.162.132/api/?type=import&category=configuration&key=$key2"
Invoke-WebRequest -Uri $importUrl -Body $config -Method 'Post' -ContentType 'application/xml'

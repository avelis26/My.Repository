Clear-Host
$outFile = 'C:\tmp\domain.txt'
Set-Content -Path $outFile -Value $(Get-Date -Format 'yyyy/MM/dd_HH:mm:ss')
$domains = `
'windowsupdate.microsoft.com', `
'update.microsoft.com', `
'windowsupdate.com', `
'download.windowsupdate.com', `
'download.microsoft.com', `
'test.stats.update.microsoft.com', `
'ntservicepack.microsoft.com', `
'ods.opinsights.azure.com', `
'oms.opinsights.azure.com', `
'blob.core.windows.net', `
'azure-automation.net'
ForEach ($domain in $domains) {
    $ip = Resolve-DnsName -Name $domain -DnsOnly -TcpOnly -Type A
    #Add-Content -Path $outFile -Value $ip[2].IPAddress
}

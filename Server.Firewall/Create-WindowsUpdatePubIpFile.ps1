$outFile = 'C:\inetpub\wwwroot\MWUS.txt'
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
[string[]]$ipList = $null
ForEach ($domain in $domains) {
	$responses = Resolve-DnsName -Name $domain
	ForEach ($response in $responses) {
		If ($response.Type -eq 'A') {
			$ipList += $($response.Address)
		}
		ElseIf ($response.Type -eq 'CNAME') {
			$ipList += $(Resolve-DnsName -Name $response.NameHost).IP4Address
		}
		ElseIf ($response.Type -eq 'SOA') {
			$results = Resolve-DnsName -Name $response.PrimaryServer
			ForEach ($result in $results) {
				If ($result.Type -eq 'A') {
					$ipList += $result.IPAddress
				}
			}
			$results = Resolve-DnsName -Name $response.NameAdministrator
			ForEach ($result in $results) {
				If ($result.Type -eq 'A') {
					$ipList += $result.IPAddress
				}
			}
		}
		Else {
			Write-Host -ForegroundColor Yellow "UNKNOWN RECORD TYPE: $($response.Type)"
		}
	}
}
$content = Get-Content -Path $outFile -ErrorAction SilentlyContinue
If ($content.Count -gt 5000) {
	Set-Content -Path $outFile -Value ''
}
$content = Get-Content -Path $outFile -ErrorAction SilentlyContinue
$content = $content + $ipList
Add-Content -Path $outFile -Value $($content | Sort-Object | Get-Unique)

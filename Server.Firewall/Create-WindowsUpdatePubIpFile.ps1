Clear-Host
$outFile = 'C:\inetpub\wwwroot\MWUS.txt'
$dnss = '1.1.1.1', '208.67.222.222', '195.46.39.39', '8.8.8.8'
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
ForEach ($dns in $dnss) {
	[string[]]$ipList = $null
	ForEach ($domain in $domains) {
		$responses = Resolve-DnsName -Name $domain -Server $dns
		ForEach ($response in $responses) {
			If ($response.Type -eq 'A') {
				$ipList += $($response.Address)
			}
			ElseIf ($response.Type -eq 'CNAME') {
				$ipList += $(Resolve-DnsName -Name $response.NameHost -Server $dns).IP4Address
			}
			ElseIf ($response.Type -eq 'SOA') {
				$results = Resolve-DnsName -Name $response.PrimaryServer -Server $dns
				ForEach ($result in $results) {
					If ($result.Type -eq 'A') {
						$ipList += $result.IPAddress
					}
				}
				$results = Resolve-DnsName -Name $response.NameAdministrator -Server $dns
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
	$output = $ipList + $content
	$final = $output | Sort-Object | Get-Unique
	Set-Content -Path $outFile -Value $final
}
Write-Output 'Done'

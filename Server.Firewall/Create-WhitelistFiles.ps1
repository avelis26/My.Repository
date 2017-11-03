Function Create-FirewallWhiteList {
	[cmdletbinding()]
	Param()
	$VerbosePreference = 'Continue'
	# List of domains to check and get currecnt IP's from.
	$domainList = @(
		'data.mixpanel.com',
		'api.waterfall.com'
	)
	Write-Verbose -Message "Domains to be tested: $domainList"
	$oldArray = @()
	$newArray = @()
	$mixWhiteIPs = @()
	$waterWhiteIPs = @()
	# Set timespan to how hold of an IP you want to keep white listed.
	$timespan = New-TimeSpan -hours 24
	Write-Verbose -Message "Timespan set to: $timespan"
	$historyPath = 'C:\inetpub\wwwroot\ip_history\'
	$file = $historyPath + 'ip_history.csv'
	$mixPanelFile = 'C:\inetpub\wwwroot\mixpanel.txt'
	$waterfallFile = 'C:\inetpub\wwwroot\waterfall.txt'
	$ipHistoryObj = Import-Csv -LiteralPath $file
	Write-Verbose -Message "Ip History: $ipHistoryObj"
	# Get the current IP address for each domain in the list and add it to @newArray.
	ForEach ($domain in $domainList) {
		$ipList = [System.Net.Dns]::GetHostAddresses($domain)
		ForEach ($ip in $ipList) {
			$date = Get-Date -Format 'yyyyMMddHHmm'
			$obj = New-Object -TypeName PsObject -Property @{
				Domain = $domain;
				Ip = $ip.IPAddressToString;
				DateStamp = $date;
			}
			Write-Verbose -Message "Ip $($obj.Ip) found for domain $($obj.Domain)"
			$newArray += $obj
		}
	}
	# Check the history file and add any IP's younger than timespan to @newArray and any IP's older than timespan, add to @oldArray.
	ForEach ($line in $ipHistoryObj) {
		$dateStamp = [DateTime]::ParseExact($line.DateStamp,'yyyyMMddHHmm', $null)
		$obj = New-Object -TypeName PsObject -Property @{
			DateStamp = $line.DateStamp;
			Domain = $line.Domain;
			Ip = $line.Ip;
		}
		if (((get-date) - $dateStamp) -gt $timespan) {
			$oldArray += $obj
			Write-Verbose -Message "Adding $($obj.Ip) to old history."
		}
		Else {
			$newArray += $obj
			Write-Verbose -Message "Adding $($obj.Ip) to new history."
		}
	}
	# Extract only unique IP's from @newArray and output to file. Output old IP's to file.
	$uniqueNewArray = $newArray | Group-Object 'Ip' | ForEach-Object {$_.Group | Select-Object -First 1}
	Write-Verbose -Message "Creating old CSV..."
	$oldArray | Export-Csv -LiteralPath ($historyPath + 'old_ip_history.csv') -Force -NoTypeInformation -Append
	Write-Verbose -Message "Creating unique new CSV..."
	$uniqueNewArray | Export-Csv -LiteralPath ($historyPath + 'ip_history.csv') -Force -NoTypeInformation
	ForEach ($obj in $uniqueNewArray) {
		If ($obj.Domain -like "*mix*") {
			$mixWhiteIPs += $obj.Ip
		}
		ElseIf ($obj.Domain -like "*water*") {
			$waterWhiteIPs += $obj.Ip
		}
	}
	Write-Verbose -Message "Adding new IP's to whitelist file..."
	Set-Content -Path $mixPanelFile -Value $mixWhiteIPs -Force
	Set-Content -Path $waterfallFile -Value $waterWhiteIPs -Force
}
Create-FirewallWhiteList -Verbose *> $($historyPath + 'output.log')
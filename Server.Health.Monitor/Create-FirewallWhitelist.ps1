# List of domains to check and get currecnt IP's from.
$domainList = @(
	'data.mixpanel.com',
	'api.waterfall.com'
)
$oldArray = @()
$newArray = @()
# Set timespan to how hold of an IP you want to keep white listed.
$timespan = New-TimeSpan -hours 24
$historyPath = 'C:\inetpub\wwwroot\ip_history\'
$file = $historyPath + 'ip_history.csv'
$ipHistoryObj = Import-Csv -LiteralPath $file
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
	}
	Else {
		$newArray += $obj
	}
}
# Extract only unique IP's from @newArray and output to file. Output old IP's to file.
$uniqueNewArray = $newArray | Group-Object 'Ip' | ForEach-Object {$_.Group | Select-Object -First 1}
$oldArray | Export-Csv -LiteralPath ($historyPath + 'old_ip_history.csv') -Force -NoTypeInformation -Append
$uniqueNewArray | Export-Csv -LiteralPath ($historyPath + 'ip_history.csv') -Force -NoTypeInformation

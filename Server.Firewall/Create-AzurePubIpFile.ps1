<#  
.SYNOPSIS  
	- Invoke-WebRequest https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653
	- looks for 'Click Here' (manual download link)
	- loads download into xml variable 
	- displays region and assoicated subnets
.Version
	1.0
.DESCRIPTION  
	Gathers latest public Azure service IP's and outputs one IP per line to be used in a file for firewall whitelisting.
.NOTES  
	File Name	: Get-AzureIPRanges.ps1
	Author		: graham.pinkston@ansira.com
	Date		: 10/30/2017
#>
$newArray = @()
$path = 'C:\tmp\'
$AzureIPRangesPage = Invoke-WebRequest -Uri https://www.microsoft.com/en-us/download/confirmation.aspx?id=41653 -Method Get -UseBasicParsing
[XML]$AzureIPRanges = Invoke-RestMethod -uri ($AzureIPRangesPage.Links | Where-Object -FilterScript {$_.outerhtml -like "*Click here*"}).href[0]
Foreach ($region in $Azureipranges.AzurePublicIpAddresses.region) {
	Foreach ($ipsubnet in $region.iprange.subnet) {
		$newArray += $ipsubnet
	}
}
If (!(Test-Path -Path $path)) {New-Item -ItemType Directory -Path $path}
Set-Content -Path $($path + 'azuredcip.txt') -Value $newArray
429

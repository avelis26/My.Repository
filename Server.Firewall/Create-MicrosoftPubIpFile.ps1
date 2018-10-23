<#  
.SYNOPSIS  
	- Invoke-WebRequest https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602
	- looks for 'Click Here' (manual download link)
	- loads download into variable 
	- Convert from CSV and use prefix column to create file
.Version
	1.0
.DESCRIPTION  
	Gathers latest public Microsoft public IP's and outputs one IP per line to be used in a file for firewall whitelisting.
.NOTES  
	File Name	: Create-MicrosoftPubIpFile.ps1
	Author		: graham.pinkston@ansira.com
	Date		: 10/23/2018
#>
$path = 'C:\tmp\'
$fileName = 'microsoft_ip_space.txt'
$response = Invoke-WebRequest -Uri https://www.microsoft.com/en-us/download/confirmation.aspx?id=53602 -Method Get -UseBasicParsing
$response = Invoke-RestMethod -uri ($response.Links | Where-Object -FilterScript {$_.outerhtml -like "*Click here*"}).href[0]
$csv = ConvertFrom-Csv -InputObject $response -Delimiter ','
New-Item -Path $path -Name $fileName -ItemType 'file' -Force
ForEach ($line in $csv) {
	Write-Output $line.Prefix.ToString()
	Add-Content -Path $($path + $fileName) -Value $line.Prefix.ToString()
}

$url = "https://files.nicehash.com/nhminer/quickminer/NicehashQuickMinerv514.exe"
$filepath = "C:\Users\avelis\Downloads\NicehashQuickMinerv514.exe"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($url,$filepath)
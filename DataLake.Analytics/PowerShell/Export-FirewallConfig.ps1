$user = 'gpink003'
$password = 'C:\Scripts\Secrets\firewall.txt'
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $password -AsPlainText -Force)
$url = 'https://172.22.162.133/api/?type=export&category=configuration&REST_API_TOKEN=1954450954'
Invoke-RestMethod -Uri $url -Method 'Post' -Credential $credential
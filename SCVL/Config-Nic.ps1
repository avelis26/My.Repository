$ErrorActionPreference = "Stop"
Import-Module AzureRM -ErrorAction Stop
$userName = 'graham.pinkston'
$user = $userName + '@ansira.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass)
Write-Host "Logging in...";
Connect-AzureRmAccount -Subscription $subscriptionId -Credential $credential;
Write-Host "Selecting subscription '$subscriptionId'";
Select-AzureRmSubscription -SubscriptionID $subscriptionId;
$publicIpName = "scvl-test-sftp-01-ip"
$rgName = "TEST-Compute-rsg"
$dnsPrefix = "scvl-test-sftp-01"
$location = "centralus"
$nicName = "scvl-test-sftp-01324"
$Nic = Get-AzureRmNetworkInterface -ResourceGroupName $rgName -Name $nicName
Remove-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $rgName
Start-Sleep -Seconds 8
$publicIp = New-AzureRmPublicIpAddress -Name $publicIpName -ResourceGroupName $rgName -AllocationMethod Static -DomainNameLabel $dnsPrefix -Location $location
Start-Sleep -Seconds 8
$Nic.IpConfigurations[0].PublicIpAddress = $publicIp
Set-AzureRmNetworkInterface -NetworkInterface $Nic

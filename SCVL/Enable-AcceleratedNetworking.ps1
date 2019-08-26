[CmdletBinding()]
param(
	[Parameter(Mandatory=$False)] [string]$subscriptionId = 'f6915c04-23d0-4ac4-8cd7-b69ac91c2ab8',
	[Parameter(Mandatory=$False)] [string]$resourceGroupName = 'PROD-Networking-rsg',
    [Parameter(Mandatory=$False)] [string]$userName = 'graham.pinkston',
    [Parameter(Mandatory=$False)] [string]$userDomain = '@ansira.com',
    [Parameter(Mandatory=$False)] [string]$vmName = 'ScvlProdSftp01'
)
$ErrorActionPreference = 'Stop'
Import-Module Az
$user = $userName + $userDomain
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass)
Connect-AzAccount -Credential $credential -Subscription $subscriptionId
$nic = Get-AzNetworkInterface | Where-Object -FilterScript {$_.VirtualMachine.Id -like "*$vmName*"}
$nic.EnableAcceleratedNetworking = $true
Set-AzNetworkInterface -NetworkInterface $nic

[CmdletBinding()]
param(
	[Parameter(Mandatory=$False)] [string]$subscriptionId = 'f6915c04-23d0-4ac4-8cd7-b69ac91c2ab8',
	[Parameter(Mandatory=$False)] [string]$resourceGroupName = 'PROD-Networking-rsg',
	[Parameter(Mandatory=$False)] [string]$resourceGroupLocation = 'centralus',
	[Parameter(Mandatory=$False)] [string]$vnetName = 'SCVL-vnet',
	[Parameter(Mandatory=$False)] [string]$subnetName = 'gate',
	[Parameter(Mandatory=$False)] [string]$pipName = 'scvlAdobeWebAg-ip',
	[Parameter(Mandatory=$False)] [string]$deploymentName = 'test03'
)
$ErrorActionPreference = 'Stop'
Import-Module Az
Enable-AzureRMAlias
$userName = 'graham.pinkston'
$user = $userName + '@ansira.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass)
Connect-AzureRmAccount -Subscription $subscriptionId -Credential $credential;
Select-AzureRmSubscription -SubscriptionID $subscriptionId;
$params = @{
	ResourceGroupName = $resourceGroupName;
	Location = $resourceGroupLocation;
	Name = $pipName;
	AllocationMethod = 'Dynamic';
}
New-AzPublicIpAddress @params
$vnet = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $vnetName
$subnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName
$pip = Get-AzPublicIPAddress -ResourceGroupName $resourceGroupName -Name $pipName 
$gipconfig = New-AzApplicationGatewayIPConfiguration -Name 'myAGIPConfig' -Subnet $subnet
$fipconfig = New-AzApplicationGatewayFrontendIPConfig -Name 'myAGFrontendIPConfig' -PublicIPAddress $pip
$frontendport = New-AzApplicationGatewayFrontendPort -Name 'myFrontendPort' -Port 80
$address1 = Get-AzNetworkInterface -ResourceGroupName 'PROD-Compute-rsg' -Name 'scvlprodacweb01397'
$backendPool = New-AzApplicationGatewayBackendAddressPool -Name 'myAGBackendPool' -BackendIPAddresses $address1.ipconfigurations[0].privateipaddress
$params = @{
	Name =  'myPoolSettings';
	Port =  80;
	Protocol =  'Http';
	CookieBasedAffinity = 'Enabled';
	RequestTimeout =  120;
}
$poolSettings = New-AzApplicationGatewayBackendHttpSettings @params
$params = @{
	Name =  'myAGListener';
	Protocol =  'Http';
	FrontendIPConfiguration =  $fipconfig;
	FrontendPort =  $frontendport;
}
$defaultlistener = New-AzApplicationGatewayHttpListener @params
$params = @{
	Name = 'rule1';
	RuleType = 'Basic';
	HttpListener = $defaultlistener;
	BackendAddressPool = $backendPool;
	BackendHttpSettings = $poolSettings;
}
$frontendRule = New-AzApplicationGatewayRequestRoutingRule @params
$params = @{
	Name = 'Standard_Medium';
	Tier = 'Standard';
	Capacity = 2;
}
$sku = New-AzApplicationGatewaySku @params
$params = @{
	Name = 'Scvl-Adobe-Web-Ag';
	ResourceGroupName = $resourceGroupName;
	Location = $resourceGroupLocation;
	BackendAddressPools = $backendPool;
	BackendHttpSettingsCollection = $poolSettings;
	FrontendIpConfigurations = $fipconfig;
	GatewayIpConfigurations = $gipconfig;
	FrontendPorts = $frontendport;
	HttpListeners = $defaultlistener;
	RequestRoutingRules = $frontendRule;
	Sku = $sku;
}
New-AzApplicationGateway @params
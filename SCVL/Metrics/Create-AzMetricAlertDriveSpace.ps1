<#
https://docs.microsoft.com/en-us/azure/azure-monitor/platform/alerts-metric-create-templates
#>
Import-Module -Name 'Az' -ErrorAction Stop
$userName = 'graham.pinkston'
$user = $userName + '@ansira.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$subId = 'f6915c04-23d0-4ac4-8cd7-b69ac91c2ab8'
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
$params = @{
	Credential = $credential;
	Subscription = $subId;
	Force = $true;
	ErrorAction = 'Stop';
}
Connect-AzAccount @params
#Select-AzSubscription -SubscriptionName 'Shoe Carnival'
$params = @{
	Name = 'AlertDeployment';
	ResourceGroupName = 'PROD-Monitoring-rg';
	TemplateFile = 'Drive_Space.json'
	TemplateParameterFile = 'Drive_Splace.parameters.json';
}
New-AzResourceGroupDeployment @params
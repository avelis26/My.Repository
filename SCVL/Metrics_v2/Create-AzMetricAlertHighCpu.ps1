<#
https://docs.microsoft.com/en-us/powershell/module/Az.Monitor/Add-AzMetricAlertRuleV2?view=azps-1.8.0
#>
Import-Module -Name 'Az' -ErrorAction Stop
$actionGroupName = 'AnsiraDevOps'
$actionGroupResourceGroupName = 'PROD-Monitoring-rg'
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
	Verbose = $true;
}
Connect-AzAccount @params
$vmList = Get-AzVM -Status
$params = @{
	MetricName = 'Percentage CPU';
	MetricNameSpace = 'Microsoft.Compute/virtualMachines';
	TimeAggregation = 'Average';
	Operator = 'GreaterThan';
	Threshold = 85;
}
$condition = New-AzMetricAlertRuleV2Criteria @params
ForEach ($vm in $vmList) {
	If ($vm.StorageProfile.osDisk.osType -eq 'Windows') {
		Write-Output '-------------------'
		Write-Output $vm.Name
		Write-Output '-------------------'
		$params = @{
			ActionGroup = $(New-AzActionGroup -ActionGroupId $(Get-AzActionGroup -Name $actionGroupName -ResourceGroupName $actionGroupResourceGroupName).Id);
			Condition = $condition;
			Description = 'This alert fires if the CPU is above 85% for more than 10 minuets.';
			Frequency = New-TimeSpan -Minutes 15;
			Name = 'High CPU - ' + $vm.Name;
			ResourceGroupName = $actionGroupResourceGroupName;
			Severity = 3;
			TargetResourceId = $vm.Id;
			WindowSize = New-TimeSpan -Minutes 15;
		}
		Add-AzMetricAlertRuleV2 @params
		#Get-AzMetricAlertRule -Name $params.Name -ResourceGroup $vm.ResourceGroupName
		#Remove-AzMetricAlertRule -ResourceGroup $vm.ResourceGroupName -Name $params.Name
	}
}

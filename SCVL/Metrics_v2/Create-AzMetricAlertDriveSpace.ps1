<#
https://docs.microsoft.com/en-us/powershell/module/az.monitor/add-azmetricalertrule?view=azps-1.8.0
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
	Verbose = $true;
}
Connect-AzAccount @params
$vmList = Get-AzVM -Status
ForEach ($vm in $vmList) {
	If ($vm.StorageProfile.osDisk.osType -eq 'Windows') {
		Write-Output '-------------------'
		Write-Output $vm.Name
		Write-Output '-------------------'
		$actionEmail = New-AzAlertRuleEmail -CustomEmail 'graham.pinkston@ansira.com'
		$params = @{
			Name = 'High CPU - ' + $vm.Name;
			Location = $vm.Location;
			ResourceGroup = $vm.ResourceGroupName;
			TargetResourceId = $vm.Id;
			MetricName = 'Percentage CPU';
			Operator = 'GreaterThan';
			Threshold = 90;
			WindowSize = New-TimeSpan -Minutes 10;
			TimeAggregationOperator = 'Average';
			Description = 'Alert when CPU utilization is over 90% for 10 minutes';
			ActionGroup = $actionEmail;
			Verbose = $true;
		}
		Add-AzMetricAlertRuleV2 @params
		#Get-AzMetricAlertRule -Name $params.Name -ResourceGroup $vm.ResourceGroupName
		#Remove-AzMetricAlertRule -ResourceGroup $vm.ResourceGroupName -Name $params.Name
	}
}
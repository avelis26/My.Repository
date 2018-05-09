Import-Module AzureRM
$password = Get-Content "C:\Scripts\Secrets\gpink003.cred" | ConvertTo-SecureString
$user = "gpink003@7-11.com"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Try {
	Login-AzureRmAccount -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec' -ErrorAction Stop #-Credential $credential
}
Catch {
	throw $_
}
$vmList = Get-AzureRmVM -Status
ForEach ($vm in $vmList) {
	If ($vm.StorageProfile.osDisk.osType -eq 'Windows' -and $vm.PowerState -eq 'running') {
		Write-Output '-------------------'
		Write-Output $vm.Name
		Write-Output '-------------------'
		$actionEmail = New-AzureRmAlertRuleEmail -CustomEmail 'digitalops@ansira.com'
		$alertNameSuffix = $([regex]::match($vm.Name, '([^-]+)$')).Value
		$params = @{
			Name = 'High CPU - ' + $alertNameSuffix;
			Location = $vm.Location;
			ResourceGroup = $vm.ResourceGroupName;
			TargetResourceId = $vm.Id;
			MetricName = '\Processor Information(_Total)\% Processor Time';
			Operator = 'GreaterThan';
			Threshold = 95;
			WindowSize = New-TimeSpan -Minutes 30;
			TimeAggregationOperator = 'Average';
			Description = 'Alert when CPU utilization is over 90% for 5 minutes';
			Actions = $actionEmail
		}
		#Add-AzureRmMetricAlertRule @params
		#Get-AzureRmAlertRule -Name $params.Name -ResourceGroup $vm.ResourceGroupName
		Remove-AzureRmAlertRule -ResourceGroup $vm.ResourceGroupName -Name $params.Name
	}
}
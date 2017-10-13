Import-Module AzureRM
$password = Get-Content "C:\Users\graham.pinkston\Documents\Secrets\op1.txt" | ConvertTo-SecureString
$user = "gpink003@7-11.com"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Login-AzureRmAccount -Credential $credential
Set-AzureRmContext -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$vmList = Get-AzureRmVM -Status
ForEach ($vm in $vmList) {
	If ($vm.StorageProfile.osDisk.osType -eq 'Windows' -and $vm.PowerState -eq 'running') {
		Write-Output '-------------------'
		Write-Output $vm.Name
		Write-Output '-------------------'
		$actionEmail = New-AzureRmAlertRuleEmail -CustomEmail 'digitalops@ansira.com'
		$alertNameSuffix = $([regex]::match($vm.Name, '([^-]+)$')).Value
		$params = @{
			Name = 'High RAM Page Faults - ' + $alertNameSuffix;
			Location = $vm.Location;
			ResourceGroup = $vm.ResourceGroupName;
			TargetResourceId = $vm.Id;
			MetricName = '\Memory\Page Faults/sec';
			Operator = 'GreaterThan';
			Threshold = 9000;
			WindowSize = New-TimeSpan -Minutes 10;
			TimeAggregationOperator = 'Average';
			Description = 'Alert when memory page faults exceed 4096/sec for 5 minutes';
			Actions = $actionEmail
		}
		#Add-AzureRmMetricAlertRule @params
		#Get-AzureRmAlertRule -Name $params.Name -ResourceGroup $vm.ResourceGroupName
		Remove-AzureRmAlertRule -ResourceGroup $vm.ResourceGroupName -Name $params.Name
	}
}
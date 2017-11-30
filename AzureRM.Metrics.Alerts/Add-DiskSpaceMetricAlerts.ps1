Import-Module AzureRM
$password = Get-Content "C:\Users\graham.pinkston\Documents\Secrets\op1.txt" | ConvertTo-SecureString
$user = "gpink003@7-11.com"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
Try {
	Login-AzureRmAccount -Credential $credential -ErrorAction Stop
}
Catch {
	throw $_
}
Try {
	Set-AzureRmContext -Subscription 'da908b26-f6f8-4d61-bf60-b774ff3087ec' -ErrorAction Stop
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
			Name = 'Low Disk Space - ' + $alertNameSuffix;
			Location = $vm.Location;
			ResourceGroup = $vm.ResourceGroupName;
			TargetResourceId = $vm.Id;
			MetricName = '\LogicalDisk(_Total)\% Free Space';
			Operator = 'LessThan';
			Threshold = 15;
			WindowSize = New-TimeSpan -Minutes 5;
			TimeAggregationOperator = 'Average';
			Description = 'Alert when disk space is less than 15% for 5 minutes';
			Actions = $actionEmail
		}
		Add-AzureRmMetricAlertRule @params
		#Get-AzureRmAlertRule -Name $params.Name -ResourceGroup $vm.ResourceGroupName
		#Remove-AzureRmAlertRule -ResourceGroup $vm.ResourceGroupName -Name $params.Name
	}
}
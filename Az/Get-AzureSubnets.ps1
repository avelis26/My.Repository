Get-AzSubscription | Foreach-Object {
		$sub = Set-AzContext -SubscriptionId $_.SubscriptionId
		$vnets = Get-AzVirtualNetwork
		$arr = @()
		foreach ($vnet in $vnets) {
				$arr += [PSCustomObject]@{
						Subscription = $sub.Subscription.Name
						Vnet = $vnet.Name
						Subnets = $vnet.Subnets.Name
				}
		}
}
ForEach ($obj in $arr) {
		ForEach ($subnet in $obj.Subnets) {
				Write-Output "VNET: $($obj.Vnet) ..... SUBNET: $subnet"
		}
}

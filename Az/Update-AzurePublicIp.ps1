<#
  .SYNOPSIS
  POC to decoupole a public IP object from it's Azure VPN gateway without releaseing the IP address.

  .DESCRIPTION
  https://docs.microsoft.com/en-us/powershell/module/az.network/set-azpublicipaddress?view=azps-3.6.1

  .PARAMETER subId
  $subId = 'f6915c04-23d0-4ac4-8cd7-b69ac91c2ab8'

  .INPUTS
  none

  .OUTPUTS
  __blank__

  .EXAMPLE
  __blank__
#>
[CmdletBinding()]
Param(
	[parameter(Mandatory = $true)][string]$subId = 'f6915c04-23d0-4ac4-8cd7-b69ac91c2ab8'
)
Import-Module -Name Az
Connect-AzAccount -Tenant "xxxx-xxxx-xxxx-xxxx" -SubscriptionId $subId
Get-AzPublicIpAddress -Name 'Scvl_GW1' -ResourceGroupName 'PROD-Networking-rsg'

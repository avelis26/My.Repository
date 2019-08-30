Import-Module MSOnline
Connect-MsolService
$users = @(
	'svc_AccAppRunAs@ansirascvl.onmicrosoft.com',
	'svc_scvl-dev-sql-01@ansirascvl.onmicrosoft.com',
	'svc_ScvlBiSql01@ansirascvl.onmicrosoft.com',
	'svc_ScvlProdSql01@ansirascvl.onmicrosoft.com',
	'svc_ScvlQaSql01@ansirascvl.onmicrosoft.com'
)
$results = @()
Foreach ($user in $users) {
	Set-MsolUser -UserPrincipalName $user -PasswordNeverExpires $true
	$userObj = Get-MsolUser -UserPrincipalName $user
	$object = New-Object -TypeName PsCustomObject
	Add-Member -InputObject $object -MemberType NoteProperty -Name 'DisplayName' -Value $userObj.DisplayName
	Add-Member -InputObject $object -MemberType NoteProperty -Name 'ValidationStatus' -Value $userObj.ValidationStatus
	Add-Member -InputObject $object -MemberType NoteProperty -Name 'PasswordNeverExpires' -Value $userObj.PasswordNeverExpires
	Add-Member -InputObject $object -MemberType NoteProperty -Name 'LastPasswordChangeTimestamp' -Value $userObj.LastPasswordChangeTimestamp
	$results += $object
}
Write-Output $results | Format-List

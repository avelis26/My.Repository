$array = @()
$object = New-Object -TypeName PsCustomObject
Add-Member -InputObject $object -MemberType NoteProperty -Name 'Account' -Value 'User1'
Add-Member -InputObject $object -MemberType NoteProperty -Name 'PasswordNeverExpires' -Value $true
$array += $object
$object = New-Object -TypeName PsCustomObject
Add-Member -InputObject $object -MemberType NoteProperty -Name 'Account' -Value 'User2'
Add-Member -InputObject $object -MemberType NoteProperty -Name 'PasswordNeverExpires' -Value $true
$array += $object
$array
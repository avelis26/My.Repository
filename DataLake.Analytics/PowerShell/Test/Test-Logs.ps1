$rootPath = 'C:\tmp'
$names = @()
$files = Get-ChildItem -Path $rootPath -File
ForEach ($file in $files) {
	$names += $($file.Name).Substring(0, 8)
}
Function Get-ArrayDupes {
	param($array)
	$hash = @{}
	$array | ForEach-Object {$hash[$_] = $hash[$_] + 1}
	$result = $hash.GetEnumerator() | Where-Object{$_.value -gt 1} | ForEach-Object{$_.key}
	Return $result
}
Get-ArrayDupes -array $names

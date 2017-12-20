Clear-Host
$arr = @(1..9999)
$i = 0
ForEach ($var in $arr) {
    $status = $($i/$($arr.Length)*100).ToString("##")
	Write-Progress -Activity 'Downloading files...' -Status "$status% Complete:" -PercentComplete $($i/$($arr.Length)*100)
	$i++
}

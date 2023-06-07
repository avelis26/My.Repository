Clear-Host
$number = Get-Random -Minimum 0 -Maximum 999
If ($number -lt 500) {
    Write-Output "The number is below 500"
} Else {
    Write-Output "The number is above 500"
}
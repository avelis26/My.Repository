Clear-Host
Import-Module -Name "Az" -Verbose -ErrorAction Stop
Connect-AzAccount -ErrorAction Stop
$storageAccountKey = Get-Content -Path 'C:\key'
$storageAccountName = 'vmdiagstoraccount'
$shareName = 'temp'
$params = @{
	ShareName = $shareName
	Context = $(New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey -ErrorAction Stop)
	ErrorAction = 'Stop'
}
$files = Get-AzStorageFile @params
Set-Location -Path 'F:\'
ForEach ($file in $files) {
	Get-AzStorageFileContent -CheckMd5 -File $file -Verbose
}
Import-Module AzureRM
$password = Get-Content "C:\Users\graham.pinkston\Documents\Secrets\op1.txt" | ConvertTo-SecureString
$user = "gpink003@7-11.com"
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
$seiDataLakeName = '711dlprodcons01'
$ansiraDataLakeName = 'mscrmprodadls'
$dataLakeRootPath = '/BIT_CRM/20171129/'
Try {
	Login-AzureRmAccount -ErrorAction Stop
	Set-AzureRmContext -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop
	$dataLakeFiles = Get-AzureRmDataLakeStoreChildItem -Account $seiDataLakeName -Path $dataLakeRootPath -ErrorAction Stop
	Write-Output $dataLakeFiles[0]
	Write-Output $dataLakeFiles[1]
	Write-Output $dataLakeFiles[2]
}
Catch {
	throw $_
}

# Export-AzureRmDataLakeStoreItem -AccountName $dataLakeStoreName -Path $myrootdir\mynewdirectory\vehicle1_09142014_Copy.csv -Destination "C:\sampledata\vehicle1_09142014_Copy.csv"
Import-Module AzureRM -ErrorAction Stop
$userName = 'gpink003'
$user = $userName + '@7-11.com'
$dataLakeSubId = 'ee691273-18af-4600-bc24-eb6768bf9cfa'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
Login-AzureRmAccount -Credential $credential -Subscription $dataLakeSubId -Force -ErrorAction Stop
$importParams = @{
    AccountName = '711dlprodcons01';
    Path = 'D:\20170612\';
    Destination = "/BIT_CRM/20170612/";
    Concurrency = 128;
}
Import-AzureRmDataLakeStoreItem @importParams
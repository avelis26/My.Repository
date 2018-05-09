$outFilePath = '\\MS-SSW-CRM-MGMT\Data\Tmp\'
If ($(Test-Path -Path $outFilePath) -eq $false) {
	New-Item -Path $outFilePath -ItemType Directory -Force -ErrorAction Stop
}
$userName = 'gpink003'
$dataLakeSubId = 'ee691273-18af-4600-bc24-eb6768bf9cfa'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$dataLakeSearchPathRoot = '/BIT_CRM/'
$dataLakeStoreName = '711dlprodcons01'
[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
$policy = [System.Net.ServicePointManager]::CertificatePolicy.ToString()
If ($policy -ne 'TrustAllCertsPolicy') {
	Add-Type -TypeDefinition @"
		using System.Net;
		using System.Security.Cryptography.X509Certificates;
		public class TrustAllCertsPolicy : ICertificatePolicy {
			public bool CheckValidationResult(
				ServicePoint srvPoint, X509Certificate certificate,
				WebRequest request, int certificateProblem
			) {
				return true;
			}
		}
"@
	[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}
Import-Module AzureRM -ErrorAction Stop
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
Login-AzureRmAccount -Credential $credential -Subscription $dataLakeSubId -Force -ErrorAction Stop
$startDateObj = Get-Date -Date '2017-02-09'
$endDateObj = Get-Date
$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj -ErrorAction Stop).Days + 1
$y = 0
While ($y -lt $range) {
    $day = $($startDateObj.AddDays($y)).day.ToString("00")
	$month = $($startDateObj.AddDays($y)).month.ToString("00")
	$year = $($startDateObj.AddDays($y)).year.ToString("0000")
	$processDate = $year + $month + $day
    Write-Host -ForegroundColor Cyan $processDate
    $getParams = @{
	    Account = $dataLakeStoreName;
	    Path = $($dataLakeSearchPathRoot + $processDate);
	    ErrorAction = 'SilentlyContinue';
    }
    $items = Get-AzureRmDataLakeStoreChildItem @getParams
    $itemNames = @()
    ForEach($item in $items) {
        $itemNames += $item.Name
    }
    Add-Content -Value $itemNames -Path $($outFilePath + $processDate + '.txt')
    $y++
}

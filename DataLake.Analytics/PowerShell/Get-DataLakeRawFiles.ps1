Function Get-DataLakeRawFiles {
	[CmdletBinding()]
	Param(
		#######################################################################################################
		#######################################################################################################
		##   Enter the path where you want your aggregate files to be downloaded on your local machine:
		[string]$destinationRootPath = 'D:\BIT_CRM\',
		##   Enter the range of aggregate files you want to download in mm-dd-yyyy format:
		[string]$startDate = '10-23-2017',
		[string]$endDate = '10-23-2017',
		##   Enter your 7-11 user name without domain:
		[string]$userName = 'gpink003'
		#######################################################################################################
		#######################################################################################################
	)
	Try {
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
		Write-Verbose -Message 'Importing AzureRm module...'
		Import-Module AzureRM -ErrorAction Stop
		$user = $userName + '@7-11.com'
		$dataLakeStoreName = '711dlprodcons01'
		$dataLakeRootPath = "/BIT_CRM/"
		$startDateObj = Get-Date -Date $startDate
		$endDateObj = Get-Date -Date $endDate
		[int]$range = $(New-TimeSpan -Start $startDateObj -End $endDateObj).Days + 1
		$i = 0
		$password = ConvertTo-SecureString -String $(Get-Content -Path "C:\Users\$userName\Documents\Secrets\$userName.cred")
		$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $password
		Write-Verbose -Message 'Logging into Azure...'
		Login-AzureRmAccount -Credential $credential -ErrorAction Stop
		Write-Verbose -Message 'Setting subscription...'
		Set-AzureRmContext -Subscription 'ee691273-18af-4600-bc24-eb6768bf9cfa' -ErrorAction Stop
		Write-Verbose -Message "Creating $destinationRootPath folder..."
		If (!(Test-Path -LiteralPath $destinationRootPath)) {
			Write-Verbose -Message "Creating folder:  $destinationRootPath ..."
			New-Item -ItemType Directory -Path $destinationRootPath -Force
		}
		While ($i -lt $range) {
			$scriptStartTime = Get-Date
			[string]$day = $($startDateObj.AddDays($i)).day.ToString("00")
			[string]$month = $($startDateObj.AddDays($i)).month.ToString("00")
			[string]$year = $($startDateObj.AddDays($i)).year.ToString("0000")
			$processDate = $year + $month + $day
			Write-Verbose "Downloading folder $($dataLakeFolder.Path)..."
			$exportParams = @{
				Account = $dataLakeStoreName;
				Path = $($dataLakeRootPath + $processDate);
				Destination = $($destinationRootPath + $processDate + '\');
				Force = $true;
				Concurrency = 256;
			}
			Export-AzureRmDataLakeStoreItem @exportParams
			$scriptEndTime = Get-Date
			$runTime = New-TimeSpan -Start $scriptStartTime -End $scriptEndTime
			Write-Host "Total Run Time----:  $($runTime.Hours.ToString("00")) h $($runTime.Minutes.ToString("00")) m $($runTime.Seconds.ToString("00")) s"
			$i++
		}
		Write-Output "All files downloaded successfully."
	}
	Catch {
		throw $_
	}
}
Get-DataLakeRawFiles -Verbose

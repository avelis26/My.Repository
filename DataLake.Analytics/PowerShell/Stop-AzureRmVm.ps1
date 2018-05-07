Function Stop-BITC {
	[CmdletBinding()]
	Param(
		[switch]$exit
	)
	. $($PSScriptRoot + '\Set-SslCertPolicy.ps1')
	$emailList = 'graham.pinkston@ansira.com'
	$userName = 'gpink003'
	$user = $userName + '@7-11.com'
	$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
	$vmSubId = 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
	$vmRg = 'CRM-Production-RG'
	$vmName = 'MS-SSW-CRM-BITC'
	$smtpServer = '10.128.1.125'
	$port = 25
	$fromAddr = 'noreply@7-11.com'
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
	$opsLog = 'H:\Ops_Log\bitc.log'
	Try {
		Add-Content -Value "Setting SSL policy..." -Path $opsLog
		Set-SslCertPolicy
		Add-Content -Value "Logging into Azure..." -Path $opsLog
		Connect-AzureRmAccount -Credential $credential -Subscription $vmSubId -Force -ErrorAction Stop
		Add-Content -Value "Shutting down $vmName..." -Path $opsLog
		Stop-AzureRmVM -ResourceGroupName $vmRg -Name $vmName -Force
		$params = @{
			SmtpServer = $smtpServer;
			Port = $port;
			UseSsl = 0;
			From = $fromAddr;
			To = $emailList;
			BodyAsHtml = $true;
			Subject = "AllSpark: $vmName Shut Down Successful";
			Body = "$vmName has been shut down to save money and will be started again tomorrow morning at 6am.";
		}
		Send-MailMessage @params
		$exitCode = 0
	}
	Catch {
		Add-Content -Value $($Error[0].Exception.Message) -Path $opsLog
		$errorInfo = $($Error[0].Exception.Message), `
			$($Error[0].Exception.InnerException.Message), `
			$($Error[0].Exception.InnerException.InnerException.Message), `
			$($Error[0].CategoryInfo.Activity), `
			$($Error[0].CategoryInfo.Reason), `
			$($Error[0].InvocationInfo.Line)
		ForEach ($line in $errorInfo) {
			Add-Content -Value $line -Path $opsLog
		}
		$exitCode = 1
	}
	Finnaly {
		If ($exit.IsPresent -eq $true) {	
			[Environment]::Exit($exitCode)	
		}
	}
}
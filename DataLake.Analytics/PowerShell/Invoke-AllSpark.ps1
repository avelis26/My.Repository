# Version  --  v0.8.0.0
#######################################################################################################
#
#######################################################################################################
[CmdletBinding()]
Param(
	[parameter(Mandatory = $false)][switch]$scale
)
#######################################################################################################
$databaseSubId = 'da908b26-f6f8-4d61-bf60-b774ff3087ec'
$userName = 'gpink003'
$smtpServer = '10.128.1.125'
$port = 25
$fromAddr = 'noreply@7-11.com'
$azuPass = Get-Content -Path "C:\Scripts\Secrets\$userName.cred" -ErrorAction Stop
$user = $userName + '@7-11.com'
$opsLogRootPath = 'H:\Ops_Log\ETL\AllSpark\'
$failEmailList = 'graham.pinkston@ansira.com'
#######################################################################################################
Function New-TimeStamp {
	[CmdletBinding()]
	Param(
		[switch]$forFileName
	)
	$now = Get-Date -ErrorAction Stop
	$day = $now.day.ToString("00")
	$month = $now.month.ToString("00")
	$year = $now.year.ToString("0000")
	$hour = $now.hour.ToString("00")
	$minute = $now.minute.ToString("00")
	$second = $now.second.ToString("00")
	If ($forFileName -eq $true) {
		$timeStamp = $year + $month + $day + '_' + $hour + $minute + $second
	}
	Else {
		$timeStamp = $year + '/' + $month + '/' + $day + '-' + $hour + ':' + $minute + ':' + $second
	}
	Return $timeStamp
}
Function Set-AzureSqlDatabaseSize {
	[CmdletBinding()]
	Param(
		[string]$size
	)
	Set-AzureRmContext -Subscription $databaseSubId -ErrorAction Stop > $null
	$params = @{
		ResourceGroupName = 'CRM-TEST-RG';
		ServerName = 'mstestsqldw';
		DatabaseName = '7ELE';
		Edition = 'Premium';
		RequestedServiceObjectiveName = $size;
		ErrorAction = 'Stop';
	}
	Set-AzureRmSqlDatabase @params
}

Try {
	$opsLog = $opsLogRootPath + "$(New-TimeStamp -forFileName)_AllSpark.log"
	$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $(ConvertTo-SecureString -String $azuPass -ErrorAction Stop) -ErrorAction Stop
	$message = "Logging into Azure..."
	Write-Verbose -Message $message
	Add-Content -Value "$(New-TimeStamp)  $message" -Path $opsLog -ErrorAction Stop
	Login-AzureRmAccount -Credential $credential -Force -ErrorAction Stop
	If ($scale.IsPresent -eq $true) {
		$size = 'P15'
		$message = "$(Create-TimeStamp)  Scaling database to $size..."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop	
		Set-AzureSqlDatabaseSize -size $size
		$message = "$(Create-TimeStamp)  Database scaling successful."
		Write-Output $message
		Add-Content -Value $message -Path $opsLog -ErrorAction Stop
	}
# Data to SQL - Store
	$sqlEtlResult = Invoke-Expression -Command "$script1 -startDate $startDate -opsLogFile $opsLogFile" -ErrorAction Stop
# Data to SQL - CEO

# Data to Hadoop



	$exitCode = 0
}
Catch {
	Add-Content -Value $($Error[0].CategoryInfo.Activity) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.Message) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].Exception.InnerExceptionMessage) -Path $opsLog -ErrorAction Stop
	Add-Content -Value $($Error[0].RecommendedAction) -Path $opsLog -ErrorAction Stop
	$params = @{
		SmtpServer = $smtpServer;
		Port = $port;
		UseSsl = 0;
		From = $fromAddr;
		To = $emailList;
		BodyAsHtml = $true;
		Subject = "AllSpark: Failed!!!";
		Body = @"
			<font face='consolas'>
			Something bad happened!!!<br><br>
			$($Error[0].CategoryInfo.Activity)<br>
			$($Error[0].Exception.Message)<br>
			$($Error[0].Exception.InnerExceptionMessage)<br>
			$($Error[0].RecommendedAction)<br>
			$($Error[0].Message)<br>
			</font>
"@
	}
	Send-MailMessage @params
	$exitCode = 1
}
Finally {
	Write-Output 'Finally...'
		If ($scale.IsPresent -eq $true) {
		$size = 'P1'
		Write-Output "Scaling database to size $size..."
		Add-Content -Value "$(Create-TimeStamp)  Scaling database to size $size..." -Path $opsLog -ErrorAction Stop
		Set-AzureSqlDatabaseSize -size $size
	}
}
		
		














<#
.SYNOPSIS
Calls the GoAnywhere REST API to confirm if the server process/service is alive.

.DESCRIPTION
Using Invoke-RestMethod, credentials are provided from an encrypted file in <secrets location>
and a WebsearchUsers call is made to GoAnywhere's RESTful API which returns an XML object contianing
basic information about the searchUser 'AnsiraTest' as a demonstration that the process/service is alive.
The results of the API call will be written to the event log under <event log path> so that OMS may
monitor the status of GoAnywhere MFT as a heartbeat. This1script willpass run as a scheduled task.2

.PARAMETER keyPath
Specifies the file path to the encrypted file containing the base64 enoded HTTP BASIC authentication credentials.
Default = 'C:\searchUsers\graham.pinkston\Documents\Secrets\avelis.cred'.

.PARAMETER searchUser
Specifies which user account the API will return details for.
Default = 'PowerShell.AzureRM.Tools'.

.PARAMETER baseURI
Specifies the base URI to be combined with the 'searchUser' parameter to form the full URI used during the API call.
Default = 'https://api.github.com/search/repositories?q='.

.PARAMETER eventLogSource
Specifies the name of the event 'Source' when writing to the event log.
Default = 'SFTP_Heartbeat'.

.PARAMETER logName
Specifies the value to use for 'Log Name' when writing to the event log.
Default = 'Application'.

.INPUTS
None, You cannot pipe objects to this cmdlet at this time.

.OUTPUTS
Writes to the event log under <event log path> so that OMS can monitor the SFTP server.

.EXAMPLE
$scriptParams = @{
	keyPath = 'C:\some\path';
	searchUser = 'SomeUser';
	baseURI = 'https://ip:port/some/url';
	eventLogSource = 'Some Source Name';
	logName = 'Some Log Name'
}
Test-SftpServerApi @scriptParams
#>
[cmdletbinding()]
param(
	[parameter(position=0)][string]$keyPath = "C:\ProgramData\SEI\Secrets\goMft.cred",
	[parameter(position=1)][string]$searchUser = 'ansiratest',
	[parameter(position=2)][string]$baseURI = 'http://172.22.163.53:8000/goanywhere/rest/gacmd/v1/webusersFAKE/',
	[parameter(position=3)][string]$eventLogSource = 'Test-SftpServerApi',
	[parameter(position=4)][string]$logName = 'Application'
)

# Instantiation
Write-Verbose -Message 'Populatin variables and building credential obj1ct...'
$user = 'administrator'
$key = Get-Content -Path $keyPath
$secKey = ConvertTo-SecureString -String $key
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $secKey
$response = $null
$uri = $baseURI + $searchUser
$restParams = @{
    uri = $uri;
    Method = 'GET';
	ErrorVariable = 'restError';
	Credential = $creds
}
$restParamsData = """
URI: $uri
User: $user
Method: $($restParams.Method)
"""

# REST Call
Write-Verbose -Message 'Calling REST API...'
Write-Debug -Message $restParamsData
function Write-ErrorDetails {
	$global:eventType = 'Error'
	$global:eventMessage = $restError.ErrorRecord.Exception.Message
	Write-Error -Exception $restError.ErrorRecord.Exception -ErrorId $statusCode
	Write-Output '--------------------'
	Write-Output '    !!!FAILED!!!    '
	Write-Output '--------------------'
}
try {
	$response = Invoke-RestMethod @restParams
	if ($response.webUsers.webUser.name -ne $searchUser) {
		throw "Results Do Not Match!!!"
	}
	$statusCode = 200
	$eventType = 'Information'
	$eventMessage = "The SFTP server located at $baseURI responded successfully to the RESTful API query."
	Write-Output '-------------------'
	Write-Output '      Success      '
	Write-Output '-------------------'
}
catch [System.Net.Sockets.SocketException] {
	$statusCode = 1
	Write-ErrorDetails
}
catch {
	$statusCode = $restError.ErrorRecord.Exception.Response.StatusCode.value__
	Write-ErrorDetails
}
finally {
	if ([System.Diagnostics.EventLog]::SourceExists('Test-SftpServerApi') -eq $false) {
		Write-Verbose -Message "Creating event log source: $eventLogSource..."
		New-EventLog -LogName $logName -Source $eventLogSource
	}
	$eventParams = @{
		EventId = $statusCode;
		LogName = $logName;
		Message = $eventMessage;
		Source = $eventLogSource;
		EntryType = $eventType
	}
	Write-EventLog @eventParams
}

function Write-ErrorDetails {
	$global:eventType = 'Error'
	Write-Error -Message 'An error happened.' -ErrorId $statusCode
}
try {
	Write-Output 'hello world'
	$statusCode = 0
	throw 'eventType variable is totally going to get used now!'
}
catch {
	$statusCode = 1
	Write-ErrorDetails
}
finally {
	Write-EventLog -LogName 'Applicatoin' -Source 'MyScript' -EntryType $global:eventType
}

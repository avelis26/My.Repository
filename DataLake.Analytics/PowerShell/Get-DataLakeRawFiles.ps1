Function Get-DataLakeRawFiles {
	[CmdletBinding()]
	Param(
		[string]$dataLakeStoreName, # 711dlprodcons01
		[string]$destination, # D:\BIT_CRM\20150501\
		[string]$source, # /BIT_CRM/20180502
		[string]$log # \\MS-SSW-CRM-MGMT\Data\opslog.log
	)
	If ($(Test-Path -Path $destination) -eq $true) {
		Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Removing folder $destination ..."
		Remove-Item -Path $destination -Force -Recurse -ErrorAction Stop > $null
	}
	Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Downloading folder $source..."
	$exportParams = @{
		Account = $dataLakeStoreName;
		Path = $source;
		Destination = $destination;
		Force = $true;
		Concurrency = 512;
		ErrorAction = 'Stop';
	}
	Export-AzureRmDataLakeStoreItem @exportParams
	Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Folder $source downloaded successfully."
}

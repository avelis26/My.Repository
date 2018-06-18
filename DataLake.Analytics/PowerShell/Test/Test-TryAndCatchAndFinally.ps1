[CmdletBinding()]
Param(
	[switch]$foo
)
Try {
	Write-Output 'hello'
}
Catch {
	Write-Output 'catch 1'
}
Try {
	If ($foo.IsPresent -eq $true) {	
		Write-Output ' '
	}
	Catch {
		Write-Output 'catch 2'
	}
}
Finally {
	# no try / catch inside finally
	Try {
		Write-Output 'world'
	}
	Catch {
		Write-Output 'catch 3'
	}
}
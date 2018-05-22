Function Split-FilesAmongFolders {
	[CmdletBinding()]
	Param(
		[string]$rootPath, # $($destinationRootPath + $processDate + '\' )
		[string]$log # $opsLog
	)
	$fileCount = $null
	$files = Get-ChildItem -Path $rootPath -File -ErrorAction Stop
	$fileCount = $files.Count.ToString()
	Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Found $fileCount total files..."
	$i = 1
	$count = 5
	$folderPreFix = 'bucket_'
	While ($i -lt $($count + 1)) {
		$dirName = $folderPreFix + $i
		$dirPath = $rootPath + $dirName
		If ($(Test-Path -Path $dirPath) -eq $false) {
			Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Creating folder:  $dirPath ..."
			New-Item -ItemType Directory -Path $dirPath -Force -ErrorAction Stop > $null
		}
		Else {
			Get-ChildItem -Path $dirPath -Recurse -ErrorAction Stop | Remove-Item -Force -ErrorAction Stop
		}
		$i++
	}
	[int]$divider = $($files.Count / $count) - 0.5
	$i = 0
	Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Separating files into bucket folders..."
	While ($i -lt $($files.Count)) {
		If ($i -lt $divider) {
			$movePath = $rootPath + $folderPreFix + '1'
		}
		ElseIf ($i -ge $divider -and $i -lt $($divider * 2)) {
			$movePath = $rootPath + $folderPreFix + '2'
		}
		ElseIf ($i -ge $($divider * 2) -and $i -lt $($divider * 3)) {
			$movePath = $rootPath + $folderPreFix + '3'
		}
		ElseIf ($i -ge $($divider * 3) -and $i -lt $($divider * 4)) {
			$movePath = $rootPath + $folderPreFix + '4'
		}
		Else {
			$movePath = $rootPath + $folderPreFix + '5'
		}
		Move-Item -Path $files[$i].FullName -Destination $movePath -Force -ErrorAction Stop
		$i++
	}
}
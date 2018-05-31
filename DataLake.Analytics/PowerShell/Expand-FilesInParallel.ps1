Function Expand-FilesInParallel {
	[CmdletBinding()]
	Param(
		[string]$rootPath, # $($destinationRootPath + $processDate + '\' )
		[string]$log,
		[string]$processDate,
		[string]$dataLakeRoot
	)
	$folders = Get-ChildItem -Path $rootPath -Directory -ErrorAction Stop
	$jobI = 0
	$jobBaseName = 'unzip_job_'
	ForEach ($folder in $folders) {
		$block = {
			[System.Threading.Thread]::CurrentThread.Priority = 'Highest'
			$ProgressPreference = 'SilentlyContinue'
			Import-Module 7Zip4powershell -ErrorAction Stop
			$files = Get-ChildItem -Path $args[0] -Filter '*.gz' -File -ErrorAction Stop
			$status = @()
			$status += 'pass'
			$status += '-----------------------------------------'
			ForEach ($file in $files) {
				Try {
					Expand-7Zip -ArchiveFileName $($file.FullName) -TargetPath $args[0] -ErrorAction Stop > $null
				}
				Catch {
					$status[0] = 'fail'
					$status += $($file.Name)
				}
				Finally {
					Remove-Item -Path $($file.FullName) -Force -ErrorAction Stop > $null
				}
			}
			Return $status
		}
		Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Starting decompress job:  $($folder.FullName)..."
		Start-Job -ScriptBlock $block -ArgumentList $($folder.FullName) -Name $($jobBaseName + $jobI.ToString()) -ErrorAction Stop
		$jobI++
	}
	Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Spliting and decompressing..."
	$r = 0
	While ($r -lt $($folders.Count)) {
		Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Waiting for decompress job: $($jobBaseName + $r.ToString())..."
		Get-Job -Name $($jobBaseName + $r.ToString()) -ErrorAction Stop | Wait-Job -ErrorAction Stop
		Tee-Object -FilePath $log -Append -ErrorAction Stop -InputObject "$(New-TimeStamp)  Receiving job $($jobBaseName + $r.ToString())..."
		$dJobResult = $null
		$dJobResult = Receive-Job -Name $($jobBaseName + $r.ToString()) -ErrorAction Stop
		If ($dJobResult[0] -ne 'pass') {
			[string]$badFiles = $null
			ForEach ($line in $dJobResult[2..$($dJobResult.Count)]) {
				[string]$badFiles += "$dataLakeRoot$processDate/$line`r`n"
			}
			throw "Decompression Failed!!!`r`nThe following files failed to decompress:`r`n$badFiles"
		}
		Remove-Job -Name $($jobBaseName + $r.ToString()) -ErrorAction Stop
		$r++
	}
}
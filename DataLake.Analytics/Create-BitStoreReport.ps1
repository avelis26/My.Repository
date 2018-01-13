# Get raw files

# Seperate files into groups of 1000 files in seperate folders

$path = 'C:\tmp\'
$files = Get-ChildItem -Path $path -File
Write-Output "Found $($files.Count) number of files..."

$i = 1
$count = 5
$folderPreFix = 'bucket_'

While ($i -lt $($count + 1)) {
	$dirName = $folderPreFix + $i
	$dirPath = $path + $dirName
	If ($(Test-Path -Path $dirPath) -eq $false) {
		Write-Verbose -Message "Creating folder:  $dirPath ..."
		New-Item -ItemType Directory -Path $dirPath -Force
	}
	Else {
		Remove-Item -Path $dirPath -Force
	}
	$i++
}

[int]$divider = $($files.Count / $count) - 0.5

$i = 0
While ($i -lt $($files.Count + 1)) {
	If ($i -lt $divider) {

	}
	ElseIf ($i -ge $divider -and $i -lt $($divider * 2)) {

	}
	ElseIf ($i -ge $($divider * 2) -and $i -lt $($divider * 3)) {

	}
	ElseIf ($i -ge $($divider * 3) -and $i -lt $($divider * 4)) {

	}
	Else {

	}
}


	

# Execute C# app as job
<#
$inputPath = "C:\BIT_CRM\Test\"
$outputPath = 'C:\BIT_CRM\Output\'
$transTypes = 'D1121,D1122,D1124'
$filePreFix = '20171023'
$command = "C:\Scripts\C#\Debug\Ansira.Sel.fileExtractor.exe '$inputPath' '$outputPath' '$transTypes' '$filePrefix'"
Invoke-Expression -Command $command
#>


# Call SP to clean DB of rows older than 90 days



# Insert output to DB



# Call SP to run aggregate queries



# Clean up, send notifications



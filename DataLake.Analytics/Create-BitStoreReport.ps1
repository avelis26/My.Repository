Function DeGZip-File {
	[CmdletBinding()]
	Param(
		[string]$infile
	)
	$outfile = $infile -replace '\.gz$',''
	Write-Verbose -Message "Uncompressing $infile..."
	$input = New-Object System.IO.FileStream $inFile, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read)
	$output = New-Object System.IO.FileStream $outFile, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None)
	$outputFile = $output.Name
	$gzipStream = New-Object System.IO.Compression.GzipStream $input, ([IO.Compression.CompressionMode]::Decompress)
	$buffer = New-Object byte[](1024)
	while($true) {
		$read = $gzipstream.Read($buffer, 0, 1024)
		if ($read -le 0){break}
		$output.Write($buffer, 0, $read)
	}
	$gzipStream.Close()
	$output.Close()
	$input.Close()
	Write-Verbose -Message "Removing compressed $infile..."
	Remove-Item -Path $infile -Force
	Return $outputFile
}


# Get raw files




# Seperate files into groups of 1000 files in seperate folders

$path = 'C:\tmp\'
$files = Get-ChildItem -Path $path -File
Write-Output "Found $($files.Count) number of files..."
ForEach ($file in $files) {
	DeGZip-File -infile $file.FullName
}
$files = Get-ChildItem -Path $path -File

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
		Get-ChildItem -Path $dirPath -Recurse | Remove-Item -Force
	}
	$i++
}

[int]$divider = $($files.Count / $count) - 0.5

$i = 0
While ($i -lt $($files.Count)) {
	If ($i -lt $divider) {
		$movePath = $path + $folderPreFix + '1'
	}
	ElseIf ($i -ge $divider -and $i -lt $($divider * 2)) {
		$movePath = $path + $folderPreFix + '2'
	}
	ElseIf ($i -ge $($divider * 2) -and $i -lt $($divider * 3)) {
		$movePath = $path + $folderPreFix + '3'
	}
	ElseIf ($i -ge $($divider * 3) -and $i -lt $($divider * 4)) {
		$movePath = $path + $folderPreFix + '4'
	}
	Else {
		$movePath = $path + $folderPreFix + '5'
	}
	Move-Item -Path $files[$i].FullName -Destination $movePath -Force -ErrorAction Stop
	$i++
}




# Execute C# app as job

$startTime = Get-Date
$filePreFix = 'Test'
$inputPath = "C:\BIT_CRM\$filePreFix\"
$transTypes = 'D1121,D1122,D1124'
$folders = Get-ChildItem -Path $inputPath -Directory
ForEach ($folder in $folders) {
	$outputPath = $($folder.Parent.FullName) + '\' + $($folder.Name) + '_Output\'
	If ($(Test-Path -Path $outputPath) -eq $false) {
		Write-Verbose -Message "Creating folder:  $outputPath ..."
		New-Item -ItemType Directory -Path $outputPath -Force
	}
	$block = {
		& "C:\Scripts\C#\Debug\Ansira.Sel.fileExtractor.exe" $args;
		Remove-Item -Path $($folder.Name) -Recurse -Force
	}
	Start-Job -ScriptBlock $block -ArgumentList "$($folder.FullName)", "$outputPath", "$transTypes", "$filePrefix"
}
Get-Job | Wait-Job
Get-Job | Remove-Job
Write-Output "Start Time: $($startTime.DateTime)"
$endTime = Get-Date
Write-Output "End Time: $($endTime.DateTime)"
New-TimeSpan -Start $startTime -End $endTime



# Call SP to clean DB of rows older than 90 days



# Insert output to DB



# Call SP to run aggregate queries



# Clean up, send notifications



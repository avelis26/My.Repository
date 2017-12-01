###############################################################################################################################
# Verbose preference will show what is happeneing when set to 'Continue'. Change to 'SilentlyContinue' to run faster.
$VerbosePreference = 'SilentlyContinue'
# Root directory expects child folders that contain either uncompressed or gz commpressed ASCII files.
$rootDir = "C:\BIT_CRM\Temp\"
# Parse path may not be a child of rootDir.
$parsedPath = "C:\BIT_CRM\Parsed\"
###############################################################################################################################
$D1121 = @()
$D1122 = @()
$D1124 = @()
$other = @()
Function DeGZip-File {
	Param(
		[string]$infile,
		$outfile = ($infile -replace '\.gz$','')
	)
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
Function D1_121 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6); #pk
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 6); #pk
			ShiftNumber = $line.Substring(18 - 1, 6); #pk
			TransactionUID = $line.SubString(24 - 1, 11); #pk
			Aborted = $line.Substring(35 - 1, 1);
			DeviceNumber = $line.Substring(36 - 1, 6);
			DeviceType = $line.Substring(42 - 1, 6);
			EmployeeNumber = $line.Substring(48 - 1, 6);
			EndDate = $line.Substring(54 - 1, 8);
			EndTime = $line.Substring(62 - 1, 6);
			StartDate = $line.Substring(68 - 1, 8);
			StartTime = $line.Substring(76 - 1, 6);
			Status = $line.Substring(82 - 1, 1);
			TotalAmount = $line.SubString(83 - 1, 11);
			TransactionCode = $line.Substring(94 - 1, 6);
			TransactionSequence = $line.Substring(100 - 1, 11) #pk
			'7RewardMemberID' = $line.Substring(111 - 1, 19)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_122 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordID = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 6);
			ShiftNumber = $line.Substring(18 - 1, 6);
			TransactionUID = $line.SubString(24 - 1, 11);
			SequenceNumber = $line.SubString(35 - 1, 11);
			ProductNumber = $line.SubString(46 - 1, 11);
			PLUNumber = $line.SubString(57 - 1, 14);
			RecordAmount = $line.SubString(71 - 1, 11);
			RecordCount = $line.Substring(82 - 1, 6);
			RecordType = $line.Substring(88 - 1, 6);
			SizeIndx = $line.Substring(94 - 1, 1);
			ErrorCorrectionFlag = $line.Substring(95 - 1, 1);
			PriceOverideFlag = $line.Substring(96 - 1, 1);
			TaxableFlag = $line.Substring(97 - 1, 1);
			VoidFlag = $line.Substring(98 - 1, 1);
			RecommendedFlag = $line.Substring(99 - 1, 1);
			PriceMultiple = $line.Substring(100 - 1, 6);
			CarryStatus = $line.Substring(106 - 1, 6);
			TaxOverideFlag = $line.Substring(112 - 1, 1);
			PromotionCount = $line.Substring(113 - 1, 2);
			SalesPrice = $line.Substring(115 - 1, 4);
			MUBasePrice = $line.Substring(119 - 1, 4);
			HostItemId = $line.Substring(123 - 1, 14);
			CouponCoun = $line.Substring(137 - 1, 2)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_124 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 6);
			ShiftNumber = $line.Substring(18 - 1, 6);
			TransactionUID = $line.SubString(24 - 1, 11);
			SequenceNumber = $line.SubString(35 - 1, 11);
			MediaNumber = $line.Substring(46 - 1, 6);
			NetworkMediaSequenceNumber = $line.SubString(52 - 1, 11);
			MediaType = $line.Substring(63 - 1, 2);
			RecordCount = $line.Substring(65 - 1, 6);
			RecordAmount = $line.SubString(71 - 1, 11);
			RecordType = $line.Substring(82 - 1, 6);
			ErrorCorrectionFlag = $line.Substring(88 - 1, 1);
			VoidFlag = $line.Substring(89 - 1, 1);
			ExchangeRate = $line.Substring(90 - 1, 5);
			ForeignAmount = $line.SubString(95 - 1, 11)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
$global:x = 1
$global:fileCount = $(Get-ChildItem -Path $rootDir -Recurse -File).Count
$folders = Get-ChildItem -Path $rootDir -Directory
Write-Verbose -Message "$fileCount files found in $($folders.Count) folders."
ForEach ($folder in $folders) {
	If (!(Test-Path -LiteralPath $($parsedPath + $folder.Name))) {
		Write-Verbose -Message "Creating folder: $($parsedPath + $folder.Name)"
		New-Item -ItemType Directory -Path $($parsedPath + $folder.Name) -Force
	}
	Else {
		Write-Verbose -Message "Rmoving files in $($parsedPath + $folder.Name)"
		Get-ChildItem -Path $($parsedPath + $folder.Name) -Recurse -File | Remove-Item -Force
	}
	$files = Get-ChildItem -LiteralPath $folder.FullName -Recurse -File
	ForEach ($file in $files) {
		Write-Output "$global:x of $fileCount:: $file.FullName"
		If ($file.Extension -eq '.gz') {
			$outFile = DeGZip-File -infile $file.FullName
			$lines = Get-Content -LiteralPath $outFile
		}
		Else {
			$lines = Get-Content -LiteralPath $file.FullName
		}
		$lineCount = $lines.Length
		$global:y = 1
		ForEach ($line in $lines) {
			Write-Verbose -Message "Processing line $global:y of $lineCount in file $global:x of $fileCount"
			$lineType = ($line.Substring(1 - 1, 2)) + ($line.Substring(9 - 1, 3))
			switch ($lineType) {
				'D1121' {
					$D1121 += D1_121 -line $line; Break
				}
				'D1122' {
					$D1122 += D1_122 -line $line; Break
				}
				'D1124' {
					$D1124 += D1_124 -line $line; Break
				}
				default {
					$line += $other; Break
				}
			}
			$global:y++
		}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_121.csv')..."
		If ($D1121 -ne $null) {$D1121 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_121.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_122.csv')..."
		If ($D1122 -ne $null) {$D1122 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_122.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_124.csv')..."
		If ($D1124 -ne $null) {$D1124 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_124.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'other.csv')..."
		If ($other -ne $null) {$other | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'other.csv') -Force -NoTypeInformation -Append}
		$global:x++
	}
}

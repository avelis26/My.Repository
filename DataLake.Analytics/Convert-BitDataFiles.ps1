# Verbose preference will show what is happeneing when set to 'Continue'. Change to 'SilentlyContinue' to run faster.
$VerbosePreference = 'Continue'
# Root directory expects child folders that contain either uncompressed or gz commpressed ASCII files.
$rootDir = 'C:\Users\graham.pinkston\AppData\Local\USQLDataRoot\BIT_CRM\'
# Parse path may not be a child of rootDir.
$parsedPath = 'C:\Users\graham.pinkston\AppData\Local\USQLDataRoot\Parsed\'
$D1120 = @()
$D1127 = @()
$D1135 = @()
$D1463 = @()
$D1409 = @()
$D1123 = @()
$D1130 = @()
$D1133 = @()
$D1122 = @()
$D1124 = @()
$D1140 = @()
$D1139 = @()
$D1128 = @()
$D1129 = @()
$D1136 = @()
$D1137 = @()
$D1411 = @()
$D1462 = @()
$D1138 = @()
$D1131 = @()
$D1134 = @()
$D1125 = @()
$D1121 = @()
$D1132 = @()
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
Function D1_120 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 4);
			ShiftNumber = $line.Substring(16 - 1, 4);
			TransactionDate = $line.Substring(20 - 1, 14);
			CardAccountNumber = $line.Substring(34 - 1, 19);
			EmployeeNumber = $line.Substring(53 - 1, 6);
			SequenceNumber = $line.Substring(59 - 1, 11);
			DeviceNumber = $line.Substring(70 - 1, 3);
			ApprovalCode = $line.Substring(73 - 1, 9);
			ResponseCode = $line.Substring(82 - 1, 4);
			STTNumber = $line.Substring(86 - 1, 6);
			LoadAmount = $line.Substring(92 - 1, 6);
			FeeAmount = $line.Substring(98 - 1, 6);
			CardBalance = $line.Substring(104 - 1, 6);
			VoidFlag = $line.Substring(110 - 1, 1);
			EmbeddedFee = $line.Substring(111 - 1, 6);
			VendorFee = $line.Substring(117 - 1, 6)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_127 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 6);
			ShiftNumber = $line.Substring(18 - 1, 6);
			TransactionUID = $line.Substring(24 - 1, 11);
			SequenceNumbar = $line.Substring(35 - 1, 11);
			Comments = $line.Substring(46 - 1, 80);
			RecordType = $line.Substring(126 - 1, 6)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_135 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			TerminalNumber = $line.Substring(12 - 1, 6);
			Scanner = $line.Substring(18 - 1, 6);
			MsrPort = $line.Substring(24 - 1, 6);
			CustomerDisplayPort = $line.Substring(30 - 1, 6);
			PinPadPort = $line.Substring(36 - 1, 6);
			ForceDrop = $line.Substring(42 - 1, 6);
			IsCloseDrawer = $line.Substring(48 - 1, 1);
			IsShowSafeDrop = $line.Substring(49 - 1, 1);
			IsOpenDrawer = $line.Substring(50 - 1, 1);
			IsShiftSignOn = $line.Substring(51 - 1, 1);
			IsPumpInterface = $line.Substring(52 - 1, 1);
			IsAuditEOS = $line.Substring(53 - 1, 1);
			IsRevenueEOS = $line.Substring(54 - 1, 1);
			IsNetworkBatchEOS = $line.Substring(55 - 1, 1);
			IsAcceptEOS = $line.Substring(56 - 1, 1);
			IsAuditEOD = $line.Substring(57 - 1, 1);
			IsRevenueEOD = $line.Substring(58 - 1, 1);
			IsNetworkEOD = $line.Substring(59 - 1, 1);
			IsAcceptEOD = $line.Substring(60 - 1, 1);
			TerminalType = $line.Substring(61 - 1, 5);
			AlarmDropAmount = $line.Substring(66 - 1, 5)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_463 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 9);
			ShiftNumber = $line.Substring(21 - 1, 6);
			TransactionUID = $line.Substring(27 - 1, 9);
			SequenceNumber = $line.Substring(36 - 1, 9);
			PLUNumber = $line.SubString(45 - 1, 22);
			PrimaryCompany = $line.SubString(67 - 1, 15);
			OfferCode = $line.Substring(82 - 1, 6);
			SaveValue = $line.Substring(88 - 1, 9);
			PrimaryPurchaseRequirement = $line.Substring(97 - 1, 9);
			PrimaryPurchaseRequirementCode = $line.Substring(106 - 1, 1);
			PrimaryPurchaseFamilyCode = $line.Substring(107 - 1, 3);
			AdditionalPurchaseRulesCode = $line.Substring(110 - 1, 1);
			SecondPurchaseRequirement = $line.Substring(111 - 1, 9);
			SecondPurchaseRequirementCode = $line.Substring(120 - 1, 1);
			SecondPurchaseFamilyCode = $line.Substring(121 - 1, 3);
			SecondCompany = $line.Substring(124 - 1, 15);
			ThirdPurchaseRequirement = $line.Substring(139 - 1, 9);
			ThirdPurchaseRequirementCode = $line.Substring(148 - 1, 1);
			ThirdPurchaseFamilyCode = $line.Substring(149 - 1, 3);
			ThirdCompany = $line.Substring(152 - 1, 15);
			ExpirationDate = $line.Substring(167 - 1, 6);
			StartDate = $line.Substring(173 - 1, 6);
			SerialNumber = $line.Substring(179 - 1, 15);
			RetailerID = $line.Substring(194 - 1, 15);
			SaveValueCode = $line.Substring(209 - 1, 1);
			DiscountedItem = $line.Substring(210 - 1, 1);
			IsStoreCoupon = $line.Substring(211 - 1, 1);
			IsMultiple = $line.Substring(212 - 1, 1);
			RejectReason = $line.Substring(213 - 1, 80)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_409 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 9);
			ShiftNumber = $line.Substring(21 - 1, 6);
			TransactionUID = $line.Substring(27 - 1, 9);
			SequenceNumber = $line.Substring(36 - 1, 9);
			CouponId = $line.Substring(45 - 1, 9);
			CouponDescription = $line.SubString(54 - 1, 18);
			PLUNumber = $line.SubString(72 - 1, 22);
			CouponType = $line.Substring(94 - 1, 2);
			CouponValueCode = $line.Substring(96 - 1, 2);
			EntryMethod = $line.Substring(98 - 1, 9);
			HostMediaNumber = $line.Substring(107 - 1, 9);
			RecordAmount = $line.Substring(116 - 1, 9);
			RecordCount = $line.Substring(125 - 1, 9);
			ErrorCorrectionFlag = $line.Substring(134 - 1, 1);
			VoidFlag = $line.Substring(135 - 1, 1);
			TaxableFlag = $line.Substring(136 - 1, 1);
			TaxOverrideFlag = $line.Substring(137 - 1, 1);
			AnnulFlag = $line.Substring(138 - 1, 1);
			PrimaryCompanyId = $line.Substring(139 - 1, 15);
			OfferCode = $line.Substring(154 - 1, 6);
			SaveValue = $line.Substring(160 - 1, 9);
			PrimaryPurchaseRequirement = $line.Substring(169 - 1, 9);
			PrimaryPurchaseRequirementCode = $line.Substring(178 - 1, 1);
			PrimaryPurchaseFamilyCode = $line.Substring(179 - 1, 3);
			AdditionalPurchaseRulesCode = $line.Substring(182 - 1, 1);
			SecondPurchaseRequirement = $line.Substring(183 - 1, 9);
			SecondPurchaseRequirementCode = $line.Substring(192 - 1, 1);
			SecondPurchaseFamilyCode = $line.Substring(193 - 1, 3);
			SecondCompanyId = $line.Substring(196 - 1, 15);
			ThirdPurchaseRequirement = $line.Substring(211 - 1, 9);
			ThirdPurchaseRequirementCode = $line.Substring(220 - 1, 1);
			ThirdPurchaseFamilyCode = $line.Substring(221 - 1, 3);
			ThirdCompanyId = $line.Substring(224 - 1, 15);
			ExpirationDate = $line.Substring(239 - 1, 6);
			StartDate = $line.Substring(245 - 1, 6);
			SerialNumber = $line.Substring(251 - 1, 15);
			RetailerId = $line.Substring(266 - 1, 15);
			SaveValueCode = $line.Substring(281 - 1, 1);
			DiscountedItem = $line.Substring(282 - 1, 1);
			StoreCouponIndicator = $line.Substring(283 - 1, 1);
			NoMultiplyFlag = $line.Substring(284 - 1, 1)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_123 {
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
			DepartmentNumber = $line.Substring(46 - 1, 6);
			SubDepartment = $line.Substring(52 - 1, 6);
			RecordType = $line.Substring(58 - 1, 6);
			RecordCount = $line.Substring(64 - 1, 6);
			RecordAmount = $line.SubString(70 - 1, 11);
			ErrorCorrectionFlag = $line.Substring(81 - 1, 1);
			VoidFlag = $line.Substring(82 - 1, 1);
			TaxableFlag = $line.Substring(83 - 1, 1);
			PriceOverideFlag = $line.Substring(84 - 1, 1);
			TaxOverideFlag = $line.Substring(85 - 1, 1);
			HostItemId = $line.SubString(86 - 1, 14)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_130 {
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
			RecordType = $line.Substring(46 - 1, 6);
			DispenserNumber = $line.Substring(52 - 1, 6);
			SaleProductId = $line.Substring(58 - 1, 6);
			HoseNumber = $line.Substring(64 - 1, 6);
			MediaNumber = $line.Substring(70 - 1, 6);
			ServiceLevelId = $line.Substring(76 - 1, 6);
			PricePerUnit = $line.SubString(82 - 1, 11);
			SaleVolume = $line.SubString(93 - 1, 11);
			CreePage = $line.Substring(104 - 1, 11);
			RecordAmount = $line.Substring(115 - 1, 11);
			FuelPriceTable = $line.Substring(126 - 1, 6);
			FuelPriceGroup = $line.Substring(132 - 1, 6);
			PrimaryTankNumber = $line.Substring(138 - 1, 6);
			PrimaryTankVolume = $line.Substring(144 - 1, 11);
			SecondaryTankNumber = $line.Substring(155 - 1, 6);
			SecondaryTankVolume = $line.Substring(161 - 1, 11);
			ManualFlag = $line.Substring(172 - 1, 1);
			AutoFinalFlag = $line.Substring(173 - 1, 1);
			DeviceType = $line.Substring(174 - 1, 6);
			ErrorCorrectionFlag = $line.Substring(180 - 1, 1);
			VoidFlag = $line.Substring(181 - 1, 1);
			PrepayFlag = $line.Substring(182 - 1, 1);
			MediaAdjustAmount = $line.Substring(183 - 1, 11);
			AdjustPricePerUni = $line.Substring(194 - 1, 11)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_133 {
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
			LoadSaleSequenceNumber = $line.SubString(46 - 1, 11);
			RecordType = $line.Substring(57 - 1, 4);
			LoadAmount = $line.Substring(61 - 1, 6);
			BalanceAmount = $line.Substring(67 - 1, 6);
			AccountNumber = $line.SubString(73 - 1, 19);
			STTNumber = $line.Substring(92 - 1, 6);
			AuthorizationTime = $line.Substring(98 - 1, 6);
			AuthorizationNumber = $line.Substring(104 - 1, 12);
			AuthorizationCode = $line.Substring(116 - 1, 6);
			NetworkTerminal = $line.Substring(122 - 1, 12);
			NetworkLocalTerminal = $line.Substring(134 - 1, 2);
			PLUNumber = $line.Substring(136 - 1, 14);
			ItemId = $line.Substring(150 - 1, 11);
			ItmCostAmount = $line.Substring(161 - 1, 11);
			VendorId = $line.Substring(172 - 1, 11);
			FeeAmount = $line.Substring(183 - 1, 6);
			FeeAmountEmbedded = $line.Substring(189 - 1, 6);
			FeeAmountVendo = $line.Substring(195 - 1, 6)
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
Function D1_140 {
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
			MoneyOrderSaleAmount = $line.Substring(46 - 1, 6);
			MoneyOrderFeeAmount = $line.Substring(52 - 1, 4);
			MoneyOrderSerialNumber = $line.SubString(56 - 1, 12);
			MoneyOrderDepartmentSaleSeqNumber = $line.SubString(68 - 1, 10);
			MoneyOrderDepartmentFeeNumber = $line.SubString(78 - 1, 10);
			MoneyOrderPrintedFlg = $line.SubString(88 - 1, 10)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_139 {
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
			OwnerSequenceNumber = $line.Substring(46 - 1, 4);
			AccountNumber = $line.SubString(50 - 1, 40);
			BatchNumber = $line.SubString(90 - 1, 10);
			BatchSequenceNumber = $line.Substring(100 - 1, 10);
			CardTransactionFee = $line.Substring(110 - 1, 4);
			RecordType = $line.Substring(114 - 1, 6);
			ReponseCodeText = $line.Substring(120 - 1, 12);
			AuthorizationNumber = $line.Substring(132 - 1, 12);
			AuthorizationCode1 = $line.Substring(144 - 1, 6);
			AuthorizationCode2 = $line.Substring(150 - 1, 6);
			CustomerName = $line.Substring(156 - 1, 26);
			EntryType = $line.Substring(182 - 1, 10);
			ExpirationDate = $line.Substring(192 - 1, 4);
			AuthorizationTime = $line.Substring(196 - 1, 6);
			VehicleNumber = $line.Substring(202 - 1, 10);
			OdometerReading = $line.Substring(212 - 1, 10);
			DriverNumber = $line.Substring(222 - 1, 10);
			CustomizedReferenceNumber = $line.Substring(232 - 1, 14);
			AccountType = $line.Substring(246 - 1, 3);
			AuthorizationTraceId = $line.Substring(249 - 1, 6);
			AuthorizationPartyName = $line.Substring(255 - 1, 20);
			STTNumber = $line.Substring(275 - 1, 6);
			BalanceAmount = $line.Substring(281 - 1, 4);
			MaskedAccountNumber = $line.Substring(285 - 1, 40);
			RoutingNumber = $line.Substring(325 - 1, 9);
			CheckNumber = $line.Substring(334 - 1, 10);
			CardType = $line.Substring(344 - 1, 10);
			Amount = $line.Substring(354 - 1, 11)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_128 {
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
			ErrorCorrectionFlag = $line.Substring(46 - 1, 1);
			Amount = $line.SubString(47 - 1, 11);
			MediaNumber = $line.Substring(58 - 1, 6);
			ReasonCode = $line.Substring(64 - 1, 6);
			RecordType = $line.Substring(70 - 1, 6);
			TerminalNumber = $line.Substring(76 - 1, 6);
			VoidFlag = $line.Substring(82 - 1, 1)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_129 {
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
			ErrorCorrectionFlag = $line.Substring(46 - 1, 1);
			Amount = $line.SubString(47 - 1, 11);
			MediaNumber = $line.Substring(58 - 1, 6);
			ReasonCode = $line.Substring(64 - 1, 6);
			RecordType = $line.Substring(70 - 1, 6);
			TerminalNumber = $line.Substring(76 - 1, 6);
			VoidFlag = $line.Substring(82 - 1, 1)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
###############################################################################################################
###############################################################################################################
##                                                                                                           ##
##     D1_136 only has 86 chars in all the data I sampled but the SQL view code shows there should be 92     ##
##                                                                                                           ##
###############################################################################################################
###############################################################################################################
Function D1_136 {
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
			RecordType = $line.Substring(46 - 1, 6);
			ErrorCorrectionFlag = $line.Substring(52 - 1, 1);
			VoidFlag = $line.Substring(53 - 1, 1);
			TaxableFlag = $line.Substring(54 - 1, 1);
			TaxOverideFlag = $line.Substring(55 - 1, 1);
			PromotionId = $line.Substring(56 - 1, 6);
			RecordCount = $line.Substring(62 - 1, 6);
			RecordAmount = $line.Substring(68 - 1, 6);
			PromotionProductCode = $line.Substring(74 - 1, 6);
			DepartmentNumber = $line.Substring(80 - 1, 6)
			#TAX_TBL_1 = $line.Substring(86 - 1, 1);
			#TAX_TBL_2 = $line.Substring(87 - 1, 1);
			#TAX_TBL_3 = $line.Substring(88 - 1, 1);
			#TAX_TBL_4 = $line.Substring(89 - 1, 1);
			#TAX_TBL_5 = $line.Substring(90 - 1, 1);
			#TAX_TBL_6 = $line.Substring(91 - 1, 1);
			#ALLOW_FOOD_STAMP = $line.Substring(92 - 1, 2)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_137 {
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
			OwnerSequenceNumber = $line.SubString(46 - 1, 11);
			PromotionSequenceNumber = $line.SubString(57 - 1, 11);
			RecordAmount = $line.Substring(68 - 1, 6);
			RecordCount = $line.Substring(74 - 1, 6);
			PromotionGroupId = $line.Substring(80 - 1, 4);
			ThresholdQty = $line.Substring(84 - 1, 4)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_411 {
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
			SafeActivityType = $line.Substring(46 - 1, 1);
			SafeMediaNumber = $line.Substring(47 - 1, 6);
			SafeMediaType = $line.Substring(53 - 1, 2);
			POSAmount = $line.SubString(55 - 1, 11);
			SafeAmount = $line.SubString(66 - 1, 11);
			ForeignAmount = $line.SubString(77 - 1, 11);
			EnvelopeNumber = $line.Substring(88 - 1, 6);
			CommunicationStatus = $line.Substring(94 - 1, 1)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_462 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			DayNumber = $line.Substring(12 - 1, 9);
			ShiftNumber = $line.Substring(21 - 1, 6);
			TransactionUID = $line.Substring(27 - 1, 9);
			SequenceNumber = $line.Substring(36 - 1, 9);
			ItemId = $line.Substring(45 - 1, 9);
			PLUNumber = $line.SubString(54 - 1, 14);
			BestBeforeDate = $line.Substring(68 - 1, 6);
			SellByDate = $line.Substring(74 - 1, 6);
			ExpirationDate = $line.Substring(80 - 1, 6);
			ExpirationDateTime = $line.SubString(86 - 1, 10);
			RejectedReason = $line.SubString(96 - 1, 80)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_138 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			TransactionDate = $line.Substring(12 - 1, 8);
			TransactionHour = $line.SubString(20 - 1, 11);
			MerchandiseAmount = $line.SubString(31 - 1, 11);
			GasSalesAmount = $line.SubString(42 - 1, 11);
			MerchandiseCount = $line.SubString(53 - 1, 11);
			GasSaleCount = $line.SubString(64 - 1, 11);
			POSCount = $line.SubString(75 - 1, 11);
			CRINDCount = $line.SubString(86 - 1, 11);
			PeriodCode = $line.Substring(97 - 1, 1);
			ExpiryDate = $line.Substring(98 - 1, 8);
			MerchandiseUnits = $line.Substring(106 - 1, 11)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_131 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordID = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			BackOfficeDayStatus = $line.Substring(12 - 1, 1);
			POSPostingDayStatus = $line.Substring(13 - 1, 1);
			DayNumber = $line.Substring(14 - 1, 6);
			ShiftNumber = $line.Substring(20 - 1, 6);
			BusinessDate = $line.Substring(26 - 1, 8);
			ShiftStartDate = $line.Substring(34 -1 , 14);
			ShiftEndDate = $line.Substring(48 - 1, 14)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_134 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			EmployeeNumber = $line.Substring(12 - 1, 6);
			EmployeeName = $line.SubString(18 - 1, 30);
			Password = $line.Substring(48 - 1, 8);
			ClassId = $line.Substring(56 - 1, 8);
			SecurityLevel = $line.Substring(64 - 1, 1);
			SSN = $line.Substring(65 - 1, 9);
			PasswordChangeDate = $line.SubString(74 - 1, 14);
			Password2 = $line.Substring(88 - 1, 8);
			Password3 = $line.Substring(96 - 1, 8);
			Password4 = $line.Substring(104 - 1, 8);
			Password5 = $line.Substring(112 - 1, 8);
			Password6 = $line.Substring(120 - 1, 8);
			LockoutDate = $line.Substring(128 - 1, 14)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
}
Function D1_125 {
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
			ErrorCorrectionFlag = $line.Substring(46 - 1, 1);
			RecordType = $line.Substring(47 - 1, 6);
			RecordAmount = $line.SubString(53 - 1, 11);
			TaxTable = $line.Substring(64 - 1, 6);
			IsVoid = $line.Substring(70 - 1, 1);
			IsDeduct = $line.Substring(71 - 1, 1)
		}
		Return $lineObj
	}
	Catch {
		Write-Error -Message $_.Exception.Message -ErrorAction Stop
	}
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
Function D1_132 {
	Param([string]$line)
	Try {
		$lineObj = New-Object -TypeName PsObject -Property @{
			RecordId = $line.Substring(1 - 1, 2);
			StoreNumber = $line.Substring(3 - 1, 6);
			TransactionType = $line.Substring(9 - 1, 3);
			TransactionCode = $line.Substring(12 - 1, 6);
			TransactionDescription = $line.SubString(18 - 1, 20);
			AddOrSubstruct = $line.Substring(38 - 1, 6)
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
	$files = Get-ChildItem -LiteralPath $folder.FullName -Recurse -File
	ForEach ($file in $files) {
		If (!(Test-Path -LiteralPath $($parsedPath + $file.Directory.Name))) {
			Write-Verbose -Message "Creating folder: $($parsedPath + $file.Directory.Name)"
			New-Item -ItemType Directory -Path $($parsedPath + $file.Directory.Name) -Force
		}
		Else {
			Write-Verbose -Message "Rmoving files in $($parsedPath + $file.Directory.Name)"
			Get-ChildItem -Path $($parsedPath + $file.Directory.Name) | Remove-Item -Force
		}
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
				'D1120' {
					$D1120 += D1_120 -line $line; Break
				}
				'D1127' {
					$D1127 += D1_127 -line $line; Break
				}
				'D1135' {
					$D1135 += D1_135 -line $line; Break
				}
				'D1463' {
					$D1463 += D1_463 -line $line; Break
				}
				'D1409' {
					$D1409 += D1_409 -line $line; Break
				}
				'D1123' {
					$D1123 += D1_123 -line $line; Break
				}
				'D1130' {
					$D1130 += D1_130 -line $line; Break
				}
				'D1133' {
					$D1133 += D1_133 -line $line; Break
				}
				'D1122' {
					$D1122 += D1_122 -line $line; Break
				}
				'D1124' {
					$D1124 += D1_124 -line $line; Break
				}
				'D1140' {
					$D1140 += D1_140 -line $line; Break
				}
				'D1139' {
					$D1139 += D1_139 -line $line; Break
				}
				'D1128' {
					$D1128 += D1_128 -line $line; Break
				}
				'D1129' {
					$D1129 += D1_129 -line $line; Break
				}
				'D1136' {
					$D1136 += D1_136 -line $line; Break
				}
				'D1137' {
					$D1137 += D1_137 -line $line; Break
				}
				'D1411' {
					$D1411 += D1_411 -line $line; Break
				}
				'D1462' {
					$D1462 += D1_462 -line $line; Break
				}
				'D1138' {
					$D1138 += D1_138 -line $line; Break
				}
				'D1131' {
					$D1131 += D1_131 -line $line; Break
				}
				'D1134' {
					$D1134 += D1_134 -line $line; Break
				}
				'D1125' {
					$D1125 += D1_125 -line $line; Break
				}
				'D1121' {
					$D1121 += D1_121 -line $line; Break
				}
				'D1132' {
					$D1132 += D1_132 -line $line; Break
				}
				default {
					$line += $other; Break
				}
			}
			$global:y++
		}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_120.csv')..."
		If ($D1120 -ne $null) {$D1120 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_120.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_127.csv')..."
		If ($D1127 -ne $null) {$D1127 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_127.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_135.csv')..."
		If ($D1135 -ne $null) {$D1135 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_135.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_463.csv')..."
		If ($D1463 -ne $null) {$D1463 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_463.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_409.csv')..."
		If ($D1409 -ne $null) {$D1409 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_409.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_123.csv')..."
		If ($D1123 -ne $null) {$D1123 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_123.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_130.csv')..."
		If ($D1130 -ne $null) {$D1130 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_130.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_133.csv')..."
		If ($D1133 -ne $null) {$D1133 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_133.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_122.csv')..."
		If ($D1122 -ne $null) {$D1122 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_122.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_124.csv')..."
		If ($D1124 -ne $null) {$D1124 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_124.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_140.csv')..."
		If ($D1140 -ne $null) {$D1140 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_140.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_139.csv')..."
		If ($D1139 -ne $null) {$D1139 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_139.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_128.csv')..."
		If ($D1128 -ne $null) {$D1128 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_128.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_129.csv')..."
		If ($D1129 -ne $null) {$D1129 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_129.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_136.csv')..."
		If ($D1136 -ne $null) {$D1136 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_136.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_137.csv')..."
		If ($D1137 -ne $null) {$D1137 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_137.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_411.csv')..."
		If ($D1411 -ne $null) {$D1411 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_411.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_462.csv')..."
		If ($D1462 -ne $null) {$D1462 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_462.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_138.csv')..."
		If ($D1138 -ne $null) {$D1138 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_138.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_131.csv')..."
		If ($D1131 -ne $null) {$D1131 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_131.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_134.csv')..."
		If ($D1134 -ne $null) {$D1134 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_134.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_125.csv')..."
		If ($D1125 -ne $null) {$D1125 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_125.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_121.csv')..."
		If ($D1121 -ne $null) {$D1121 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_121.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'D1_132.csv')..."
		If ($D1132 -ne $null) {$D1132 | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'D1_132.csv') -Force -NoTypeInformation -Append}
		Write-Verbose -Message "Exporting $($parsedPath + $file.Directory.Name + '\' + 'other.csv')..."
		If ($other -ne $null) {$other | Export-Csv -LiteralPath $($parsedPath + $file.Directory.Name + '\' + 'other.csv') -Force -NoTypeInformation -Append}
		$global:x++
	}
}

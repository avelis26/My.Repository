function Append-CustomRow {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$true)][ValidateLength(1, 255)]
		[string]$filePath,
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$Priority_CH = 'OFF',
		[Parameter(Mandatory=$true)][ValidateRange(107,581)]
		[double]$Receive_Frequency,
		[Parameter(Mandatory=$true)][ValidateRange(107,581)]
		[double]$Transmit_Frequency,
		[Parameter()][ValidateRange(0,474)]
		[decimal]$Offset_Frequency = 0,
		[Parameter()][ValidateSet('+RPT', '-RPT', '-/+', 'OFF')]
		[string]$Offset_Direction = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$AUTO_MODE = 'ON',
		[Parameter()][ValidateSet('FM', 'AM')]
		[string]$Operating_Mode = 'FM',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$AMS = 'ON',
		[Parameter()][ValidateSet('DN', 'ANALOG')]
		[string]$DIG_ANALOG = 'ANALOG',
		[Parameter(Mandatory=$true)][ValidateLength(1, 255)]
		[string]$Name,
		[Parameter()][ValidateSet('OFF','TONE', 'TONE SQL', 'DCS', 'REV TONE', 'PR FREQ', 'PAGER')]
		[string]$Tone_Mode = 'OFF',
		[Parameter()][ValidateSet('67.0 Hz', '69.4 Hz', '71.9 Hz', '74.4 Hz', '77.0 Hz', '79.7 Hz', '82.5 Hz', '85.4 Hz', '88.5 Hz', '91.5 Hz', '94.8 Hz', '97.4 Hz', '100.0 Hz', '103.5 Hz', '107.2 Hz', '110.9 Hz', '114.8 Hz', '118.8 Hz', '123.0 Hz', '127.3 Hz', '131.8 Hz', '136.5 Hz', '141.3 Hz', '146.2 Hz', '150.0 Hz', '151.4 Hz', '156.7 Hz', '159.8 Hz', '162.2 Hz', '165.5 Hz', '167.9 Hz', '171.3 Hz', '173.8 Hz', '177.3 Hz', '179.9 Hz', '183.5 Hz', '186.2 Hz', '189.9 Hz', '192.8 Hz', '196.6 Hz', '199.5 Hz', '203.5 Hz', '206.5 Hz', '210.7 Hz', '218.1 Hz', '225.7 Hz', '229.1 Hz', '233.6 Hz', '241.8 Hz', '250.3 Hz', '254.1 Hz')]
		[string]$CTCSS_Frequency = '88.5 Hz',
		[Parameter()][ValidateSet(23, 25, 26, 31, 32, 43, 47, 51, 53, 54, 65, 71, 72, 73, 74, 114, 115, 116, 122, 125, 131, 132, 134, 143, 152, 155, 156, 162, 165, 172, 174, 205, 212, 223, 225, 226, 243, 244, 245, 246, 251, 252, 261, 263, 265, 266, 271, 306, 311, 315, 325, 331, 343, 346, 351, 364, 365, 371, 411, 412, 413, 423, 425, 431, 432, 445, 446, 452, 455, 464, 465, 466, 503, 506, 516, 521, 525, 532, 546, 552, 564, 565, 606, 612, 624, 627, 631, 632, 645, 652, 654, 662, 664, 703, 712, 723, 725, 726, 731, 732, 734, 743, 754)]
		[int]$DCS_Code = 23,
		[Parameter()][ValidateSet('RX Normal TX Normal', 'RX Invert TX Normal', 'RX Both TX Normal', 'RX Normal TX Invert', 'RX Invert TX Invert', 'RX Both TX Invert')]
		[string]$DCS_Polarity = 'RX Normal TX Normal',
		[Parameter()][ValidateSet('300 Hz', '400 Hz', '500 Hz', '600 Hz', '700 Hz', '800 Hz', '900 Hz', '1000 Hz', '1100 Hz', '1200 Hz', '1300 Hz', '1400 Hz', '1500 Hz', '1600 Hz', '1700 Hz', '1800 Hz', '1900 Hz', '2000 Hz', '2100 Hz', '2200 Hz', '2300 Hz', '2400 Hz', '2500 Hz', '2600 Hz', '2700 Hz', '2800 Hz', '2900 Hz', '3000 Hz')]
		[string]$User_CTCSS = '300 Hz',
		[Parameter()][ValidateSet('LOW', 'MID', 'HIGH')]
		[string]$Tx_Power = 'HIGH',
		[Parameter()][ValidateSet('OFF', 'SKIP', 'SELECT')]
		[string]$Skip = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$AUTO_STEP  = 'ON',
		[Parameter()][ValidateSet('5.0KHz', '6.25KHz', '10.0KHz', '5.0KHz', '12.5KHz', '15.0KHz', '20.0KHz', '25.0KHz', '50.0KHz', '100.0KHz')]
		[string]$Step = '5.0KHz',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$TAG = 'ON',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$Memory_Mask = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$ATT = 'OFF',
		[Parameter()][ValidateSet('OFF', 'LEVEL 1', 'LEVEL 2', 'LEVEL 3', 'LEVEL 4', 'LEVEL 5', 'LEVEL 6', 'LEVEL 7', 'LEVEL 8', 'LEVEL 9')]
		[string]$S_Meter_SQL = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$Bell = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$Half_DEV = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$Clock_Shift = 'OFF',	
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$GMRS_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$MURS_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$CALL_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$SAT_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$C4FM_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$WIRES_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$AIR_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$VHF_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$UHF_BANK = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_10 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_11 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_12 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_13 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_14 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_15 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_16 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_17 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_18 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_19 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_20 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_21 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_22 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_23 = 'OFF',
		[Parameter()][ValidateSet('OFF', 'ON')]
		[string]$BANK_24 = 'OFF',
		[Parameter()][ValidateLength(1, 255)]
		[string]$Comment = '',
		[Parameter()][ValidateRange(0,0)]
		[int]$Line_Terminate = 0
)
	begin {
		$fileContent = $(Get-Content -Path $filePath -Tail 1)
		$lineNumber = [int]$($fileContent.Substring(0,3)) + 1
		$data = [PSCustomObject]@{
			Channel_No = $("{0:d3}" -f $lineNumber).ToString();
			Priority_CH = $Priority_CH;
			Receive_Frequency = $("{0:n5}" -f $Receive_Frequency);
			Transmit_Frequency = $("{0:n5}" -f $Transmit_Frequency);
			Offset_Frequency = $("{0:n5}" -f $Offset_Frequency);
			Offset_Direction = $Offset_Direction;
			AUTO_MODE = $AUTO_MODE;
			Operating_Mode = $Operating_Mode;
			AMS = $AMS;
			DIG_ANALOG = $DIG_ANALOG;
			Name = $Name;
			Tone_Mode = $Tone_Mode;
			CTCSS_Frequency = $CTCSS_Frequency;
			DCS_Code = $("{0:d3}" -f $DCS_Code);
			DCS_Polarity = $DCS_Polarity;
			User_CTCSS = $User_CTCSS;
			Tx_Power = $Tx_Power;
			Skip = $Skip;
			AUTO_STEP = $AUTO_STEP;
			Step = $Step;
			TAG = $TAG;
			Memory_Mask = $Memory_Mask;
			ATT = $ATT;
			S_Meter_SQL = $S_Meter_SQL;
			Bell = $Bell;
			Half_DEV = $Half_DEV;
			Clock_Shift = $Clock_Shift;
			GMRS_BANK = $GMRS_BANK;
			MURS_BANK = $MURS_BANK;
			CALL_BANK = $CALL_BANK;
			SAT_BANK = $SAT_BANK;
			C4FM_BANK = $C4FM_BANK;
			WIRES_BANK = $WIRES_BANK;
			AIR_BANK = $AIR_BANK;
			VHF_BANK = $VHF_BANK;
			UHF_BANK = $UHF_BANK;
			BANK_10 = $BANK_10;
			BANK_11 = $BANK_11;
			BANK_12 = $BANK_12;
			BANK_13 = $BANK_13;
			BANK_14 = $BANK_14;
			BANK_15 = $BANK_15;
			BANK_16 = $BANK_16;
			BANK_17 = $BANK_17;
			BANK_18 = $BANK_18;
			BANK_19 = $BANK_19;
			BANK_20 = $BANK_20;
			BANK_21 = $BANK_21;
			BANK_22 = $BANK_22;
			BANK_23 = $BANK_23;
			BANK_24 = $BANK_24;
			Comment = $Comment;
			Line_Terminate = $Line_Terminate.ToString();
		}
	}
	process {
		$output = $data.Channel_No + ',' + `
		$data.Priority_CH + ',' + `
		$data.Receive_Frequency + ',' + `
		$data.Transmit_Frequency + ',' + `
		$data.Offset_Frequency + ',' + `
		$data.Offset_Direction + ',' + `
		$data.AUTO_MODE + ',' + `
		$data.Operating_Mode + ',' + `
		$data.AMS + ',' + `
		$data.DIG_ANALOG + ',' + `
		$data.Name + ',' + `
		$data.Tone_Mode + ',' + `
		$data.CTCSS_Frequency + ',' + `
		$data.DCS_Code + ',' + `
		$data.DCS_Polarity + ',' + `
		$data.User_CTCSS + ',' + `
		$data.Tx_Power + ',' + `
		$data.Skip + ',' + `
		$data.AUTO_STEP + ',' + `
		$data.Step + ',' + `
		$data.TAG + ',' + `
		$data.Memory_Mask + ',' + `
		$data.ATT + ',' + `
		$data.S_Meter_SQL + ',' + `
		$data.Bell + ',' + `
		$data.Half_DEV + ',' + `
		$data.Clock_Shift + ',' + `
		$data.GMRS_BANK + ',' + `
		$data.MURS_BANK + ',' + `
		$data.CALL_BANK + ',' + `
		$data.SAT_BANK + ',' + `
		$data.C4FM_BANK + ',' + `
		$data.WIRES_BANK + ',' + `
		$data.AIR_BANK + ',' + `
		$data.VHF_BANK + ',' + `
		$data.UHF_BANK + ',' + `
		$data.BANK_10 + ',' + `
		$data.BANK_11 + ',' + `
		$data.BANK_12 + ',' + `
		$data.BANK_13 + ',' + `
		$data.BANK_14 + ',' + `
		$data.BANK_15 + ',' + `
		$data.BANK_16 + ',' + `
		$data.BANK_17 + ',' + `
		$data.BANK_18 + ',' + `
		$data.BANK_19 + ',' + `
		$data.BANK_20 + ',' + `
		$data.BANK_21 + ',' + `
		$data.BANK_22 + ',' + `
		$data.BANK_23 + ',' + `
		$data.BANK_24 + ',' + `
		$data.Comment + ',' + `
		$data.Line_Terminate
	}
	end {
		Out-File -FilePath $filePath -InputObject $output -Append
	}
}
<#
$i = 335
While ($i -lt 901) {
	$blank_line = $("{0:d3}" -f $i).ToString() + ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,0'
	Write-Output $blank_line
	Out-File -FilePath 'C:\Users\Avelis\Documents\ft70-test.csv' -InputObject $blank_line -Append
	$i++
}

#>
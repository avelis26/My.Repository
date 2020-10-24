$filePathString = 'C:\Users\Avelis\Documents\ft70-test.csv'
$Channel_No = 46
$Priority_CH = 'OFF'
$Receive_Frequency = 442.825
$Transmit_Frequency = 447.825
$Offset_Frequency = 5
$Offset_Direction = '+RPT'
$AUTO_MODE = 'ON'
$Operating_Mode = 'FM'
$AMS = 'ON'
$DIG_ANALOG = 'DN'
$Name = 'N5VAV'
$Tone_Mode = 'TONE'
$CTCSS_Frequency = '110.9 Hz'
$DCS_Code = 23
$DCS_Polarity = 'RX Normal TX Normal'
$User_CTCSS = '300 Hz'
$Tx_Power = 'HIGH'
$Skip = 'OFF'
$AUTO_STEP = 'ON'
$Step = '5.0KHz'
$TAG = 'ON'
$Memory_Mask = 'OFF'
$ATT = 'OFF'
$S_Meter_SQL = 'OFF'
$Bell = 'OFF'
$Half_DEV = 'OFF'
$Clock_Shift = 'OFF'
$GMRS_BANK = 'OFF'
$SAT_BANK = 'OFF'
$C4FM_BANK = 'ON'
$WIRES_BANK = 'OFF'
$AIR_BANK = 'OFF'
$VHF_BANK = 'OFF'
$UHF_BANK = 'OFF'
$BANK_08 = 'OFF'
$BANK_09 = 'OFF'
$BANK_10 = 'OFF'
$BANK_11 = 'OFF'
$BANK_12 = 'OFF'
$BANK_13 = 'OFF'
$BANK_14 = 'OFF'
$BANK_15 = 'OFF'
$BANK_16 = 'OFF'
$BANK_17 = 'OFF'
$BANK_18 = 'OFF'
$BANK_19 = 'OFF'
$BANK_20 = 'OFF'
$BANK_21 = 'OFF'
$BANK_22 = 'OFF'
$BANK_23 = 'OFF'
$BANK_24 = 'OFF'
$Comment = ''
$Line_Terminate = 0

$data = [PSCustomObject]@{
	Channel_No = $Channel_No.ToString();
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
	SAT_BANK = $SAT_BANK;
	C4FM_BANK = $C4FM_BANK;
	WIRES_BANK = $WIRES_BANK;
	AIR_BANK = $AIR_BANK;
	VHF_BANK = $VHF_BANK;
	UHF_BANK = $UHF_BANK;
	BANK_08 = $BANK_08;
	BANK_09 = $BANK_09;
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
$var =	$data.Channel_No + ',' + `
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
		$data.SAT_BANK + ',' + `
		$data.C4FM_BANK + ',' + `
		$data.WIRES_BANK + ',' + `
		$data.AIR_BANK + ',' + `
		$data.VHF_BANK + ',' + `
		$data.UHF_BANK + ',' + `
		$data.BANK_08 + ',' + `
		$data.BANK_09 + ',' + `
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

Out-File -FilePath $filePathString -InputObject $var -Append
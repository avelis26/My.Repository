. .\Out-FT70CSV.ps1
$fileInPath = 'C:\Users\Avelis\Downloads\RB_RT_2010292054.csv'
$fileOutPath = 'C:\Users\Avelis\Documents\ft70-test.csv'
$fileContent = Import-Csv -Path $fileInPath
ForEach ($row in $fileContent) {
	$appendParams = @{filePath = $fileOutPath;}
	$appendParams.Add('Name', $($row.Name))
	$appendParams.Add('CTCSS_Frequency', $($row.CTCSS + ' Hz'))
	$appendParams.Add('Receive_Frequency', $($row.ReceiveFrequency))
	$appendParams.Add('Transmit_Frequency', $($row.TransmitFrequency))
	$offsetDiff = [decimal]$($row.ReceiveFrequency) - [decimal]$($row.TransmitFrequency)
	if ($offsetDiff -lt 0) {
		$appendParams.Add('Offset_Frequency', [decimal]$(-$offsetDiff))
		$appendParams.Add('Offset_Direction', '+RPT')
	}
	elseif ($offsetDiff -gt 0) {
		$appendParams.Add('Offset_Frequency', [decimal]$offsetDiff)
		$appendParams.Add('Offset_Direction', '-RPT')
	}
	if ($($row.ToneMode) -like 'T SQL') {
		$appendParams.Add('Tone_Mode', 'TONE SQL')
	}
	elseif ($($row.ToneMode) -like 'Tone') {
		$appendParams.Add('Tone_Mode', 'TONE')
	}
	<#
	if ($($row.ReceiveFrequency) -lt 300) {
		$appendParams.Add('VHF_BANK', 'ON')
	}
	elseif ($($row.ReceiveFrequency) -gt 300) {
		$appendParams.Add('UHF_BANK', 'ON')
	}
	#>
	Append-CustomRow @appendParams
}

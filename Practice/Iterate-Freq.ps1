$filePathString = 'C:\Users\Avelis\Documents\ff-test.csv'
$array = @()
$Location = 0;
$Name = 'FF-001';
$Frequency = 147.607500;
$Duplex = $null;
$Offset = 0.000000;
$Tone = $null;
$rToneFreq = 88.5;
$cToneFreq = 88.5;
$DtcsCode = 23;
$DtcsPolarity = 'NN';
$Mode = 'NFM';
$TStep = 5;
$Skip = $null;
$Comment = $null;
$URCALL = $null;
$RPT1CALL = $null;
$RPT2CALL = $null;
$DVCODE = $null;
$data = [PSCustomObject]@{Location = $Location;Name = $Name;Frequency = $("{0:n6}" -f $Frequency);Duplex = $Duplex;Offset = $("{0:n6}" -f $Offset);Tone = $Tone;rToneFreq = $rToneFreq;cToneFreq = $cToneFreq;DtcsCode = $("{0:d3}" -f $DtcsCode);DtcsPolarity = $DtcsPolarity;Mode = $Mode;TStep = $("{0:n2}" -f $TStep);Skip = $Skip;Comment = $Comment;URCALL = $URCALL;RPT1CALL = $RPT1CALL;RPT2CALL = $RPT2CALL;DVCODE = $DVCODE;}
$array += $data
Write-Output $array

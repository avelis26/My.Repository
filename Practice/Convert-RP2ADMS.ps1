#$filePath = 'C:\Users\Avelis\Downloads\repeaterbook_repeaters_2010292036.csv'
$filePath = 'C:\Users\Avelis\Downloads\RB_RT_2010292054.csv'
$fileContent = Import-Csv -Path $filePath
ForEach ($row in $fileContent) {
    $var = "$($row.ReceiveFrequency) | $($row.TransmitFrequency) | $($row.Name) | $($row.ToneMode) | $($row.CTCSS) | $($row.RxCTCSS)"
    Write-Output $var
}
Clear-Host
$files = @(
    "C:\BIT_CRM\20171023\20171023_d1_121_output.csv"
)
$total = 0
ForEach ($file in $files) {
    $c = 0
    Write-Output "Processing file $file..."
    Get-Content -Path $file -ReadCount 250000 | ForEach-Object {
        $c += $_.Count
    }
    $total += $c
}
Write-Output $total.ToString("#,#")
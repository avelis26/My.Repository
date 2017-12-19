Clear-Host
$files = @(
    "C:\Users\graham.pinkston\Downloads\20171031_d1_121_output.csv",
    "C:\Users\graham.pinkston\Downloads\20171031_d1_122_output.csv",
    "C:\Users\graham.pinkston\Downloads\20171031_d1_124_output.csv"
)
$total = 0
ForEach ($file in $files) {
    $c = 0
    Write-Output "Processing file $file..."
    Get-Content -Path $file -ReadCount 1000 | ForEach-Object {
        $c += $_.Count
    }
    $total += $c
}
Write-Output $total.ToString("#,#")
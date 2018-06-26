$rootPath = 'C:\tmp'
$files = Get-ChildItem -Path $rootPath -File
$badFiles = @()
ForEach ($file in $files) {
    $content = Get-Content -Path $file.FullName
    If ($content[$content.Count - 1] -ne '::ETL SUCCESSFUL::') {
        $badFiles += $file.Name
    }
}
Write-Output $badFiles
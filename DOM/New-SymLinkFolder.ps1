$dir = 'C:\SFTP\'
$subDir = 'DomSftpProd01'
$value = '\\10.2.4.4\data'
If (Test-Path -Path $dir) {
    Remove-Item -Path $dir -Force
    New-Item -ItemType Directory -Path $dir -Force
} Else {
    New-Item -ItemType Directory -Path $dir -Force
}
$params = @{
	Path = $($dir + $subDir);
	ItemType = 'SymbolicLink';
	Value = $value;
}
New-Item @params

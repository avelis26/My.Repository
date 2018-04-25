# https://www.cathrinewilhelmsen.net/2015/04/12/table-partitioning-in-sql-server/
# https://docs.microsoft.com/en-us/sql/relational-databases/partitions/create-partitioned-tables-and-indexes?view=sql-server-2017
######################################################################################################################
# Remove partition schemes and functions
######################################################################################################################
USE [7ELE]
GO
IF EXISTS					(SELECT * FROM sys.partition_schemes WHERE [name] = 'Ps_Stores_Headers')
BEGIN
DROP PARTITION SCHEME		[Ps_Stores_Headers]
END
IF EXISTS					(SELECT * FROM sys.partition_functions WHERE [name] = 'Pf_Stores_Headers')
BEGIN
DROP PARTITION FUNCTION		[Pf_Stores_Headers]
END
IF EXISTS					(SELECT * FROM sys.partition_schemes WHERE [name] = 'Ps_Stores_Details')
BEGIN
DROP PARTITION SCHEME		[Ps_Stores_Details]
END
IF EXISTS					(SELECT * FROM sys.partition_functions WHERE [name] = 'Pf_Stores_Details')
BEGIN
DROP PARTITION FUNCTION		[Pf_Stores_Details]
END
GO
######################################################################################################################
# Remove header files and filegroups
######################################################################################################################
$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlFileGroups.sql'
$outFile = $outFilePath + $outFileName
If ($(Test-Path -Path $outFilePath) -eq $true) {
    Remove-Item -Path $outFilePath -Recurse -Force -ErrorAction Stop
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
Else {
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
$i = 1
While ($i -ne 12421) {
	$code = @"
ALTER DATABASE [7ELE] REMOVE FILE Header_dat_$($i.ToString('00000'))
ALTER DATABASE [7ELE] REMOVE FILEGROUP [Header_FG_$($i.ToString('00000'))]
"@
    Add-Content -Value $code -Path $outFile
    $i++
}
######################################################################################################################
# Remove detail files and filegroups
######################################################################################################################
$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlFileGroups.sql'
$outFile = $outFilePath + $outFileName
If ($(Test-Path -Path $outFilePath) -eq $true) {
    Remove-Item -Path $outFilePath -Recurse -Force -ErrorAction Stop
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
Else {
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
$i = 1
While ($i -ne 12421) {
	$code = @"
ALTER DATABASE [7ELE] REMOVE FILE Detail_dat_$($i.ToString('00000'))
ALTER DATABASE [7ELE] REMOVE FILEGROUP [Detail_FG_$($i.ToString('00000'))]
"@
    Add-Content -Value $code -Path $outFile
    $i++
}
######################################################################################################################
# Create header file groups and files
######################################################################################################################
$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlFileGroups.sql'
$outFile = $outFilePath + $outFileName
If ($(Test-Path -Path $outFilePath) -eq $true) {
    Remove-Item -Path $outFilePath -Recurse -Force -ErrorAction Stop
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
Else {
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
$i = 1
While ($i -ne 92) {
$code = @"
ALTER DATABASE [7ELE]
ADD FILEGROUP [Header_FG_$($i.ToString('00'))]
GO
ALTER DATABASE [7ELE]
ADD FILE (NAME = Header_dat_$($i.ToString('00')), FILENAME = 'F:\Data\Header_dat_$($i.ToString('00')).ndf', SIZE = 1MB, FILEGROWTH = 64MB) TO FILEGROUP [Header_FG_$($i.ToString('00'))]
GO
"@
    Add-Content -Value $code -Path $outFile
    $i++
}
######################################################################################################################
# Create detail file groups and files
######################################################################################################################
$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlFileGroups.sql'
$outFile = $outFilePath + $outFileName
If ($(Test-Path -Path $outFilePath) -eq $true) {
    Remove-Item -Path $outFilePath -Recurse -Force -ErrorAction Stop
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
Else {
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
$i = 1
While ($i -ne 92) {
$code = @"
ALTER DATABASE [7ELE]
ADD FILEGROUP [Detail_FG_$($i.ToString('00'))]
GO
ALTER DATABASE [7ELE]
ADD FILE (NAME = Detail_dat_$($i.ToString('00')), FILENAME = 'F:\Data\Detail_dat_$($i.ToString('00')).ndf', SIZE = 1MB, FILEGROWTH = 64MB) TO FILEGROUP [Detail_FG_$($i.ToString('00'))]
GO
"@
    Add-Content -Value $code -Path $outFile
    $i++
}
######################################################################################################################
# Create dates for partition functions
######################################################################################################################
$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlFileGroups.sql'
$outFile = $outFilePath + $outFileName
If ($(Test-Path -Path $outFilePath) -eq $true) {
    Remove-Item -Path $outFilePath -Recurse -Force -ErrorAction Stop
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
Else {
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
$startDate = $(Get-Date).AddDays(-40)
$dates = $null
$i = 0
While ($i -ne 90) {
    $year = $startDate.AddDays($i).Year.ToString('0000')
    $month = $startDate.AddDays($i).Month.ToString('00')
    $day = $startDate.AddDays($i).Day.ToString('00')
    $dates = $dates + '''' + $year + '-' + $month + '-' + $day + ''', '
    $i++
}
$dates = $dates.Substring(0, $dates.Length - 2)
Set-Content -Value $dates -Path $outFile
######################################################################################################################
# Create partition functions
######################################################################################################################
<#
USE [7ELE]
GO
DECLARE @sqlcmd1 nvarchar(102400)
DECLARE @string1 varchar(102400)
DECLARE @string2 nvarchar(102400)
SET @string1 = (SELECT DISTINCT(CAST([Store_Id] AS varchar)) + ',' AS 'data()' FROM [7ELE].[dbo].[STOR_Master] FOR XML PATH(''))
SET @string2 = LEFT(@string1, LEN(@string1) - 1)
SET @sqlcmd1 = N'CREATE PARTITION FUNCTION [Pf_Stores_Headers] (Int) AS RANGE LEFT FOR VALUES (' + @string2 + N')';
EXEC SP_EXECUTESQL @sqlcmd1
GO
DECLARE @sqlcmd1 nvarchar(102400)
DECLARE @string1 varchar(102400)
DECLARE @string2 nvarchar(102400)
SET @string1 = (SELECT DISTINCT(CAST([Store_Id] AS varchar)) + ',' AS 'data()' FROM [7ELE].[dbo].[STOR_Master] FOR XML PATH(''))
SET @string2 = LEFT(@string1, LEN(@string1) - 1)
SET @sqlcmd1 = N'CREATE PARTITION FUNCTION [Pf_Stores_Details] (Int) AS RANGE LEFT FOR VALUES (' + @string2 + N')';
EXEC SP_EXECUTESQL @sqlcmd1
GO
#>
CREATE PARTITION FUNCTION [Pf_Stores_Headers] (Date) AS RANGE LEFT FOR VALUES ()
CREATE PARTITION FUNCTION [Pf_Stores_Details] (Date) AS RANGE LEFT FOR VALUES ()
######################################################################################################################
# Create header partition scheme
######################################################################################################################
$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlFileGroups.sql'
$outFile = $outFilePath + $outFileName
If ($(Test-Path -Path $outFilePath) -eq $true) {
    Remove-Item -Path $outFilePath -Recurse -Force -ErrorAction Stop
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
Else {
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
$i = 1
$headersFileGroups = $null
$headersFileGroups = $headersFileGroups + "Header_FG_$($i.ToString('00'))"
While ($i -ne 91) {
	$i++
	$headersFileGroups = $headersFileGroups + ", Header_FG_$($i.ToString('00'))"
}
$code = @"
USE [7ELE]
GO
CREATE PARTITION SCHEME		[Ps_Stores_Headers] 
AS PARTITION				[Pf_Stores_Headers]
TO							($headersFileGroups)
GO
"@
Add-Content -Value $code -Path $outFile
######################################################################################################################
# Create detail partition scheme
######################################################################################################################
$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlFileGroups.sql'
$outFile = $outFilePath + $outFileName
If ($(Test-Path -Path $outFilePath) -eq $true) {
    Remove-Item -Path $outFilePath -Recurse -Force -ErrorAction Stop
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
Else {
    New-Item -Path $outFilePath -ItemType Directory -ErrorAction Stop
}
$i = 1
$detailsFileGroups = $null
$detailsFileGroups = $detailsFileGroups + "Detail_FG_$($i.ToString('00'))"
While ($i -ne 91) {
	$i++
	$detailsFileGroups = $detailsFileGroups + ", Detail_FG_$($i.ToString('00'))"
}
$code = @"
USE [7ELE]
GO
CREATE PARTITION SCHEME		[Ps_Stores_Details] 
AS PARTITION				[Pf_Stores_Details]
TO							($detailsFileGroups)
GO
"@
Add-Content -Value $code -Path $outFile

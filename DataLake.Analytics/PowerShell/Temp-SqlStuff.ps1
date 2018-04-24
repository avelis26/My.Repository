# https://www.cathrinewilhelmsen.net/2015/04/12/table-partitioning-in-sql-server/
# https://docs.microsoft.com/en-us/sql/relational-databases/partitions/create-partitioned-tables-and-indexes?view=sql-server-2017
######################################################################################################################
# Remove partition schemes and functions
######################################################################################################################
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
While ($i -ne 129) {
	$code = @"
ALTER DATABASE [7ELE] REMOVE FILE Header_dat_$($i.ToString('000'))
ALTER DATABASE [7ELE] REMOVE FILEGROUP [Header_FG_$($i.ToString('000'))]
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
While ($i -ne 129) {
	$code = @"
ALTER DATABASE [7ELE] REMOVE FILE Detail_dat_$($i.ToString('000'))
ALTER DATABASE [7ELE] REMOVE FILEGROUP [Detail_FG_$($i.ToString('000'))]
"@
    Add-Content -Value $code -Path $outFile
    $i++
}
######################################################################################################################
# Get the number of stores
######################################################################################################################
SELECT COUNT(DISTINCT([Store_Id])) FROM [7ELE].[dbo].[STOR_Master]
######################################################################################################################
# Use number of stores to great same number of header file groups and files
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
    ALTER DATABASE [7ELE]
	ADD FILEGROUP [Header_FG_$($i.ToString('00000'))]
    GO
    ALTER DATABASE [7ELE]
	ADD FILE (NAME = Header_dat_$($i.ToString('00000')), FILENAME = 'F:\Data\Header_dat_$($i.ToString('00000')).ndf', SIZE = 1MB, FILEGROWTH = 64MB) TO FILEGROUP [Header_FG_$($i.ToString('00000'))]
    GO
"@
    Add-Content -Value $code -Path $outFile
    $i++
}
######################################################################################################################
# Use number of stores to great same number of detail file groups and files
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
    ALTER DATABASE [7ELE]
	ADD FILEGROUP [Detail_FG_$($i.ToString('00000'))]
    GO
    ALTER DATABASE [7ELE]
	ADD FILE (NAME = Detail_dat_$($i.ToString('00000')), FILENAME = 'F:\Data\Detail_dat_$($i.ToString('00000')).ndf', SIZE = 1MB, FILEGROWTH = 64MB) TO FILEGROUP [Detail_FG_$($i.ToString('00000'))]
    GO
"@
    Add-Content -Value $code -Path $outFile
    $i++
}
######################################################################################################################
# Create partition functions
######################################################################################################################
USE [7ELE]
GO
DECLARE @sqlcmd1 nvarchar(2048)
DECLARE @string1 varchar(1024)
DECLARE @string2 nvarchar(1024)
SET @string1 = (SELECT DISTINCT(CAST([Store_Id] AS varchar)) + ',' AS 'data()' FROM [7ELE].[dbo].[STOR_Master] FOR XML PATH(''))
SET @string2 = LEFT(@string1, LEN(@string1) - 1)
SET @sqlcmd1 = N'CREATE PARTITION FUNCTION [Pf_Stores_Headers] (Int) AS RANGE LEFT FOR VALUES (' + @string2 + N')';
EXEC SP_EXECUTESQL @sqlcmd1
GO
DECLARE @sqlcmd1 nvarchar(2048)
DECLARE @string1 varchar(1024)
DECLARE @string2 nvarchar(1024)
SET @string1 = (SELECT DISTINCT(CAST([Store_Id] AS varchar)) + ',' AS 'data()' FROM [7ELE].[dbo].[STOR_Master] FOR XML PATH(''))
SET @string2 = LEFT(@string1, LEN(@string1) - 1)
SET @sqlcmd1 = N'CREATE PARTITION FUNCTION [Pf_Stores_Details] (Int) AS RANGE LEFT FOR VALUES (' + @string2 + N')';
EXEC SP_EXECUTESQL @sqlcmd1
GO
######################################################################################################################
# Create partition schemes
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
$headersFileGroups = $headersFileGroups + "Header_FG_$($i.ToString('00000'))"
While ($i -ne 12421) {
	$i++
	$headersFileGroups = $headersFileGroups + ", Header_FG_$($i.ToString('00000'))"
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
$detailsFileGroups = $detailsFileGroups + "Detail_FG_$($i.ToString('00000'))"
While ($i -ne 12421) {
	$i++
	$detailsFileGroups = $detailsFileGroups + ", Detail_FG_$($i.ToString('00000'))"
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

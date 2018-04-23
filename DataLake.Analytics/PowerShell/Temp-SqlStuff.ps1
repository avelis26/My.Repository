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
    ALTER DATABASE [7ELE]
    ADD FILEGROUP [Detail_FG_$($i.ToString('000'))]
    GO
    ALTER DATABASE [7ELE]
    ADD FILE
    (
	    NAME = Detail_dat_$($i.ToString('000')),
	    FILENAME = 'F:\Data\Detail_dat_$($i.ToString('000')).ndf',
	    SIZE = 5MB,
	    FILEGROWTH = 64MB
    )
    TO FILEGROUP [Detail_FG_$($i.ToString('000'))]
    GO
    -- ######################################################################
"@
    Add-Content -Value $code -Path $outFile
    $i++
}


$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlPartitions.sql'
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
    USE [7ELE]
    GO
    IF EXISTS					(SELECT * FROM sys.partition_schemes WHERE [name] = 'Ps_Stores_Headers_$($i.ToString('000'))')
    BEGIN
    DROP PARTITION SCHEME		[Ps_Stores_Headers_$($i.ToString('000'))]
    END
    IF EXISTS					(SELECT * FROM sys.partition_functions WHERE [name] = 'Pf_Stores_Headers_$($i.ToString('000'))')
    BEGIN
    DROP PARTITION FUNCTION		[Pf_Stores_Headers_$($i.ToString('000'))]
    END
    GO
    CREATE PARTITION FUNCTION	[Pf_Stores_Headers_$($i.ToString('000'))]		(Int)
    AS RANGE					RIGHT
    FOR VALUES					((SELECT [Store_Id] FROM [dbo].[Stores] WHERE [N] = $i))
    GO
    CREATE PARTITION SCHEME		[Ps_Stores_Headers_$($i.ToString('000'))] 
    AS PARTITION				[Pf_Stores_Headers_$($i.ToString('000'))]
    ALL TO						([Header_FG_$($i.ToString('000'))])
    GO
    IF EXISTS					(SELECT * FROM sys.partition_schemes WHERE [name] = 'Ps_Stores_Details_$($i.ToString('000'))')
    BEGIN
    DROP PARTITION SCHEME		[Ps_Stores_Details_$($i.ToString('000'))]
    END
    IF EXISTS					(SELECT * FROM sys.partition_functions WHERE [name] = 'Pf_Stores_Details_$($i.ToString('000'))')
    BEGIN
    DROP PARTITION FUNCTION		[Pf_Stores_Details_$($i.ToString('000'))]
    END
    GO
    CREATE PARTITION FUNCTION	[Pf_Stores_Details_$($i.ToString('000'))]		(Int)
    AS RANGE					RIGHT
    FOR VALUES					((SELECT [Store_Id] FROM [dbo].[Stores] WHERE [N] = $i))
    GO
    CREATE PARTITION SCHEME		[Ps_Stores_Details_$($i.ToString('000'))] 
    AS PARTITION				[Pf_Stores_Details_$($i.ToString('000'))]
    ALL TO						([Detail_FG_$($i.ToString('000'))])
    -- ######################################################################
"@
    Add-Content -Value $code -Path $outFile
    $i++
}



$outFilePath = 'C:\tmp\'
$outFileName = 'Create-SqlPartitions.sql'
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
    DECLARE @sqlcmd$i nvarchar(2048)
    DECLARE @string$i varchar(1024)
    DECLARE @string$($i * 100) nvarchar(1024)
    SET @string$i = (SELECT CAST([Store_Id] AS varchar) + ',' AS 'data()' FROM [dbo].[Stores] WHERE [N] = $i FOR XML PATH(''))
    SET @string$($i * 100) = LEFT(@string$i, LEN(@string$i) - 1)
    SET @sqlcmd$i = N'CREATE PARTITION FUNCTION [Pf_Stores_Details_$($i.ToString('000'))] (Int) AS RANGE RIGHT FOR VALUES (' + @string$($i * 100) + N')' ;
    EXEC SP_EXECUTESQL @sqlcmd$i
    CREATE PARTITION SCHEME		[Ps_Stores_Details_$($i.ToString('000'))]
    AS PARTITION				[Pf_Stores_Details_$($i.ToString('000'))]
    ALL TO						([Detail_FG_$($i.ToString('000'))])
    GO
    -- ######################################################################
"@
    Add-Content -Value $code -Path $outFile
    $i++
}


# https://www.cathrinewilhelmsen.net/2015/04/12/table-partitioning-in-sql-server/
# https://docs.microsoft.com/en-us/sql/relational-databases/partitions/create-partitioned-tables-and-indexes?view=sql-server-2017
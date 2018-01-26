USE							[7ELE]
GO
IF EXISTS					(SELECT * FROM sys.procedures WHERE name = 'usp_Create_Tmp_Header_Table')
BEGIN
DROP PROCEDURE				[dbo].[usp_Create_Tmp_Header_Table]
END
GO
CREATE PROCEDURE			[dbo].[usp_Create_Tmp_Header_Table]
							@StartDate				date,	
							@EndDate				date
AS
SET NOCOUNT ON

-- create var's containing dates starting at EndDate and going back 30 days

DECLARE						@Day01					date,
							@Day02					date,
							@Day03					date,
							@Day04					date,
							@Day05					date,
							@Day06					date,
							@Day07					date,
							@Day08					date,
							@Day09					date,
							@Day10					date,
							@Day11					date,
							@Day12					date,
							@Day13					date,
							@Day14					date,
							@Day15					date,
							@Day16					date,
							@Day17					date,
							@Day18					date,
							@Day19					date,
							@Day20					date,
							@Day21					date,
							@Day22					date,
							@Day23					date,
							@Day24					date,
							@Day25					date,
							@Day26					date,
							@Day27					date,
							@Day28					date,
							@Day29					date,
							@Day30					date
SET							@Day01 =				DATEADD(dd, -00, @EndDate)
SET							@Day02 =				DATEADD(dd, -01, @EndDate)
SET							@Day03 =				DATEADD(dd, -02, @EndDate)
SET							@Day04 =				DATEADD(dd, -03, @EndDate)
SET							@Day05 =				DATEADD(dd, -04, @EndDate)
SET							@Day06 =				DATEADD(dd, -05, @EndDate)
SET							@Day07 =				DATEADD(dd, -06, @EndDate)
SET							@Day08 =				DATEADD(dd, -07, @EndDate)
SET							@Day09 =				DATEADD(dd, -08, @EndDate)
SET							@Day10 =				DATEADD(dd, -09, @EndDate)
SET							@Day11 =				DATEADD(dd, -10, @EndDate)
SET							@Day12 =				DATEADD(dd, -11, @EndDate)
SET							@Day13 =				DATEADD(dd, -12, @EndDate)
SET							@Day14 =				DATEADD(dd, -13, @EndDate)
SET							@Day15 =				DATEADD(dd, -14, @EndDate)
SET							@Day16 =				DATEADD(dd, -15, @EndDate)
SET							@Day17 =				DATEADD(dd, -16, @EndDate)
SET							@Day18 =				DATEADD(dd, -17, @EndDate)
SET							@Day19 =				DATEADD(dd, -18, @EndDate)
SET							@Day20 =				DATEADD(dd, -19, @EndDate)
SET							@Day21 =				DATEADD(dd, -20, @EndDate)
SET							@Day22 =				DATEADD(dd, -21, @EndDate)
SET							@Day23 =				DATEADD(dd, -22, @EndDate)
SET							@Day24 =				DATEADD(dd, -23, @EndDate)
SET							@Day25 =				DATEADD(dd, -24, @EndDate)
SET							@Day26 =				DATEADD(dd, -25, @EndDate)
SET							@Day27 =				DATEADD(dd, -26, @EndDate)
SET							@Day28 =				DATEADD(dd, -27, @EndDate)
SET							@Day29 =				DATEADD(dd, -28, @EndDate)
SET							@Day30 =				DATEADD(dd, -29, @EndDate)

-- Drop current temp header table, partition function, and scheme

IF EXISTS					(SELECT * FROM sys.tables WHERE name = 'tmp_header_table')
BEGIN
DROP TABLE					[dbo].[tmp_header_table]
END
IF EXISTS					(SELECT * FROM sys.partition_schemes WHERE name = 'Ps_EndDate_By_Day')
BEGIN
DROP PARTITION SCHEME		[Ps_EndDate_By_Day]
END
IF EXISTS					(SELECT * FROM sys.partition_functions WHERE name = 'Pf_EndDate_By_Day')
BEGIN
DROP PARTITION FUNCTION		[Pf_EndDate_By_Day]
END

-- create partition function from provided enddate to partion at day level

CREATE PARTITION FUNCTION	[Pf_EndDate_By_Day]		(Date)
AS RANGE					RIGHT
FOR VALUES					(N'' + CONVERT(nvarchar, @Day01) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day02) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day03) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day04) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day05) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day06) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day07) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day08) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day09) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day10) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day11) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day12) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day13) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day14) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day15) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day16) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day17) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day18) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day19) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day20) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day21) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day22) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day23) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day24) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day25) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day26) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day27) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day28) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day29) + 'T00:00:00.000'
							,N'' + CONVERT(nvarchar, @Day30) + 'T00:00:00.000'
)

-- create partition scheme | accoring to https://www.mssqltips.com/sqlservertip/3494/azure-sql-database--table-partitioning/ mapping scheme to PRIMARY filegroup is required for azure sql database

CREATE PARTITION SCHEME		[Ps_EndDate_By_Day] 
AS PARTITION				[Pf_EndDate_By_Day]
ALL TO						([PRIMARY])

-- create tmp header table table on partition enddate day level scheme

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE				[dbo].[tmp_header_table]	(
							[RecordId]					[varchar](2)		NULL,
							[StoreNumber]				[int]				NULL,
							[TransactionType]			[int]				NOT NULL,
							[DayNumber]					[int]				NOT NULL,
							[ShiftNumber]				[int]				NOT NULL,
							[TransactionUID]			[int]				NOT NULL,
							[Aborted]					[bit]				NULL,
							[DeviceNumber]				[int]				NULL,
							[DeviceType]				[int]				NULL,
							[EmployeeNumber]			[int]				NULL,
							[EndDate]					[date]				NULL,
							[EndTime]					[time](7)			NULL,
							[StartDate]					[date]				NOT NULL,
							[StartTime]					[time](7)			NULL,
							[Status]					[tinyint]			NULL,
							[TotalAmount]				[money]				NULL,
							[TransactionCode]			[int]				NULL,
							[TransactionSequence]		[int]				NULL,
							[RewardMemberID]			[varchar](20)		NULL,
							[Header_Id]					[int] IDENTITY(1,1)	NOT NULL)
ON							[Ps_EndDate_By_Day]			([EndDate])

-- insert data to tmp table from prod table to have a smaller subset of data to query against

SET IDENTITY_INSERT			[dbo].[tmp_header_table]	ON
INSERT INTO					[dbo].[tmp_header_table]	(
							[RecordId],
							[StoreNumber],
							[TransactionType],
							[DayNumber],
							[ShiftNumber],
							[TransactionUID],
							[Aborted],
							[DeviceNumber],
							[DeviceType],
							[EmployeeNumber],
							[EndDate],
							[EndTime],
							[StartDate],
							[StartTime],
							[Status],
							[TotalAmount],
							[TransactionCode],
							[TransactionSequence],
							[RewardMemberID],
							[Header_Id]					)
SELECT						[th].[RecordId],
							[th].[StoreNumber],
							[th].[TransactionType],
							[th].[DayNumber],
							[th].[ShiftNumber],
							[th].[TransactionUID],
							[th].[Aborted],
							[th].[DeviceNumber],
							[th].[DeviceType],
							[th].[EmployeeNumber],
							[th].[EndDate],
							[th].[EndTime],
							[th].[StartDate],
							[th].[StartTime],
							[th].[Status],
							[th].[TotalAmount],
							[th].[TransactionCode],
							[th].[TransactionSequence],
							[th].[RewardMemberID],
							[th].[Header_Id]
FROM						[dbo].[stg_TXNHeader_121]	AS					th
WHERE						[th].[StartDate]			>=					@StartDate
AND							[th].[EndDate]				<=					@EndDate

-- rebuild indexs for tmp_header_table

IF EXISTS					(SELECT * FROM sys.indexes WHERE name = 'idx1_joins')
BEGIN
DROP INDEX					[idx1_joins]
ON							[dbo].[tmp_header_table]
END
CREATE NONCLUSTERED INDEX	[idx1_joins]
ON							[dbo].[tmp_header_table]	(
							[StoreNumber]				ASC,
							[ShiftNumber]				ASC,
							[DayNumber]					ASC,
							[TransactionUID]			ASC
														)
WITH						(
							STATISTICS_NORECOMPUTE = OFF,
							DROP_EXISTING = OFF,
							ONLINE = OFF
							)
ON							[Ps_EndDate_By_Day]			([EndDate]);
GO

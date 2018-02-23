SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
DECLARE								@StartDate				date,
									@EndDate				date,
									@Day01					date,
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
									@Day30					date,
									@Day31					date,
									@Day32					date,
									@Day33					date,
									@Day34					date,
									@Day35					date,
									@Day36					date,
									@Day37					date
SET									@StartDate =			'2018-01-13'
SET									@EndDate =				'2018-02-18'
SET									@Day01 =				DATEADD(dd, -00, @EndDate)
SET									@Day02 =				DATEADD(dd, -01, @EndDate)
SET									@Day03 =				DATEADD(dd, -02, @EndDate)
SET									@Day04 =				DATEADD(dd, -03, @EndDate)
SET									@Day05 =				DATEADD(dd, -04, @EndDate)
SET									@Day06 =				DATEADD(dd, -05, @EndDate)
SET									@Day07 =				DATEADD(dd, -06, @EndDate)
SET									@Day08 =				DATEADD(dd, -07, @EndDate)
SET									@Day09 =				DATEADD(dd, -08, @EndDate)
SET									@Day10 =				DATEADD(dd, -09, @EndDate)
SET									@Day11 =				DATEADD(dd, -10, @EndDate)
SET									@Day12 =				DATEADD(dd, -11, @EndDate)
SET									@Day13 =				DATEADD(dd, -12, @EndDate)
SET									@Day14 =				DATEADD(dd, -13, @EndDate)
SET									@Day15 =				DATEADD(dd, -14, @EndDate)
SET									@Day16 =				DATEADD(dd, -15, @EndDate)
SET									@Day17 =				DATEADD(dd, -16, @EndDate)
SET									@Day18 =				DATEADD(dd, -17, @EndDate)
SET									@Day19 =				DATEADD(dd, -18, @EndDate)
SET									@Day20 =				DATEADD(dd, -19, @EndDate)
SET									@Day21 =				DATEADD(dd, -20, @EndDate)
SET									@Day22 =				DATEADD(dd, -21, @EndDate)
SET									@Day23 =				DATEADD(dd, -22, @EndDate)
SET									@Day24 =				DATEADD(dd, -23, @EndDate)
SET									@Day25 =				DATEADD(dd, -24, @EndDate)
SET									@Day26 =				DATEADD(dd, -25, @EndDate)
SET									@Day27 =				DATEADD(dd, -26, @EndDate)
SET									@Day28 =				DATEADD(dd, -27, @EndDate)
SET									@Day29 =				DATEADD(dd, -28, @EndDate)
SET									@Day30 =				DATEADD(dd, -29, @EndDate)
SET									@Day31 =				DATEADD(dd, -30, @EndDate)
SET									@Day32 =				DATEADD(dd, -31, @EndDate)
SET									@Day33 =				DATEADD(dd, -32, @EndDate)
SET									@Day34 =				DATEADD(dd, -33, @EndDate)
SET									@Day35 =				DATEADD(dd, -34, @EndDate)
SET									@Day36 =				DATEADD(dd, -35, @EndDate)
SET									@Day37 =				DATEADD(dd, -36, @EndDate)
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'prod_121_Headers')
BEGIN
DROP TABLE							[dbo].[prod_121_Headers]
END
IF EXISTS							(SELECT * FROM sys.partition_schemes WHERE [name] = 'Ps_EndDate_By_Day')
BEGIN
DROP PARTITION SCHEME				[Ps_EndDate_By_Day]
END
IF EXISTS							(SELECT * FROM sys.partition_functions WHERE [name] = 'Pf_EndDate_By_Day')
BEGIN
DROP PARTITION FUNCTION				[Pf_EndDate_By_Day]
END
CREATE PARTITION FUNCTION			[Pf_EndDate_By_Day]				(Date)
AS RANGE							RIGHT
FOR VALUES							(N'' + CONVERT(nvarchar, @Day01) + 'T00:00:00.000'
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
									,N'' + CONVERT(nvarchar, @Day31) + 'T00:00:00.000'
									,N'' + CONVERT(nvarchar, @Day32) + 'T00:00:00.000'
									,N'' + CONVERT(nvarchar, @Day33) + 'T00:00:00.000'
									,N'' + CONVERT(nvarchar, @Day34) + 'T00:00:00.000'
									,N'' + CONVERT(nvarchar, @Day35) + 'T00:00:00.000'
									,N'' + CONVERT(nvarchar, @Day36) + 'T00:00:00.000'
									,N'' + CONVERT(nvarchar, @Day37) + 'T00:00:00.000'
)
CREATE PARTITION SCHEME				[Ps_EndDate_By_Day] 
AS PARTITION						[Pf_EndDate_By_Day]
ALL TO								([PRIMARY])
CREATE TABLE						[dbo].[prod_121_Headers]		(
									[RecordId]						[varchar](2)		NULL,
									[StoreNumber]					[int]				NULL,
									[TransactionType]				[int]				NOT NULL,
									[DayNumber]						[int]				NOT NULL,
									[ShiftNumber]					[int]				NOT NULL,
									[TransactionUID]				[int]				NOT NULL,
									[Aborted]						[bit]				NULL,
									[DeviceNumber]					[int]				NULL,
									[DeviceType]					[int]				NULL,
									[EmployeeNumber]				[int]				NULL,
									[EndDate]						[date]				NOT NULL,
									[EndTime]						[time](7)			NOT NULL,
									[StartDate]						[date]				NOT NULL,
									[StartTime]						[time](7)			NULL,
									[Status]						[tinyint]			NULL,
									[TotalAmount]					[money]				NULL,
									[TransactionCode]				[int]				NULL,
									[TransactionSequence]			[int]				NULL,
									[RewardMemberID]				[varchar](20)		NULL,
									[Header_Id]						[int] IDENTITY(1,1)	NOT NULL
)
ON									[Ps_EndDate_By_Day]				([EndDate])
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Prod_Headers]
ON									[dbo].[prod_121_Headers]
WITH	(							DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0
)
ON									[Ps_EndDate_By_Day]([EndDate])
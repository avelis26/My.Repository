USE							[7ELE]
GO
IF EXISTS					(SELECT * FROM sys.procedures WHERE name = 'usp_Update_Stg_Details_Table_ID')
BEGIN
DROP PROCEDURE				[dbo].[usp_Update_Tmp_Details_Table_ID]
END
GO
CREATE PROCEDURE			[dbo].[usp_Update_Tmp_Details_Table_ID]
AS
SET NOCOUNT ON

-- Update ID's in stg_TXNDetails_122 to match ID's in storeTable which will force the data to partition the data by store number

UPDATE						[dbo].[stg_TXNDetails_122]
SET							[ID] = (SELECT [dbo].[storeTable].[ID] FROM [dbo].[storeTable] WHERE [dbo].[stg_TXNDetails_122].[])

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

DECLARE @IntegerPartitionFunction nvarchar(max) = 
	N'CREATE PARTITION FUNCTION [Pf_Details_By_StoreNumber] (int) 
	AS RANGE RIGHT FOR VALUES (';  
DECLARE @i int = 1;
WHILE @i < (SELECT COUNT(DISTINCT(StoreNumber)) FROM STOR_Master)
BEGIN  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N', ';  
SET @i += 1;  
END  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N');';  
EXEC sp_executesql @IntegerPartitionFunction;  
GO 

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

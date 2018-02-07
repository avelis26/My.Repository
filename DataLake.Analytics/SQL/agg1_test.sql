USE									[7ELE]
GO
IF EXISTS							(SELECT * FROM sys.procedures WHERE [name] = 'usp_Aggregate_One_test')
BEGIN
DROP PROCEDURE						[dbo].[usp_Aggregate_One_test]
END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_Aggregate_One_test]
									@StartDate								date,
									@EndDate								date
AS
SET NOCOUNT ON
-- Rebuild tables rather than truncate to avoid errors
-- Should be really short
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'Agg1_DaypartAggregate_Backup')
BEGIN
DROP TABLE							[dbo].[Agg1_DaypartAggregate_Backup]
CREATE TABLE						[dbo].[Agg1_DaypartAggregate_Backup]	(
									[EndDate]								[date]						NULL,
									[StoreNumber]							[int]						NULL,
									[PSA_Cd]								[varchar](4)				NULL,
									[PSA_Ds]								[varchar](50)				NULL,
									[Category_Cd]							[varchar](5)				NULL,
									[Category_Ds]							[varchar](50)				NULL,
									[Member_Status]							[varchar](10)				NOT NULL,
									[Txn_Cnt_DayP1]							[int]						NULL,
									[Txn_Cnt_DayP2]							[int]						NULL,
									[Txn_Cnt_DayP3]							[int]						NULL,
									[Txn_Cnt_DayP4]							[int]						NULL,
									[Txn_Cnt_DayP5]							[int]						NULL,
									[Txn_Cnt_DayP6]							[int]						NULL,
									[Txn_Cnt_DayP7]							[int]						NULL,
									[Ttl_Amt_DayP1]							[money]						NOT NULL,
									[Ttl_Amt_DayP2]							[money]						NOT NULL,
									[Ttl_Amt_DayP3]							[money]						NOT NULL,
									[Ttl_Amt_DayP4]							[money]						NOT NULL,
									[Ttl_Amt_DayP5]							[money]						NOT NULL,
									[Ttl_Amt_DayP6]							[money]						NOT NULL,
									[Ttl_Amt_DayP7]							[money]						NOT NULL,
									[Ttl_Itm_Amt_DayP1]						[int]						NOT NULL,
									[Ttl_Itm_Amt_DayP2]						[int]						NOT NULL,
									[Ttl_Itm_Amt_DayP3]						[int]						NOT NULL,
									[Ttl_Itm_Amt_DayP4]						[int]						NOT NULL,
									[Ttl_Itm_Amt_DayP5]						[int]						NOT NULL,
									[Ttl_Itm_Amt_DayP6]						[int]						NOT NULL,
									[Ttl_Itm_Amt_DayP7]						[int]						NOT NULL)
ON									[PRIMARY]
END
IF EXISTS						(SELECT * FROM sys.tables WHERE [name] = 'tmp_query_data_joined')
BEGIN
DROP TABLE							[dbo].[tmp_query_data_joined]
CREATE TABLE						[dbo].[tmp_query_data_joined]			(
									[RecordId]								[varchar](2)				NULL,
									[StoreNumber]							[int]						NULL,
									[TransactionType]						[int]						NOT NULL,
									[DayNumber]								[int]						NOT NULL,
									[ShiftNumber]							[int]						NOT NULL,
									[TransactionUID]						[int]						NOT NULL,
									[Aborted]								[bit]						NULL,
									[DeviceNumber]							[int]						NULL,
									[DeviceType]							[int]						NULL,
									[EmployeeNumber]						[int]						NULL,
									[EndDate]								[date]						NULL,
									[EndTime]								[time](7)					NULL,
									[StartDate]								[date]						NOT NULL,
									[StartTime]								[time](7)					NULL,
									[Status]								[tinyint]					NULL,
									[TotalAmount]							[money]						NULL,
									[TransactionCode]						[int]						NULL,
									[TransactionSequence]					[int]						NULL,
									[RewardMemberID]						[varchar](20)				NULL,
									[Header_Id]								[int]						NOT NULL,
									[SequenceNumber]						[int]						NULL,
									[ProductNumber]							[int]						NULL,
									[PLUNumber]								[varchar](14)				NULL,
									[RecordAmount]							[money]						NULL,
									[RecordCount]							[int]						NULL,
									[RecordType]							[int]						NULL,
									[SizeIndx]								[int]						NULL,
									[ErrorCorrectionFlag]					[bit]						NULL,
									[PriceOverideFlag]						[bit]						NULL,
									[TaxableFlag]							[bit]						NULL,
									[VoidFlag]								[bit]						NULL,
									[RecommendedFlag]						[bit]						NULL,
									[PriceMultiple]							[int]						NULL,
									[CarryStatus]							[int]						NULL,
									[TaxOverideFlag]						[bit]						NULL,
									[PromotionCount]						[int]						NULL,
									[SalesPrice]							[money]						NULL,
									[MUBasePrice]							[money]						NULL,
									[HostItemId]							[varchar](20)				NULL,
									[CouponCount]							[int]						NULL,
									[Detail_Id]								[int]						NOT NULL)
ON									[PRIMARY]
END
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'tmp_query_data_FINAL')
BEGIN
DROP TABLE							[dbo].[tmp_query_data_FINAL]
CREATE TABLE						[dbo].[tmp_query_data_FINAL]			(
									[RecordId]								[varchar](2)				NULL,
									[StoreNumber]							[int]						NULL,
									[TransactionType]						[int]						NOT NULL,
									[DayNumber]								[int]						NOT NULL,
									[ShiftNumber]							[int]						NOT NULL,
									[TransactionUID]						[int]						NOT NULL,
									[Aborted]								[bit]						NULL,
									[DeviceNumber]							[int]						NULL,
									[DeviceType]							[int]						NULL,
									[EmployeeNumber]						[int]						NULL,
									[EndDate]								[date]						NULL,
									[EndTime]								[time](7)					NULL,
									[StartDate]								[date]						NOT NULL,
									[StartTime]								[time](7)					NULL,
									[Status]								[tinyint]					NULL,
									[TotalAmount]							[money]						NULL,
									[TransactionCode]						[int]						NULL,
									[TransactionSequence]					[int]						NULL,
									[RewardMemberID]						[varchar](20)				NULL,
									[Header_Id]								[int]						NOT NULL,
									[SequenceNumber]						[int]						NULL,
									[ProductNumber]							[int]						NULL,
									[PLUNumber]								[varchar](14)				NULL,
									[RecordAmount]							[money]						NULL,
									[RecordCount]							[int]						NULL,
									[RecordType]							[int]						NULL,
									[SizeIndx]								[int]						NULL,
									[ErrorCorrectionFlag]					[bit]						NULL,
									[PriceOverideFlag]						[bit]						NULL,
									[TaxableFlag]							[bit]						NULL,
									[VoidFlag]								[bit]						NULL,
									[RecommendedFlag]						[bit]						NULL,
									[PriceMultiple]							[int]						NULL,
									[CarryStatus]							[int]						NULL,
									[TaxOverideFlag]						[bit]						NULL,
									[PromotionCount]						[int]						NULL,
									[SalesPrice]							[money]						NULL,
									[MUBasePrice]							[money]						NULL,
									[HostItemId]							[varchar](20)				NULL,
									[CouponCount]							[int]						NULL,
									[Detail_Id]								[int]						NOT NULL,
									[PSA_Cd]								[varchar](4)				NULL,
									[PSA_Ds]								[varchar](50)				NULL,
									[Category_Cd]							[varchar](5)				NULL,
									[Category_Ds]							[varchar](50)				NULL,
									[SubCategory_Cd]						[varchar](4)				NULL)
ON									[PRIMARY]
END
-- Insert data to temp joined table
-- 01:23:56
INSERT INTO							[dbo].[tmp_query_data_joined]
SELECT								[tht].[RecordId],
									[tht].[StoreNumber],
									[tht].[TransactionType],
									[tht].[DayNumber],
									[tht].[ShiftNumber],
									[tht].[TransactionUID],
									[tht].[Aborted],
									[tht].[DeviceNumber],
									[tht].[DeviceType],
									[tht].[EmployeeNumber],
									[tht].[EndDate],
									[tht].[EndTime],
									[tht].[StartDate],
									[tht].[StartTime],
									[tht].[Status],
									[tht].[TotalAmount],
									[tht].[TransactionCode],
									[tht].[TransactionSequence],
									[tht].[RewardMemberID],
									[tht].[Header_Id],
									[pdt].[SequenceNumber],
									[pdt].[ProductNumber],
									[pdt].[PLUNumber],
									[pdt].[RecordAmount],
									[pdt].[RecordCount],
									[pdt].[RecordType],
									[pdt].[SizeIndx],
									[pdt].[ErrorCorrectionFlag],
									[pdt].[PriceOverideFlag],
									[pdt].[TaxableFlag],
									[pdt].[VoidFlag],
									[pdt].[RecommendedFlag],
									[pdt].[PriceMultiple],
									[pdt].[CarryStatus],
									[pdt].[TaxOverideFlag],
									[pdt].[PromotionCount],
									[pdt].[SalesPrice],
									[pdt].[MUBasePrice],
									[pdt].[HostItemId],
									[pdt].[CouponCount],
									[pdt].[Detail_Id]
FROM								[dbo].[prod_122_Details]				AS							[pdt]
INNER JOIN							[dbo].[prod_121_Headers]				AS							[tht]
ON									[pdt].[StoreNumber]						=							[tht].[StoreNumber]
AND									[pdt].[DayNumber]						=							[tht].[DayNumber]
AND									[pdt].[ShiftNumber]						=							[tht].[ShiftNumber]
AND									[pdt].[TransactionUID]					=							[tht].[TransactionUID]
WHERE								[tht].[EndDate]							BETWEEN						@StartDate AND @EndDate
-- Create index for tmp_query_data_joined
-- 00:10:36
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Tmp_Joined]
ON									[dbo].[tmp_query_data_joined]
WITH								(DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
ON									[PRIMARY]
-- Insert data to temp final table
-- 01:12:53
INSERT INTO							[dbo].[tmp_query_data_FINAL]
SELECT								[tqj].*,
									[ept].[PSA_Cd],
									[ept].[PSA_Ds],
									[ept].[Category_Cd],
									[ept].[Category_Ds],
									[ept].[SubCategory_Cd]
FROM								[dbo].[tmp_query_data_joined]			AS							[tqj]
INNER JOIN							[dbo].[ext_storeTable]					AS							[est]
ON									[tqj].[StoreNumber]						=							[est].[Store_Id]
INNER JOIN							[dbo].[ext_productTable]				AS							[ept]
ON									[ept].[slin]							=							[tqj].[ProductNumber]
AND									[ept].[UPC]								=							[tqj].[PLUNumber]
WHERE								[tqj].[RecordType]						IN							(1,5,18)
AND									[tqj].[Aborted]							=							0
AND									[tqj].[VoidFlag]						=							0
-- Create index for tmp_query_data_FINAL
-- 00:20:38
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Tmp_Final]
ON									[dbo].[tmp_query_data_FINAL]
WITH								(DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
ON									[PRIMARY]
-- Insert final results
-- time
INSERT INTO							[dbo].[Agg1_DaypartAggregate_Backup]
SELECT								[EndDate],
									[StoreNumber],
									[PSA_Cd],
									[PSA_Ds],
									[Category_Cd],
									[Category_Ds],
									[Member_Status] = CASE WHEN [RewardMemberID] IS NULL THEN 'Non-Member' ELSE 'Member' END,
									[Txn_Cnt_DayP1] = COUNT(DISTINCT(CASE WHEN [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' THEN (CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))END)),
									[Txn_Cnt_DayP2] = COUNT(DISTINCT(CASE WHEN [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' THEN (CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))END)),
									[Txn_Cnt_DayP3] = COUNT(DISTINCT(CASE WHEN [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' THEN (CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))END)),
									[Txn_Cnt_DayP4]	= COUNT(DISTINCT(CASE WHEN [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' THEN (CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))END)),
									[Txn_Cnt_DayP5]	= COUNT(DISTINCT(CASE WHEN [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' THEN (CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))END)),
									[Txn_Cnt_DayP6]	= COUNT(DISTINCT(CASE WHEN [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' THEN (CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))END)),
									[Txn_Cnt_DayP7]	= COUNT(DISTINCT(CASE WHEN [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' THEN (CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))END)),
									[Ttl_Amt_DayP1] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' THEN 0
										WHEN [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' AND [RecordType] IN (1) THEN [RecordAmount]
										END),0),
									[Ttl_Amt_DayP2] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' THEN 0
										WHEN [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' AND [RecordType] IN (1) THEN [RecordAmount]
										END),0),
									[Ttl_Amt_DayP3] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' THEN 0
										WHEN [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' AND [RecordType] IN (1) THEN [RecordAmount]
										END),0),
									[Ttl_Amt_DayP4] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' THEN 0
										WHEN [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' AND [RecordType] IN (1) THEN [RecordAmount]
										END),0),
									[Ttl_Amt_DayP5] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' THEN 0
										WHEN [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' AND [RecordType] IN (1) THEN [RecordAmount]
										END),0),
									[Ttl_Amt_DayP6] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' THEN 0
										WHEN [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' AND [RecordType] IN (1) THEN [RecordAmount]
										END),0),
									[Ttl_Amt_DayP7] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' THEN 0
										WHEN [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' AND [RecordType] IN (5) THEN (-1) * ABS([RecordAmount])
										WHEN [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' AND [RecordType] IN (1) THEN [RecordAmount]
										END),0),
									[Ttl_Itm_Amt_DayP1] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' THEN 0
										WHEN [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '00:00:00.0000000' AND [EndTime] < '06:00:00.0000000' AND [RecordType] IN (1) THEN [RecordCount]
										END),0),
									[Ttl_Itm_Amt_DayP2]	= ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' THEN 0
										WHEN [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '06:00:00.0000000' AND [EndTime] < '09:00:00.0000000' AND [RecordType] IN (1) THEN [RecordCount]
										END),0),
									[Ttl_Itm_Amt_DayP3] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' THEN 0
										WHEN [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '09:00:00.0000000' AND [EndTime] < '11:00:00.0000000' AND [RecordType] IN (1) THEN [RecordCount]
										END),0),
									[Ttl_Itm_Amt_DayP4] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' THEN 0
										WHEN [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '11:00:00.0000000' AND [EndTime] < '14:00:00.0000000' AND [RecordType] IN (1) THEN [RecordCount]
										END),0),
									[Ttl_Itm_Amt_DayP5] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' THEN 0
										WHEN [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '14:00:00.0000000' AND [EndTime] < '16:00:00.0000000' AND [RecordType] IN (1) THEN [RecordCount]
										END),0),
									[Ttl_Itm_Amt_DayP6] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' THEN 0
										WHEN [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' AND [RecordType] IN (5) THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '16:00:00.0000000' AND [EndTime] < '19:00:00.0000000' AND [RecordType] IN (1) THEN [RecordCount]
										END),0),
									[Ttl_Itm_Amt_DayP7] = ISNULL(SUM(CASE WHEN [RecordType] IN (18) AND [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' THEN 0
										WHEN [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' AND [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' AND [RecordType] IN (5) THEN (-1) * [RecordCount]
										WHEN [EndTime] >= '19:00:00.0000000' AND [EndTime] < '23:59:59.9999999' AND [RecordType] IN (1) THEN [RecordCount]
										END),0)
FROM								[dbo].[tmp_query_data_FINAL]
GROUP BY							[EndDate],
									[StoreNumber],
									[PSA_Cd],
									CASE WHEN [RewardMemberID] IS NULL THEN 'Non-Member' ELSE 'Member' END,
									[PSA_Ds],
									[Category_Cd],
									[Category_Ds]
GO
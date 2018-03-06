USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_Aggregate_1_1]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_Aggregate_1_1]
									@StartDate								date,
									@EndDate								date
AS
SET NOCOUNT ON
DROP TABLE IF EXISTS				[dbo].[Agg1_DaypartAggregate]
CREATE TABLE						[dbo].[Agg1_DaypartAggregate]	(
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
DROP TABLE IF EXISTS				[dbo].[tmp_query_data_joined]
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
									[CouponCount]							[int]						NULL)
ON									[PRIMARY]
DROP TABLE IF EXISTS				[dbo].[tmp_query_data_FINAL]
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
									[PSA_Cd]								[varchar](4)				NULL,
									[PSA_Ds]								[varchar](50)				NULL,
									[Category_Cd]							[varchar](5)				NULL,
									[Category_Ds]							[varchar](50)				NULL,
									[SubCategory_Cd]						[varchar](4)				NULL)
ON									[PRIMARY]
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
									[pdt].[CouponCount]
FROM								[dbo].[prod_122_Details]				AS							[pdt]
INNER JOIN							[dbo].[prod_121_Headers]				AS							[tht]
ON									[pdt].[StoreNumber]						=							[tht].[StoreNumber]
AND									[pdt].[DayNumber]						=							[tht].[DayNumber]
AND									[pdt].[ShiftNumber]						=							[tht].[ShiftNumber]
AND									[pdt].[TransactionUID]					=							[tht].[TransactionUID]
WHERE								[tht].[EndDate]							BETWEEN						@StartDate AND @EndDate
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Tmp_Joined]
ON									[dbo].[tmp_query_data_joined]
WITH								(DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
ON									[PRIMARY]
USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_CeoReport_1_5]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_CeoReport_1_5]
									@curr_yr_date								date
AS
SET NOCOUNT ON
DROP TABLE IF EXISTS				[dbo].[tmp_query_data_joined_CEO]
CREATE TABLE						[dbo].[tmp_query_data_joined_CEO]			(
									[RecordId]									[varchar](2)				NULL,
									[StoreNumber]								[int]						NULL,
									[TransactionType]							[int]						NOT NULL,
									[DayNumber]									[int]						NOT NULL,
									[ShiftNumber]								[int]						NOT NULL,
									[TransactionUID]							[int]						NOT NULL,
									[Aborted]									[bit]						NULL,
									[DeviceNumber]								[int]						NULL,
									[DeviceType]								[int]						NULL,
									[EmployeeNumber]							[int]						NULL,
									[EndDate]									[date]						NULL,
									[EndTime]									[time](7)					NULL,
									[StartDate]									[date]						NOT NULL,
									[StartTime]									[time](7)					NULL,
									[Status]									[tinyint]					NULL,
									[TotalAmount]								[money]						NULL,
									[TransactionCode]							[int]						NULL,
									[TransactionSequence]						[int]						NULL,
									[RewardMemberID]							[varchar](20)				NULL,
									[SequenceNumber]							[int]						NULL,
									[ProductNumber]								[int]						NULL,
									[PLUNumber]									[varchar](14)				NULL,
									[RecordAmount]								[money]						NULL,
									[RecordCount]								[int]						NULL,
									[RecordType]								[int]						NULL,
									[SizeIndx]									[int]						NULL,
									[ErrorCorrectionFlag]						[bit]						NULL,
									[PriceOverideFlag]							[bit]						NULL,
									[TaxableFlag]								[bit]						NULL,
									[VoidFlag]									[bit]						NULL,
									[RecommendedFlag]							[bit]						NULL,
									[PriceMultiple]								[int]						NULL,
									[CarryStatus]								[int]						NULL,
									[TaxOverideFlag]							[bit]						NULL,
									[PromotionCount]							[int]						NULL,
									[SalesPrice]								[money]						NULL,
									[MUBasePrice]								[money]						NULL,
									[HostItemId]								[varchar](20)				NULL,
									[CouponCount]								[int]						NULL)
ON									[PRIMARY]
DROP TABLE IF EXISTS				[dbo].[tmp_query_data_FINAL_CEO]
CREATE TABLE						[dbo].[tmp_query_data_FINAL_CEO]			(
									[RecordId]									[varchar](2)				NULL,
									[StoreNumber]								[int]						NULL,
									[TransactionType]							[int]						NOT NULL,
									[DayNumber]									[int]						NOT NULL,
									[ShiftNumber]								[int]						NOT NULL,
									[TransactionUID]							[int]						NOT NULL,
									[Aborted]									[bit]						NULL,
									[DeviceNumber]								[int]						NULL,
									[DeviceType]								[int]						NULL,
									[EmployeeNumber]							[int]						NULL,
									[EndDate]									[date]						NULL,
									[EndTime]									[time](7)					NULL,
									[StartDate]									[date]						NOT NULL,
									[StartTime]									[time](7)					NULL,
									[Status]									[tinyint]					NULL,
									[TotalAmount]								[money]						NULL,
									[TransactionCode]							[int]						NULL,
									[TransactionSequence]						[int]						NULL,
									[RewardMemberID]							[varchar](20)				NULL,
									[SequenceNumber]							[int]						NULL,
									[ProductNumber]								[int]						NULL,
									[PLUNumber]									[varchar](14)				NULL,
									[RecordAmount]								[money]						NULL,
									[RecordCount]								[int]						NULL,
									[RecordType]								[int]						NULL,
									[SizeIndx]									[int]						NULL,
									[ErrorCorrectionFlag]						[bit]						NULL,
									[PriceOverideFlag]							[bit]						NULL,
									[TaxableFlag]								[bit]						NULL,
									[VoidFlag]									[bit]						NULL,
									[RecommendedFlag]							[bit]						NULL,
									[PriceMultiple]								[int]						NULL,
									[CarryStatus]								[int]						NULL,
									[TaxOverideFlag]							[bit]						NULL,
									[PromotionCount]							[int]						NULL,
									[SalesPrice]								[money]						NULL,
									[MUBasePrice]								[money]						NULL,
									[HostItemId]								[varchar](20)				NULL,
									[CouponCount]								[int]						NULL,
									[PSA_Cd]									[varchar](4)				NULL,
									[PSA_Ds]									[varchar](50)				NULL,
									[Category_Cd]								[varchar](5)				NULL,
									[Category_Ds]								[varchar](50)				NULL,
									[SubCategory_Cd]							[varchar](4)				NULL,
									[country_cd]								[char](2)					NULL)
ON									[PRIMARY]
DROP TABLE IF EXISTS				[dbo].[CEO_DB_FINAL]
CREATE TABLE						[dbo].[CEO_DB_FINAL]						(
									[EndDate]									[varchar](10)				NULL,
									[StoreNumber]								[int]						NOT NULL,
									[Member_Status]								[varchar](10)				NOT NULL,
									[txn_cnt]									[int]						NULL,
									[totalamount]								[money]						NULL,
									[country_cd]								[char](2)					NULL)
ON									[PRIMARY]	
DROP TABLE IF EXISTS				[dbo].[CEO_StoreTxnItems]
CREATE TABLE						[dbo].[CEO_StoreTxnItems]					(
									[EndDate]									[date]						NULL,
									[StoreNumber]								[int]						NOT NULL,
									[Member_Status]								[varchar](10)				NOT NULL,
									[TXN_Cnt]									[int]						NULL,
									[ItemCount]									[int]						NULL,
									[TotalAmount]								[money]						NULL,
									[Unique_member_count]						[int]						NULL,
									[country_cd]								[char](2)					NULL)
ON									[PRIMARY]
INSERT INTO							[dbo].[tmp_query_data_joined_CEO]
SELECT								[th].[RecordId],
									[th].[StoreNumber],
									[th].[TransactionType],
									[th].[DayNumber],
									[th].[ShiftNumber],
									[th].[TransactionUID],
									[Aborted],
									[DeviceNumber],
									[DeviceType],
									[EmployeeNumber],
									[th].[EndDate],
									[EndTime],
									[StartDate],
									[StartTime],
									[Status],
									[TotalAmount],
									[TransactionCode],
									[TransactionSequence],
									[RewardMemberID],
									[SequenceNumber],
									[ProductNumber],
									[PLUNumber],
									[RecordAmount],
									[RecordCount],
									[RecordType],
									[SizeIndx],
									[ErrorCorrectionFlag],
									[PriceOverideFlag],
									[TaxableFlag],
									[VoidFlag],
									[RecommendedFlag],
									[PriceMultiple],
									[CarryStatus],
									[TaxOverideFlag],
									[PromotionCount],
									[SalesPrice],
									[MUBasePrice],
									[HostItemId],
									[CouponCount]
FROM								[dbo].[prod_122_Details]					AS							[td]
INNER JOIN							[dbo].[prod_121_Headers]					AS							[th]
ON									[td].[StoreNumber]							=							[th].[StoreNumber]
AND									[td].[DayNumber]							=							[th].[DayNumber]
AND									[td].[ShiftNumber]							=							[th].[ShiftNumber]
AND									[td].[TransactionUID]						=							[th].[TransactionUID]
WHERE								[th].[EndDate]								BETWEEN						DATEADD(day, -6, @curr_yr_date) AND @curr_yr_date
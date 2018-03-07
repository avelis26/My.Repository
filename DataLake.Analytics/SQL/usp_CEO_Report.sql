USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_CEO_Report]
GO
CREATE PROCEDURE					[dbo].[usp_CEO_Report]
									@curr_yr_date								date,
									@last_yr_date								date
AS
SET NOCOUNT ON
EXEC								[dbo].[usp_Copy_Store_Product_Locally]
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
WHERE								[th].[EndDate]								=							@curr_yr_date
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
FROM								[dbo].[prod_122_Details_CEO]				AS							[td]
INNER JOIN							[dbo].[prod_121_Headers_CEO]				AS							[th]
ON									[td].[StoreNumber]							=							[th].[StoreNumber]
AND									[td].[DayNumber]							=							[th].[DayNumber]
AND									[td].[ShiftNumber]							=							[th].[ShiftNumber]
AND									[td].[TransactionUID]						=							[th].[TransactionUID]
WHERE								[th].[EndDate]								=							@last_yr_date
INSERT INTO							[dbo].[tmp_query_data_FINAL_CEO]
SELECT DISTINCT						[x].*,
									[PSA_Cd],
									[PSA_Ds],
									[Category_Cd],
									[Category_Ds],
									[SubCategory_Cd],
									[Country_Cd]
FROM								[dbo].[tmp_query_data_joined_CEO]			AS							[x]
INNER JOIN							[dbo].[ext_storeTable]						AS							[sm]
ON									[x].[StoreNumber]							=							[sm].[Store_Id]
INNER JOIN							[dbo].[ext_productTable]					AS							[pr]
ON									[slin]										=							[x].[ProductNumber]
AND									[UPC]										=							[x].[PLUNumber]
WHERE								[x].[RecordType]							IN							(1,5,18)
AND									[x].[Aborted]								=							0
AND									[x].[VoidFlag]								=							0
INSERT INTO							[dbo].[CEO_StoreTxnItems]					(
									[EndDate],
									[StoreNumber],
									[Country_Cd],
									[Member_Status],
									[Txn_Cnt],
									[ItemCount],
									[TotalAmount],
									[Unique_member_count]
)
SELECT								[EndDate],
									[StoreNumber],
									[Country_Cd],
									CASE
									WHEN [RewardMemberID]						IS NULL
										THEN 'Non-Member'						ELSE						'Member'
									END											AS							[MemberStatus],
									COUNT(
										DISTINCT(
											CONCAT(
												[StoreNumber],
												[DayNumber],
												[ShiftNumber],
												[TransactionUID],
												[TransactionSequence]
											)
										)
									)											AS							[TXN_Cnt],
									SUM(
										CASE
											WHEN [RecordType]					IN							(18)
											THEN 0
											WHEN [RecordType]					IN							(1) AND [SubCategory_Cd] = '99'
											THEN (-1) * ABS([RecordCount])
											WHEN [RecordType]					IN							(5)
											THEN (-1) * ABS([RecordCount])
											WHEN [RecordType]					IN							(1)
											THEN [RecordCount]
										END
									)											AS							[ItemCount],
									SUM(
										CASE
											WHEN [RecordType]					IN							(18)
											THEN 0
											WHEN [RecordType]					IN							(1) AND [SubCategory_Cd] = '99'
											THEN (-1) * ABS([RecordAmount])
											WHEN [RecordType]					IN							(5)
											THEN (-1) * ABS([RecordAmount])
											WHEN [RecordType]					IN							(1)
											THEN [RecordAmount]
										END
									)											AS							[TotalAmount],
									COUNT(
										DISTINCT [RewardMemberID]
									)											AS							[Unique_member_count]
FROM								[dbo].[tmp_query_data_FINAL_CEO]	
GROUP BY							CASE
										WHEN [RewardMemberID]					IS NULL
										THEN 'Non-Member'						ELSE						'Member'
									END,
									[StoreNumber],
									[Country_Cd],
									[EndDate]
INSERT INTO							[dbo].[CEO_DB_FINAL]						(
									[EndDate],
									[StoreNumber],
									[Country_Cd],
									[Member_Status],
									[txn_cnt],
									[totalamount]
)
SELECT								[EndDate],
									[agg].[StoreNumber],
									[Country_Cd],
									[agg].[Member_Status],
									SUM(
										[txn_cnt]
									)											AS							[txn_cnt],
									SUM(
										[totalamount]
									)											AS							[totalamount]
FROM								[dbo].[CEO_StoreTxnItems]					AS							[agg]
GROUP BY							[agg].[EndDate],
									[agg].[StoreNumber],
									[Country_Cd],
									[agg].[Member_Status]
UNION ALL
SELECT								[EndDate],
									[agg].[StoreNumber],
									[Country_Cd],
									'Total'										AS							[Member_Status],
									SUM(
										[txn_cnt]
									)											AS							[txn_cnt],
									SUM(
										[totalamount]
									)											AS							[totalamount]
FROM								[dbo].[CEO_StoreTxnItems]					AS							[agg]
GROUP BY							[agg].[EndDate],
									[Country_Cd],
									[agg].[StoreNumber]

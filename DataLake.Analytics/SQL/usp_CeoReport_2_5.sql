USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_CeoReport_2_5]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_CeoReport_2_5]
									@last_yr_date								date
AS
SET NOCOUNT ON
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
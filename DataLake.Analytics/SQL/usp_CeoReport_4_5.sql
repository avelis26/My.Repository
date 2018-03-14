USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_CeoReport_4_5]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_CeoReport_4_5]
									@curr_yr_date								date,
									@last_yr_date								date
AS
SET NOCOUNT ON
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
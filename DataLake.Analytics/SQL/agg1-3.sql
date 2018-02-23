USE									[7ELE]
GO
IF EXISTS							(SELECT * FROM sys.procedures WHERE [name] = 'usp_Aggregate_1_3')
BEGIN
DROP PROCEDURE						[dbo].[usp_Aggregate_1_3]
END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_Aggregate_1_3]
									@StartDate								date,
									@EndDate								date
AS
SET NOCOUNT ON
INSERT INTO							[dbo].[Agg1_DaypartAggregate]
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
WHERE								[EndDate]							BETWEEN						@StartDate AND @EndDate
GROUP BY							[EndDate],
									[StoreNumber],
									[PSA_Cd],
									CASE WHEN [RewardMemberID] IS NULL THEN 'Non-Member' ELSE 'Member' END,
									[PSA_Ds],
									[Category_Cd],
									[Category_Ds]
USE									[7ELE]
GO
IF EXISTS							(SELECT * FROM sys.procedures WHERE [name] = 'usp_Aggregate_Two_test')
BEGIN
DROP PROCEDURE						[dbo].[usp_Aggregate_Two_test]
END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_Aggregate_Two_test]
AS
SET NOCOUNT ON
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'Agg2_StoreTxnItems_Backup')
BEGIN
DROP TABLE							[dbo].[Agg2_StoreTxnItems_Backup]
CREATE TABLE						[dbo].[Agg2_StoreTxnItems_Backup]		(
									[EndDate]								[date]						NULL,
									[StoreNumber]							[int]						NOT NULL,
									[Member_Status]							[varchar](10)				NOT NULL,
									[TXN_Cnt]								[int]						NULL,
									[ItemCount]								[int]						NULL,
									[TotalAmount]							[money]						NULL,
									[Unique_member_count]					[int]						NULL)
ON									[PRIMARY]
END
INSERT INTO							[dbo].[Agg2_StoreTxnItems_Backup]		(
									[EndDate],
									[StoreNumber],
									[Member_Status],
									[Txn_Cnt],
									[ItemCount],
									[TotalAmount],
									[Unique_member_count])
SELECT								[EndDate],
									[StoreNumber],
									CASE WHEN [RewardMemberID] IS NULL THEN 'Non-Member' ELSE 'Member' END AS [MemberStatus],
									COUNT(DISTINCT(CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID],[TransactionSequence]))) AS [TXN_Cnt],
									SUM(CASE WHEN [RecordType] IN (18) THEN 0
										WHEN  [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordCount]) 
										WHEN  [RecordType] IN (5) THEN (-1) * ABS([RecordCount]) 
										WHEN  [RecordType] IN (1) THEN [RecordCount] 
										END) AS [ItemCount],
									SUM(CASE WHEN RecordType IN (18) THEN 0
										WHEN [RecordType] IN (1) AND [SubCategory_Cd] = '99' THEN (-1) * ABS([RecordAmount]) 
										WHEN [RecordType] IN (5) THEN (-1) * ABS([RecordAmount]) 
										WHEN [RecordType] IN (1) THEN [RecordAmount] 
										END) AS [TotalAmount],
									COUNT(DISTINCT [RewardMemberID]) AS [Unique_member_count]
FROM								[dbo].[tmp_query_data_FINAL]
GROUP BY							CASE WHEN [RewardMemberID] IS NULL THEN 'Non-Member' ELSE 'Member' END,
									[StoreNumber],
									[EndDate]
GO
USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_CeoReport_5_5]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_CeoReport_5_5]
AS
SET NOCOUNT ON
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

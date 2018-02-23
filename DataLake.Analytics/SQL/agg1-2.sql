USE									[7ELE]
GO
IF EXISTS							(SELECT * FROM sys.procedures WHERE [name] = 'usp_Aggregate_1_2')
BEGIN
DROP PROCEDURE						[dbo].[usp_Aggregate_1_2]
END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_Aggregate_1_2]
AS
SET NOCOUNT ON
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
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Tmp_Final]
ON									[dbo].[tmp_query_data_FINAL]
WITH								(DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
ON									[PRIMARY]
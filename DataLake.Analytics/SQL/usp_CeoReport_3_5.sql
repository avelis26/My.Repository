USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_CeoReport_3_5]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_CeoReport_3_5]
									@curr_yr_date								date,
									@last_yr_date								date
AS
SET NOCOUNT ON
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
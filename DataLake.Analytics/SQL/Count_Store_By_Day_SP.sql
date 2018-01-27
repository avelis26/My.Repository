USE								[7ELE]
GO
IF EXISTS						(SELECT * FROM sys.procedures WHERE name = 'usp_Copy_Store_Product_Locally')
BEGIN
DROP PROCEDURE					[dbo].[usp_Copy_Store_Product_Locally]
END
GO
CREATE PROCEDURE				[dbo].[usp_Copy_Store_Product_Locally]
AS
SET NOCOUNT ON
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
TRUNCATE TABLE					[dbo].[ext_productTable]
TRUNCATE TABLE					[dbo].[ext_storeTable]
INSERT INTO						[dbo].[ext_storeTable]
SELECT							[SM].*,
								[CA].[Country_Cd]
FROM							[dbo].[STOR_Master]								AS							[SM]
INNER JOIN						[dbo].[COMN_Address]							AS							[CA]
ON								[SM].[PhysicalAddress_Id]		=				[CA].[Address_Id]
WHERE							(
	(
								[CA].[Country_Cd]				=				'US'
		AND						[SM].[Owner_Cd]					<>				'X'
		AND						[SM].[Owner_Cd]					IS				NOT NULL
		AND						[SM].[Active_Fg]				=				'1'
		AND						[SM].[Zone_Cd]					NOT IN			(0, 72699, 72935)
		AND						[SM].[Zone_Cd]					IS				NOT NULL
		AND						[SM].[Dark_Fg]					<>				'1'
	)
		OR
	(
								[CA].[Country_Cd]				=				'CA'
		AND						[SM].[Active_Fg]				=				'1'
		AND						[SM].[Zone_Cd]					NOT IN			(0, 72699)
		AND						[SM].[Zone_Cd]					IS				NOT NULL
		AND						[SM].[Dark_Fg]					<>				'1'
	)
)
INSERT INTO						[dbo].[ext_productTable]		(
								[ProductMaster_Id],
								[SLIN],
								[UPC],
								[Category_Cd],
								[Category_Ds],
								[Depart_Cd],
								[Manufacturer_Cd],
								[Manufacturer_Nm],
								[PSA_Cd],
								[PSA_Ds],
								[Item_Ds],
								[SubCategory_Cd],
								[SubCategory_Ds],
								[VerticalClass_Cd],
								[VerticalClass_Ds],
								[CorpBrand],
								[UPCType_Cd],
								[AgeRestricted_Fg],
								[CurrentImport_Id],
								[OriginalImport_Id],
								[Modified_Dttm],
								[Created_Dttm]
)
SELECT							[ProductMaster_Id],
								[SLIN],
								SUBSTRING([UPC], PATINDEX('%[^0]%', [UPC] + ' '), LEN([UPC])),
								[Category_Cd],
								[Category_Ds],
								[Depart_Cd],
								[Manufacturer_Cd],
								[Manufacturer_Nm],
								[PSA_Cd],
								[PSA_Ds],
								[Item_Ds],
								[SubCategory_Cd],
								[SubCategory_Ds],
								[VerticalClass_Cd],
								[VerticalClass_Ds],
								[CorpBrand],
								[UPCType_Cd],
								[AgeRestricted_Fg],
								[CurrentImport_Id],
								[OriginalImport_Id],
								[Modified_Dttm],
								[Created_Dttm]
FROM							[dbo].[TRNS_ProductMaster]
WHERE							[Depart_Cd]						NOT IN			('340202', '340101', '341003', '340821', '341103')

USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_Create_Details_EndDate]
GO
CREATE PROCEDURE					[dbo].[usp_Create_Details_EndDate]
AS
SET NOCOUNT ON
UPDATE								[d]
SET									[EndDate]						=		[h].[EndDate]
FROM								[dbo].[preProd_121_Headers]		AS		[h]
JOIN								[dbo].[preProd_122_Details]		AS		[d]
ON									[h].[StoreNumber]				=		[d].[StoreNumber]
AND									[h].[DayNumber]					=		[d].[DayNumber]
AND									[h].[ShiftNumber]				=		[d].[ShiftNumber]
AND									[h].[TransactionUID]			=		[d].[TransactionUID] 
GO

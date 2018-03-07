USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_Delete_Old_Data]
GO
CREATE PROCEDURE					[dbo].[usp_Delete_Old_Data]
AS
SET NOCOUNT ON
DECLARE								@present								date
DECLARE								@past									date
SET									@present								=							GETDATE()
SET									@past									=							DATEADD(day, -32, @present)
DELETE								[pdt]
FROM								[dbo].[prod_122_Details]				AS							[pdt]
INNER JOIN							[dbo].[prod_121_Headers]				AS							[tht]
ON									[pdt].[StoreNumber]						=							[tht].[StoreNumber]
AND									[pdt].[DayNumber]						=							[tht].[DayNumber]
AND									[pdt].[ShiftNumber]						=							[tht].[ShiftNumber]
AND									[pdt].[TransactionUID]					=							[tht].[TransactionUID]
WHERE								[tht].[EndDate]							NOT BETWEEN					@past AND @present
DELETE								[tht]
FROM								[dbo].[prod_121_Headers]				AS							[tht]
WHERE								[tht].[EndDate]							NOT BETWEEN					@past AND @present

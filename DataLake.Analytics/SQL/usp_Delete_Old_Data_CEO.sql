USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_Delete_Old_Data_CEO]
GO
CREATE PROCEDURE					[dbo].[usp_Delete_Old_Data_CEO]
AS
SET NOCOUNT ON
DECLARE								@past									date
DECLARE								@present								date
SET									@past									=							DATEADD(day, -368, GETDATE())
SET									@present								=							DATEADD(day, 14, @past)
DELETE								[pdt]
FROM								[dbo].[prod_122_Details_CEO]			AS							[pdt]
INNER JOIN							[dbo].[prod_121_Headers_CEO]			AS							[tht]
ON									[pdt].[StoreNumber]						=							[tht].[StoreNumber]
AND									[pdt].[DayNumber]						=							[tht].[DayNumber]
AND									[pdt].[ShiftNumber]						=							[tht].[ShiftNumber]
AND									[pdt].[TransactionUID]					=							[tht].[TransactionUID]
WHERE								[tht].[EndDate]							NOT BETWEEN					@past AND @present
DELETE								[tht]
FROM								[dbo].[prod_121_Headers_CEO]			AS							[tht]
WHERE								[tht].[EndDate]							NOT BETWEEN					@past AND @present

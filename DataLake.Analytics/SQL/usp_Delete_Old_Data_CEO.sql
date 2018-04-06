USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_Delete_Old_Data_CEO]
GO
CREATE PROCEDURE					[dbo].[usp_Delete_Old_Data_CEO]
AS
SET NOCOUNT ON
DECLARE								@present								date
DECLARE								@past									date
SET									@present								=							DATEADD(day, -364, GETDATE()) 
SET									@past									=							DATEADD(day, -32, @present)
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

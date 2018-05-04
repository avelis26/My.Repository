USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Delete_Old_Data_CEO]
GO
CREATE PROCEDURE				[dbo].[usp_Delete_Old_Data_CEO]
AS
SET NOCOUNT ON
DECLARE							@past								date
DECLARE							@present							date
SET								@past								=				DATEADD(day, -368, GETDATE())
SET								@present							=				DATEADD(day, 14, @past)
DELETE							[det]
FROM							[dbo].[prod_122_Details_CEO]		AS				[det]
INNER JOIN						[dbo].[prod_121_Headers_CEO]		AS				[hea]
ON								[det].[StoreNumber]					=				[hea].[StoreNumber]
AND								[det].[DayNumber]					=				[hea].[DayNumber]
AND								[det].[ShiftNumber]					=				[hea].[ShiftNumber]
AND								[det].[TransactionUID]				=				[hea].[TransactionUID]
WHERE							[hea].[EndDate]						NOT BETWEEN		@past AND @present
DELETE							[hea]
FROM							[dbo].[prod_121_Headers_CEO]		AS				[hea]
WHERE							[hea].[EndDate]						NOT BETWEEN		@past AND @present

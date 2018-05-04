USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Delete_Old_Data]
GO
CREATE PROCEDURE				[dbo].[usp_Delete_Old_Data]		
AS
SET NOCOUNT ON
DECLARE							@present						date
DECLARE							@past							date
SET								@present						=				GETDATE()
SET								@past							=				DATEADD(day, -32, @present)
DELETE							[det]
FROM							[dbo].[prod_122_Details]		AS				[det]
INNER JOIN						[dbo].[prod_121_Headers]		AS				[hea]
ON								[det].[StoreNumber]				=				[hea].[StoreNumber]
AND								[det].[DayNumber]				=				[hea].[DayNumber]
AND								[det].[ShiftNumber]				=				[hea].[ShiftNumber]
AND								[det].[TransactionUID]			=				[hea].[TransactionUID]
WHERE							[hea].[EndDate]					NOT BETWEEN		@past AND @present
DELETE							[hea]
FROM							[dbo].[prod_121_Headers]		AS				[hea]
WHERE							[hea].[EndDate]					NOT BETWEEN		@past AND @present

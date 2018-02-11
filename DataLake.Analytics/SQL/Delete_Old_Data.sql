USE								[7ELE]
GO
IF EXISTS						(SELECT * FROM sys.procedures WHERE [name] = 'usp_Delete_Old_Data')
BEGIN
DROP PROCEDURE					[dbo].[usp_Delete_Old_Data]
END
GO
CREATE PROCEDURE				[dbo].[usp_Delete_Old_Data]
								@EndDate								date,	
								@Table									varchar
AS
SET NOCOUNT ON
DELETE FROM						[dbo].[@Table]
WHERE							[EndDate] < DATEADD(day, -31, @EndDate)
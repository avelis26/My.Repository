USE								[7ELE]
GO
IF EXISTS						(SELECT * FROM sys.procedures WHERE [name] = 'usp_Truncate_Staging')
BEGIN
DROP PROCEDURE					[dbo].[usp_Truncate_Staging]
END
GO
CREATE PROCEDURE				[dbo].[usp_Truncate_Staging]
AS
SET NOCOUNT ON
TRUNCATE TABLE					[dbo].[stg_122_Details];
TRUNCATE TABLE					[dbo].[stg_121_Headers];

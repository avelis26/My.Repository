USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Update_Statistics]
GO
CREATE PROCEDURE				[dbo].[usp_Update_Statistics]
AS
SET NOCOUNT ON
DECLARE							@tableSchema							NVARCHAR(128)
DECLARE							@tableName								NVARCHAR(128)
DECLARE							@Statement								NVARCHAR(300) 
DECLARE							updatestats								CURSOR
FOR
SELECT							table_schema,
								table_name  
FROM							information_schema.tables
WHERE							[TABLE_NAME] LIKE 'prod_121_Headers%'
OR								[TABLE_NAME] LIKE 'prod_122_Details%'
OR								[TABLE_NAME] LIKE 'ext_productTable%'
OR								[TABLE_NAME] LIKE 'ext_storeTable%'
OPEN							updatestats
FETCH NEXT FROM					updatestats
INTO							@tableSchema,
								@tableName
WHILE							(@@FETCH_STATUS = 0)
BEGIN
SET								@Statement =							'UPDATE STATISTICS '  + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + ' WITH FULLSCAN'
EXEC							sp_executesql @Statement
FETCH NEXT FROM					updatestats
INTO							@tableSchema,
								@tableName
END
CLOSE							updatestats
DEALLOCATE						updatestats
ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE

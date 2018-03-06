USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Database_Maintenance]
GO
CREATE PROCEDURE				[dbo].[usp_Database_Maintenance]
AS
SET NOCOUNT ON
DECLARE							rebuildindexes							CURSOR FOR
SELECT							table_schema,
								table_name  
FROM							information_schema.tables
WHERE							TABLE_TYPE								=							'BASE TABLE'
OPEN							rebuildindexes
DECLARE							@tableSchema							NVARCHAR(128)
DECLARE							@tableName								NVARCHAR(128)
DECLARE							@Statement								NVARCHAR(300) 
FETCH NEXT FROM					rebuildindexes
INTO							@tableSchema,
								@tableName
WHILE							(@@FETCH_STATUS = 0)
BEGIN
SET								@Statement								=							'ALTER INDEX ALL ON '  + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + ' REBUILD'
EXEC							sp_executesql @Statement
FETCH NEXT FROM					rebuildindexes
INTO							@tableSchema,
								@tableName
END 
CLOSE							rebuildindexes
DEALLOCATE						rebuildindexes 
DECLARE							updatestats								CURSOR FOR
SELECT							table_schema,
								table_name  
FROM							information_schema.tables
WHERE							TABLE_TYPE								=							'BASE TABLE'
OPEN							updatestats
FETCH NEXT FROM					updatestats
INTO							@tableSchema,
								@tableName
WHILE							(@@FETCH_STATUS = 0)
BEGIN
SET								@Statement								=							'UPDATE STATISTICS '  + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + ' WITH FULLSCAN'
EXEC							sp_executesql @Statement
FETCH NEXT FROM					updatestats
INTO							@tableSchema,
								@tableName
END
CLOSE							updatestats
DEALLOCATE						updatestats
ALTER DATABASE SCOPED CONFIGURATION CLEAR	PROCEDURE_CACHE

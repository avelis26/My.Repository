USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Rebuild_Indexs]
GO
CREATE PROCEDURE				[dbo].[usp_Rebuild_Indexs]
AS
SET NOCOUNT ON
DECLARE							rebuildindexes							CURSOR
FOR
SELECT							table_schema,
								table_name
FROM							information_schema.tables
WHERE							[TABLE_NAME] LIKE 'tmp%'
OR								[TABLE_NAME] LIKE 'Agg%'
OR								[TABLE_NAME] LIKE 'ext%'
OR								[TABLE_NAME] LIKE 'prod%'
OR								[TABLE_NAME] LIKE 'stg%'
OR								[TABLE_NAME] LIKE 'CEO%'
OPEN							rebuildindexes
DECLARE							@tableSchema							NVARCHAR(128)
DECLARE							@tableName								NVARCHAR(128)
DECLARE							@Statement								NVARCHAR(300) 
FETCH NEXT FROM					rebuildindexes
INTO							@tableSchema,
								@tableName
WHILE							(@@FETCH_STATUS = 0)
BEGIN
SET								@Statement =							'ALTER INDEX ALL ON '  + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + ' REBUILD'
EXEC							sp_executesql @Statement
FETCH NEXT FROM					rebuildindexes
INTO							@tableSchema,
								@tableName
END 
CLOSE							rebuildindexes
DEALLOCATE						rebuildindexes 
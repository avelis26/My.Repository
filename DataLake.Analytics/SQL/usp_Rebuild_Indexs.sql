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
WHERE							[TABLE_NAME] LIKE 'prod_121_Headers%'
OR								[TABLE_NAME] LIKE 'prod_122_Details%'
OR								[TABLE_NAME] LIKE 'ext_productTable%'
OR								[TABLE_NAME] LIKE 'ext_storeTable%'
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
USE									[7ELE]
GO
DROP PROCEDURE IF EXISTS			[dbo].[usp_Shrink_Log]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE					[dbo].[usp_Shrink_Log]
AS
SET NOCOUNT ON
DECLARE								@return_status int
DBCC SHRINKFILE						(
									log,
									0
									)
WITH NO_INFOMSGS
SELECT								[file_id],
									[name],
									[type_desc],
									[size] AS [pages],
									[max_size] AS [max_pages],
									([size] * 8) / 1048576 AS [size_GB],
									([max_size] * 8) / 1048576 AS [max_size_GB]
FROM								sys.database_files
WHERE								[file_id] = 2
SET									@return_status = (SELECT ([size] * 8) / 1048576 FROM sys.database_files WHERE [file_id] = 2)
RETURN								@return_status
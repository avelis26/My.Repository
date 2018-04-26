USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Staging_To_Prod_Headers]
GO
CREATE PROCEDURE				[dbo].[usp_Staging_To_Prod_Headers]
AS
SET NOCOUNT ON
INSERT INTO						[dbo].[prod_121_Headers]
(
								[RecordId],
								[StoreNumber],
								[TransactionType],
								[DayNumber],
								[ShiftNumber],
								[TransactionUID],
								[Aborted],
								[DeviceNumber],
								[DeviceType],
								[EmployeeNumber],
								[EndDate],
								[EndTime],
								[StartDate],
								[StartTime],
								[Status],
								[TotalAmount],
								[TransactionCode],
								[TransactionSequence],
								[RewardMemberID],
								[RawFileName],
								[LineNo],
								[StageInsertStamp],
								[CsvFile],
								[DataLakeFolder],
								[Pk]
)
SELECT
								[RecordId],
								[StoreNumber],
								[TransactionType],
								[DayNumber],
								[ShiftNumber],
								[TransactionUID],
								[Aborted],
								[DeviceNumber],
								[DeviceType],
								[EmployeeNumber],
								[EndDate],
								[EndTime],
								[StartDate],
								[StartTime],
								[Status],
								[TotalAmount],
								[TransactionCode],
								[TransactionSequence],
								[RewardMemberID],
								[RawFileName],
								[LineNo],
								[StageInsertStamp],
								[CsvFile],
								[DataLakeFolder],
								[Pk]
FROM							[dbo].[preProd_121_Headers]
GO

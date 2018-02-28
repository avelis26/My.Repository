SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------- PROD HEADERS
IF EXISTS							(
SELECT								*
FROM								sys.tables
WHERE								[name] = 'prod_121_Headers'
)
BEGIN
DROP TABLE							[dbo].[prod_121_Headers]
END
CREATE TABLE						[dbo].[prod_121_Headers]				(
									[RecordId]								[varchar](2)														NULL,
									[StoreNumber]							[int]																NULL,
									[TransactionType]						[int]																NOT NULL,
									[DayNumber]								[int]																NOT NULL,
									[ShiftNumber]							[int]																NOT NULL,
									[TransactionUID]						[int]																NOT NULL,
									[Aborted]								[bit]																NULL,
									[DeviceNumber]							[int]																NULL,
									[DeviceType]							[int]																NULL,
									[EmployeeNumber]						[int]																NULL,
									[EndDate]								[date]																NOT NULL,
									[EndTime]								[time](7)															NOT NULL,
									[StartDate]								[date]																NOT NULL,
									[StartTime]								[time](7)															NULL,
									[Status]								[tinyint]															NULL,
									[TotalAmount]							[money]																NULL,
									[TransactionCode]						[int]																NULL,
									[TransactionSequence]					[int]																NULL,
									[RewardMemberID]						[varchar](20)														NULL,
									[RawFileName]							[varchar](256)														NOT NULL,
									[LineNo]								[varchar](32)														NOT NULL,
									[Header_Id]								[int] IDENTITY(1,1)													NOT NULL,
									[StageInsertStamp]						[DATETIME]															NOT NULL,
									[ProdInsertStamp]						[DATETIME]															NOT NULL 
																			DEFAULT(
																				CONVERT(
																					datetime,
																					SWITCHOFFSET(
																						GETDATE(),
																						DATEPART(
																							TZOFFSET,
																							GETDATE() AT TIME ZONE 'Central Standard Time'
																						)
																					)
																				)
																			),
									[CsvFile]								[varchar](128)														NOT NULL,
									[DataLakeFolder]						[varchar](64)														NOT NULL,
									[Pk]									[varchar](30)														PRIMARY KEY NONCLUSTERED
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Prod_Headers]
ON									[dbo].[prod_121_Headers]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
-------------------------------------------------------------------------- STG HEADERS
IF EXISTS							(
SELECT								*
FROM								sys.tables
WHERE								[name] = 'stg_121_Headers'
)
BEGIN
DROP TABLE							[dbo].[stg_121_Headers]
END

CREATE TABLE						[dbo].[stg_121_Headers](
									[RecordId]								[varchar](2)														NULL,
									[StoreNumber]							[int]																NOT NULL,
									[TransactionType]						[int]																NULL,
									[DayNumber]								[int]																NOT NULL,
									[ShiftNumber]							[int]																NOT NULL,
									[TransactionUID]						[int]																NOT NULL,
									[Aborted]								[bit]																NULL,
									[DeviceNumber]							[int]																NULL,
									[DeviceType]							[int]																NULL,
									[EmployeeNumber]						[int]																NULL,
									[EndDate]								[date]																NULL,
									[EndTime]								[time](7)															NULL,
									[StartDate]								[date]																NULL,
									[StartTime]								[time](7)															NULL,
									[Status]								[tinyint]															NULL,
									[TotalAmount]							[money]																NULL,
									[TransactionCode]						[int]																NULL,
									[TransactionSequence]					[int]																NULL,
									[RewardMemberID]						[varchar](20)														NULL,
									[RawFileName]							[varchar](256)														NULL,
									[LineNo]								[varchar](32)														NULL,
									[Header_Id]								[int] IDENTITY(1,1)													NOT NULL,
									[StageInsertStamp]						[DATETIME]															NOT NULL
																			DEFAULT(
																				CONVERT(
																					datetime,
																					SWITCHOFFSET(
																						GETDATE(),
																						DATEPART(
																							TZOFFSET,
																							GETDATE() AT TIME ZONE 'Central Standard Time'
																						)
																					)
																				)
																			),
									[ProdInsertStamp]						[DATETIME]															NULL,
									[CsvFile]								[varchar](128)														NULL,
									[DataLakeFolder]						[varchar](64)														NULL,
									[Pk]									[varchar](30)														NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Stg_Headers]
ON									[dbo].[stg_121_Headers]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
-------------------------------------------------------------------------- PROD DETAILS
IF EXISTS							(
SELECT								*
FROM								sys.tables
WHERE								[name] = 'prod_122_Details'
)
BEGIN
DROP TABLE							[dbo].[prod_122_Details]
END
CREATE TABLE						[dbo].[prod_122_Details](
									[RecordID]								[varchar](2)														NULL,
									[StoreNumber]							[int]																NOT NULL,
									[TransactionType]						[int]																NULL,
									[DayNumber]								[int]																NOT NULL,
									[ShiftNumber]							[int]																NOT NULL,
									[TransactionUID]						[int]																NOT NULL,
									[SequenceNumber]						[int]																NOT NULL,
									[ProductNumber]							[int]																NULL,
									[PLUNumber]								[varchar](14)														NULL,
									[RecordAmount]							[money]																NULL,
									[RecordCount]							[int]																NULL,
									[RecordType]							[int]																NULL,
									[SizeIndx]								[int]																NULL,
									[ErrorCorrectionFlag]					[bit]																NULL,
									[PriceOverideFlag]						[bit]																NULL,
									[TaxableFlag]							[bit]																NULL,
									[VoidFlag]								[bit]																NULL,
									[RecommendedFlag]						[bit]																NULL,
									[PriceMultiple]							[int]																NULL,
									[CarryStatus]							[int]																NULL,
									[TaxOverideFlag]						[bit]																NULL,
									[PromotionCount]						[int]																NULL,
									[SalesPrice]							[money]																NULL,	
									[MUBasePrice]							[money]																NULL,
									[HostItemId]							[varchar](20)														NULL,
									[CouponCount]							[int]																NULL,
									[RawFileName]							[DATETIME]															NOT NULL,
									[LineNo]								[varchar](128)														NOT NULL,
									[Detail_Id]								[int] IDENTITY(1,1)													NOT NULL,
									[StageInsertStamp]						[DATETIME]															NOT NULL,
									[ProdInsertStamp]						[varchar](64)														NOT NULL
																			DEFAULT(
																				CONVERT(
																					datetime,
																					SWITCHOFFSET(
																						GETDATE(),
																						DATEPART(
																							TZOFFSET,
																							GETDATE() AT TIME ZONE 'Central Standard Time'
																						)
																					)
																				)
																			),
									[CsvFile]								[varchar](256)														NOT NULL,
									[DataLakeFolder]						[varchar](32)														NOT NULL,
									[Pk]									[varchar](30)														PRIMARY KEY NONCLUSTERED
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Prod_Details]
ON									[dbo].[prod_122_Details]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
-------------------------------------------------------------------------- STG DETAILS
IF EXISTS							(
SELECT								*
FROM								sys.tables
WHERE								[name] = 'stg_122_Details'
)
BEGIN
DROP TABLE							[dbo].[stg_122_Details]
END
CREATE TABLE						[dbo].[stg_122_Details](
									[RecordID]								[varchar](2)														NULL,
									[StoreNumber]							[int]																NOT NULL,
									[TransactionType]						[int]																NULL,
									[DayNumber]								[int]																NOT NULL,
									[ShiftNumber]							[int]																NOT NULL,
									[TransactionUID]						[int]																NOT NULL,
									[SequenceNumber]						[int]																NOT NULL,
									[ProductNumber]							[int]																NULL,
									[PLUNumber]								[varchar](14)														NULL,
									[RecordAmount]							[money]																NULL,
									[RecordCount]							[int]																NULL,
									[RecordType]							[int]																NULL,
									[SizeIndx]								[int]																NULL,
									[ErrorCorrectionFlag]					[bit]																NULL,
									[PriceOverideFlag]						[bit]																NULL,
									[TaxableFlag]							[bit]																NULL,
									[VoidFlag]								[bit]																NULL,
									[RecommendedFlag]						[bit]																NULL,
									[PriceMultiple]							[int]																NULL,
									[CarryStatus]							[int]																NULL,
									[TaxOverideFlag]						[bit]																NULL,
									[PromotionCount]						[int]																NULL,
									[SalesPrice]							[money]																NULL,	
									[MUBasePrice]							[money]																NULL,
									[HostItemId]							[varchar](20)														NULL,
									[CouponCount]							[int]																NULL,
									[RawFileName]							[DATETIME]															NULL,
									[LineNo]								[varchar](128)														NULL,
									[Detail_Id]								[int] IDENTITY(1,1)													NOT NULL,
									[StageInsertStamp]						[DATETIME]															NOT NULL
																			DEFAULT(
																				CONVERT(
																					datetime,
																					SWITCHOFFSET(
																						GETDATE(),
																						DATEPART(
																							TZOFFSET,
																							GETDATE() AT TIME ZONE 'Central Standard Time'
																						)
																					)
																				)
																			),
									[ProdInsertStamp]						[varchar](64)														NULL,
									[CsvFile]								[varchar](256)														NULL,
									[DataLakeFolder]						[varchar](32)														NULL,
									[Pk]									[varchar](30)														NULL
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Stg_Details]
ON									[dbo].[stg_122_Details]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
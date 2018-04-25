USE									[7ELE]
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-------------------------------------------------------------------------- PROD HEADERS
DROP TABLE IF EXISTS				[dbo].[prod_121_Headers]
CREATE TABLE						[dbo].[prod_121_Headers]				(
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
									[EndDate]								[date]																NOT NULL,
									[EndTime]								[time](7)															NOT NULL,
									[StartDate]								[date]																NOT NULL,
									[StartTime]								[time](7)															NOT NULL,
									[Status]								[tinyint]															NULL,
									[TotalAmount]							[money]																NULL,
									[TransactionCode]						[int]																NULL,
									[TransactionSequence]					[int]																NULL,
									[RewardMemberID]						[varchar](20)														NULL,
									[RawFileName]							[varchar](512)														NOT NULL,
									[LineNo]								[varchar](32)														NOT NULL,
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
									[CsvFile]								[varchar](512)														NOT NULL,
									[DataLakeFolder]						[varchar](128)														NOT NULL,
									[Pk]									[varchar](64)														PRIMARY KEY NONCLUSTERED
WITH								(IGNORE_DUP_KEY = ON)					)
ON [Ps_Stores_Headers] ([EndDate])
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Prod_Headers]
ON									[dbo].[prod_121_Headers]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
GO
-------------------------------------------------------------------------- PROD HEADERS CEO
DROP TABLE IF EXISTS				[dbo].[prod_121_Headers_CEO]
CREATE TABLE						[dbo].[prod_121_Headers_CEO]			(
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
									[EndDate]								[date]																NOT NULL,
									[EndTime]								[time](7)															NOT NULL,
									[StartDate]								[date]																NOT NULL,
									[StartTime]								[time](7)															NOT NULL,
									[Status]								[tinyint]															NULL,
									[TotalAmount]							[money]																NULL,
									[TransactionCode]						[int]																NULL,
									[TransactionSequence]					[int]																NULL,
									[RewardMemberID]						[varchar](20)														NULL,
									[RawFileName]							[varchar](512)														NOT NULL,
									[LineNo]								[varchar](32)														NOT NULL,
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
									[CsvFile]								[varchar](512)														NOT NULL,
									[DataLakeFolder]						[varchar](128)														NOT NULL,
									[Pk]									[varchar](64)														PRIMARY KEY NONCLUSTERED
WITH								(IGNORE_DUP_KEY = ON)
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Prod_Headers_CEO]
ON									[dbo].[prod_121_Headers_CEO]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
GO
-------------------------------------------------------------------------- STG HEADERS 1
DROP TABLE IF EXISTS				[dbo].[stg_121_Headers_1]
CREATE TABLE						[dbo].[stg_121_Headers_1]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG HEADERS 2
DROP TABLE IF EXISTS				[dbo].[stg_121_Headers_2]
CREATE TABLE						[dbo].[stg_121_Headers_2]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG HEADERS 3
DROP TABLE IF EXISTS				[dbo].[stg_121_Headers_3]
CREATE TABLE						[dbo].[stg_121_Headers_3]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG HEADERS 4
DROP TABLE IF EXISTS				[dbo].[stg_121_Headers_4]
CREATE TABLE						[dbo].[stg_121_Headers_4]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG HEADERS 5
DROP TABLE IF EXISTS				[dbo].[stg_121_Headers_5]
CREATE TABLE						[dbo].[stg_121_Headers_5]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- PROD DETAILS
DROP TABLE IF EXISTS				[dbo].[prod_122_Details]
CREATE TABLE						[dbo].[prod_122_Details]				(
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
									[RawFileName]							[varchar](512)														NOT NULL,
									[LineNo]								[varchar](32)														NOT NULL,
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
									[CsvFile]								[varchar](512)														NOT NULL,
									[DataLakeFolder]						[varchar](128)														NOT NULL,
									[EndDate]								[date]																NOT NULL,
									[Pk]									[varchar](64)														PRIMARY KEY NONCLUSTERED
WITH								(IGNORE_DUP_KEY = ON)					)
ON [Ps_Stores_Details] ([EndDate])
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Prod_Details]
ON									[dbo].[prod_122_Details]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
GO
-------------------------------------------------------------------------- PROD DETAILS CEO
DROP TABLE IF EXISTS				[dbo].[prod_122_Details_CEO]
CREATE TABLE						[dbo].[prod_122_Details_CEO]			(
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
									[RawFileName]							[varchar](512)														NOT NULL,
									[LineNo]								[varchar](32)														NOT NULL,
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
									[CsvFile]								[varchar](512)														NOT NULL,
									[DataLakeFolder]						[varchar](128)														NOT NULL,
									[Pk]									[varchar](64)														PRIMARY KEY NONCLUSTERED
WITH								(IGNORE_DUP_KEY = ON)
)
GO
CREATE CLUSTERED COLUMNSTORE INDEX	[CCI_Prod_Details_CEO]
ON									[dbo].[prod_122_Details_CEO]
WITH								(DROP_EXISTING = OFF,
									COMPRESSION_DELAY = 0)
ON									[PRIMARY]
GO
-------------------------------------------------------------------------- STG DETAILS 1
DROP TABLE IF EXISTS				[dbo].[stg_122_Details_1]
CREATE TABLE						[dbo].[stg_122_Details_1]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[EndDate]								[date]																NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG DETAILS 2
DROP TABLE IF EXISTS				[dbo].[stg_122_Details_2]
CREATE TABLE						[dbo].[stg_122_Details_2]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[EndDate]								[date]																NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG DETAILS 3
DROP TABLE IF EXISTS				[dbo].[stg_122_Details_3]
CREATE TABLE						[dbo].[stg_122_Details_3]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[EndDate]								[date]																NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG DETAILS 4
DROP TABLE IF EXISTS				[dbo].[stg_122_Details_4]
CREATE TABLE						[dbo].[stg_122_Details_4]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[EndDate]								[date]																NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- STG DETAILS 5
DROP TABLE IF EXISTS				[dbo].[stg_122_Details_5]
CREATE TABLE						[dbo].[stg_122_Details_5]				(
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
									[RawFileName]							[varchar](512)														NULL,
									[LineNo]								[varchar](32)														NULL,
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
									[CsvFile]								[varchar](512)														NULL,
									[DataLakeFolder]						[varchar](128)														NULL,
									[EndDate]								[date]																NULL,
									[Pk]									[varchar](64)														NULL
)
GO
-------------------------------------------------------------------------- EXT PRODUCTS
DROP TABLE IF EXISTS				[dbo].[ext_productTable]
CREATE TABLE						[dbo].[ext_productTable]				(
									[ProductMaster_Id]						[varchar](50)														NOT NULL,
									[UPC]									[varchar](50)														NOT NULL,
									[Category_Cd]							[varchar](5)														NULL,
									[Category_Ds]							[varchar](50)														NULL,
									[Depart_Cd]								[varchar](30)														NULL,
									[Manufacturer_Cd]						[varchar](20)														NULL,
									[Manufacturer_Nm]						[varchar](50)														NULL,
									[PSA_Cd]								[varchar](4)														NULL,
									[PSA_Ds]								[varchar](50)														NULL,
									[Item_Ds]								[varchar](50)														NULL,
									[SubCategory_Cd]						[varchar](4)														NULL,
									[SubCategory_Ds]						[varchar](50)														NULL,
									[VerticalClass_Cd]						[varchar](3)														NULL,
									[VerticalClass_Ds]						[varchar](50)														NULL,
									[CorpBrand]								[varchar](10)														NULL,
									[UPCType_Cd]							[varchar](2)														NULL,
									[AgeRestricted_Fg]						[varchar](2)														NOT NULL,
									[CurrentImport_Id]						[varchar](10)														NOT NULL,
									[OriginalImport_Id]						[varchar](10)														NOT NULL,
									[Modified_Dttm]							[varchar](30)														NOT NULL,
									[Created_Dttm]							[varchar](30)														NOT NULL,
									[SLIN]									[int]																NULL,
CONSTRAINT							[pk_ProductMaster_Id]					PRIMARY KEY CLUSTERED												(
									[ProductMaster_Id] ASC)
WITH								(STATISTICS_NORECOMPUTE = OFF,
									IGNORE_DUP_KEY = ON)
)
-------------------------------------------------------------------------- EXT STORES
DROP TABLE IF EXISTS				[dbo].[ext_storeTable]
CREATE TABLE						[dbo].[ext_storeTable]					(
									[Store_Id]								[int]																NOT NULL,
									[Location_Nm]							[varchar](50)														NULL,
									[PhysicalAddress_Id]					[int]																NULL,
									[MailingAddress_Id]						[int]																NULL,
									[Phone_Id]								[int]																NULL,
									[Fax_Id]								[int]																NULL,
									[OriginalImport_Id]						[int]																NOT NULL,
									[CurrentImport_Id]						[int]																NOT NULL,
									[Modified_Dttm]							[datetime2](0)														NOT NULL,
									[Created_Dttm]							[datetime2](0)														NOT NULL,
									[EffectiveStart_Dt]						[date]																NULL,
									[Open_Dt]								[date]																NULL,
									[Closed_Dt]								[date]																NULL,
									[Alcohol_Fg]							[bit]																NOT NULL,
									[Liquor_Fg]								[bit]																NOT NULL,
									[Gas_Fg]								[bit]																NOT NULL,
									[CDC_Cd]								[varchar](3)														NULL,
									[CDC_Nm]								[varchar](30)														NULL,
									[DMA_Cd]								[smallint]															NULL,
									[DMA_Nm]								[varchar](30)														NULL,
									[FieldConsultant_Nm]					[varchar](33)														NULL,
									[Franchise_Cd]							[char](1)															NULL,
									[Market_Cd]								[int]																NULL,
									[Market_Ds]								[varchar](30)														NULL,
									[Latitude]								[decimal](9, 6)														NULL,
									[Longitude]								[decimal](9, 6)														NULL,
									[MarketManager_Nm]						[varchar](30)														NULL,
									[Owner_Cd]								[char](1)															NULL,
									[StoreType_Cd]							[char](1)															NULL,
									[Vicinity]								[varchar](50)														NULL,
									[Wholesale_Center]						[varchar](2)														NULL,
									[Zone_Cd]								[int]																NULL,
									[Zone_Nm]								[varchar](30)														NULL,
									[Region_Cd]								[char](1)															NULL,
									[Active_Fg]								[bit]																NOT NULL,
									[SysStartTime]							[datetime2](0)														NOT NULL,
									[SysEndTime]							[datetime2](0)														NOT NULL,
									[AgreementEdition_Dt]					[date]																NULL,
									[AgreementSigned_Dt]					[date]																NULL,
									[Dark_Fg]								[bit]																NOT NULL,
									[Country_Cd]							[char](2)															NULL
CONSTRAINT							[pk_Store_Id]							PRIMARY KEY CLUSTERED												(
									[Store_Id] ASC)
WITH								(STATISTICS_NORECOMPUTE = OFF,
									IGNORE_DUP_KEY = ON)
)

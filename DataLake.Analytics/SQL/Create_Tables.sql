SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'prod_121_Headers')
BEGIN
DROP TABLE [dbo].[prod_121_Headers]
END
CREATE TABLE [dbo].[prod_121_Headers](
	[RecordId] [varchar](2) NULL,
	[StoreNumber] [int] NULL,
	[TransactionType] [int] NOT NULL,
	[DayNumber] [int] NOT NULL,
	[ShiftNumber] [int] NOT NULL,
	[TransactionUID] [int] NOT NULL,
	[Aborted] [bit] NULL,
	[DeviceNumber] [int] NULL,
	[DeviceType] [int] NULL,
	[EmployeeNumber] [int] NULL,
	[EndDate] [date] NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[StartDate] [date] NOT NULL,
	[StartTime] [time](7) NULL,
	[Status] [tinyint] NULL,
	[TotalAmount] [money] NULL,
	[TransactionCode] [int] NULL,
	[TransactionSequence] [int] NULL,
	[RewardMemberID] [varchar](20) NULL,
	[Header_Id] [int] IDENTITY(1,1) NOT NULL,
	[ProdInsertStamp] [DATETIME] NOT NULL DEFAULT(CONVERT(datetime, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'Central Standard Time')))),
	[StageInsertStamp] [DATETIME] NOT NULL,
	[CsvFile] [varchar](128) NOT NULL,
	[DataLakeFolder] [varchar](64) NOT NULL,
	[RawFileName] [varchar](256) NOT NULL,
	[LineNo] [varchar](32) NOT NULL,
	[Pk] [varchar](30) PRIMARY KEY
)
GO
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'prod_122_Details')
BEGIN
DROP TABLE [dbo].[prod_122_Details]
END
CREATE TABLE [dbo].[prod_122_Details](
	[RecordID] [varchar](2) NULL,
	[StoreNumber] [int] NOT NULL,
	[TransactionType] [int] NULL,
	[DayNumber] [int] NULL,
	[ShiftNumber] [int] NULL,
	[TransactionUID] [int] NULL,
	[SequenceNumber] [int] NULL,
	[ProductNumber] [int] NULL,
	[PLUNumber] [varchar](14) NULL,
	[RecordAmount] [money] NULL,
	[RecordCount] [int] NULL,
	[RecordType] [int] NULL,
	[SizeIndx] [int] NULL,
	[ErrorCorrectionFlag] [bit] NULL,
	[PriceOverideFlag] [bit] NULL,
	[TaxableFlag] [bit] NULL,
	[VoidFlag] [bit] NULL,
	[RecommendedFlag] [bit] NULL,
	[PriceMultiple] [int] NULL,
	[CarryStatus] [int] NULL,
	[TaxOverideFlag] [bit] NULL,
	[PromotionCount] [int] NULL,
	[SalesPrice] [money] NULL,
	[MUBasePrice] [money] NULL,
	[HostItemId] [varchar](20) NULL,
	[CouponCount] [int] NULL,
	[Detail_Id] [int] IDENTITY(1,1) NOT NULL,
	[ProdInsertStamp] [DATETIME] NOT NULL DEFAULT(CONVERT(datetime, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'Central Standard Time')))),
	[StageInsertStamp] [DATETIME] NOT NULL,
	[CsvFile] [varchar](128) NOT NULL,
	[DataLakeFolder] [varchar](64) NOT NULL,
	[RawFileName] [varchar](256) NOT NULL,
	[LineNo] [varchar](32) NOT NULL,
	[Pk] [varchar](30) PRIMARY KEY
) ON [PRIMARY]
GO
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'stg_121_Headers')
BEGIN
DROP TABLE [dbo].[stg_121_Headers]
END
CREATE TABLE [dbo].[stg_121_Headers](
	[RecordId] [varchar](2) NULL,
	[StoreNumber] [int] NULL,
	[TransactionType] [int] NOT NULL,
	[DayNumber] [int] NOT NULL,
	[ShiftNumber] [int] NOT NULL,
	[TransactionUID] [int] NOT NULL,
	[Aborted] [bit] NULL,
	[DeviceNumber] [int] NULL,
	[DeviceType] [int] NULL,
	[EmployeeNumber] [int] NULL,
	[EndDate] [date] NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[StartDate] [date] NOT NULL,
	[StartTime] [time](7) NULL,
	[Status] [tinyint] NULL,
	[TotalAmount] [money] NULL,
	[TransactionCode] [int] NULL,
	[TransactionSequence] [int] NULL,
	[RewardMemberID] [varchar](20) NULL,
	[RawFileName] [varchar](256) NULL,
	[LineNo] [varchar](32) NULL,
	[StageInsertStamp] [DATETIME] NOT NULL DEFAULT(CONVERT(datetime, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'Central Standard Time')))),
	[CsvFile] [varchar](128) NULL,
	[DataLakeFolder] [varchar](64) NULL,
	[Pk] [varchar](30) NULL
) ON [PRIMARY]
GO
IF EXISTS							(SELECT * FROM sys.tables WHERE [name] = 'stg_122_Details')
BEGIN
DROP TABLE [dbo].[stg_122_Details]
END
CREATE TABLE [dbo].[stg_122_Details](
	[RecordID] [varchar](2) NULL,
	[StoreNumber] [int] NOT NULL,
	[TransactionType] [int] NULL,
	[DayNumber] [int] NULL,
	[ShiftNumber] [int] NULL,
	[TransactionUID] [int] NULL,
	[SequenceNumber] [int] NULL,
	[ProductNumber] [int] NULL,
	[PLUNumber] [varchar](14) NULL,
	[RecordAmount] [money] NULL,
	[RecordCount] [int] NULL,
	[RecordType] [int] NULL,
	[SizeIndx] [int] NULL,
	[ErrorCorrectionFlag] [bit] NULL,
	[PriceOverideFlag] [bit] NULL,
	[TaxableFlag] [bit] NULL,
	[VoidFlag] [bit] NULL,
	[RecommendedFlag] [bit] NULL,
	[PriceMultiple] [int] NULL,
	[CarryStatus] [int] NULL,
	[TaxOverideFlag] [bit] NULL,
	[PromotionCount] [int] NULL,
	[SalesPrice] [money] NULL,
	[MUBasePrice] [money] NULL,
	[HostItemId] [varchar](20) NULL,
	[CouponCount] [int] NULL,
	[RawFileName] [varchar](256) NULL,
	[LineNo] [varchar](32) NULL,
	[StageInsertStamp] [DATETIME] NOT NULL DEFAULT(CONVERT(datetime, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'Central Standard Time')))),
	[CsvFile] [varchar](128) NULL,
	[DataLakeFolder] [varchar](64) NULL,
	[Pk] [varchar](30) NULL
) ON [PRIMARY]
GO

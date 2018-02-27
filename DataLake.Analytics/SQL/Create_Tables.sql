--CONCAT([StoreNumber],[DayNumber],[ShiftNumber],[TransactionUID]) AS [PK]

/****** Object:  Table [dbo].[prod_121_Headers]    Script Date: 2/26/2018 7:17:30 PM ******/
DROP TABLE [dbo].[prod_121_Headers]
GO

/****** Object:  Table [dbo].[prod_121_Headers]    Script Date: 2/26/2018 7:17:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
	[CsvFile] [varchar](64),
	[DataLakeFolder] [varchar](32),
	[Pk] [varchar](30) PRIMARY KEY
)
GO


/****** Object:  Table [dbo].[prod_122_Details]    Script Date: 2/26/2018 7:17:38 PM ******/
DROP TABLE [dbo].[prod_122_Details]
GO

/****** Object:  Table [dbo].[prod_122_Details]    Script Date: 2/26/2018 7:17:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
	[CsvFile] [varchar](64) NOT NULL,
	[DataLakeFolder] [varchar](32) NOT NULL,
	[Pk] [varchar](30) PRIMARY KEY
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[stg_121_Headers]    Script Date: 2/26/2018 7:20:07 PM ******/
DROP TABLE [dbo].[stg_121_Headers]
GO

/****** Object:  Table [dbo].[stg_121_Headers]    Script Date: 2/26/2018 7:20:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
	[StageInsertStamp] [DATETIME] NOT NULL DEFAULT(CONVERT(datetime, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'Central Standard Time')))),
	[CsvFile] [varchar](64) NULL,
	[DataLakeFolder] [varchar](32) NULL,
	[Pk] [varchar](30) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[stg_122_Details]    Script Date: 2/26/2018 7:20:24 PM ******/
DROP TABLE [dbo].[stg_122_Details]
GO

/****** Object:  Table [dbo].[stg_122_Details]    Script Date: 2/26/2018 7:20:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
	[StageInsertStamp] [DATETIME] NOT NULL DEFAULT(CONVERT(datetime, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'Central Standard Time')))),
	[CsvFile] [varchar](64) NULL,
	[DataLakeFolder] [varchar](32) NULL,
	[Pk] [varchar](30) NULL
) ON [PRIMARY]
GO


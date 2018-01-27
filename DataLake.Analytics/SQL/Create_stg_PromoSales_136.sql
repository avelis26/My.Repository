USE [7ELE]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_PromoSales_136](
	[RecordId] [varchar](2) NULL,
	[StoreNumber] [int] NOT NULL,
	[TransactionType] [int] NULL,
	[DayNumber] [int] NULL,
	[ShiftNumber] [int] NULL,
	[TransactionUID] [int] NULL,
	[SequenceNumber] [int] NULL,
	[RecordType] [int] NULL,
	[ErrorCorrectionFlag] [varchar](1) NULL,
	[VoidFlag] [varchar](1) NULL,
	[TaxableFlag] [varchar](1) NULL,
	[TaxOverideFlag] [varchar](1) NULL,
	[PromotionId] [int] NULL,
	[RecordCount] [int] NULL,
	[RecordAmount] [money] NULL,
	[PromotionProductCode] [int] NULL,
	[DepartmentNumber] [int] NULL,
	[PromoSales_Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_PromoSales126_MediaIdStoreNumber] PRIMARY KEY CLUSTERED 
(
	[PromoSales_Id] ASC,
	[StoreNumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)
GO

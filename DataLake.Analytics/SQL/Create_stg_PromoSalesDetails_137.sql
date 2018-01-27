USE [7ELE]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_PromoSalesDetails_137](
	[RecordId] [varchar](2) NULL,
	[StoreNumber] [int] NOT NULL,
	[TransactionType] [int] NULL,
	[DayNumber] [int] NULL,
	[ShiftNumber] [int] NULL,
	[TransactionUID] [int] NULL,
	[SequenceNumber] [int] NULL,
	[OwnerSequenceNumber] [int] NULL,
	[PromotionSequenceNumber] [int] NULL,
	[RecordAmount] [money] NULL,
	[RecordCount] [int] NULL,
	[PromotionGroupId] [int] NULL,
	[ThresholdQty] [int] NULL,
	[PromoSalesDetails_Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_PromoSalesDetails137_PromoSalesDetailsIdStoreNumber] PRIMARY KEY CLUSTERED 
(
	[PromoSalesDetails_Id] ASC,
	[StoreNumber] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)
GO
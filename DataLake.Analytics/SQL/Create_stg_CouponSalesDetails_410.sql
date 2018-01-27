USE [7ELE]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_CouponSalesDetails_410](
	[RecordId] [varchar](2) NULL,
	[StoreNumber] [int] NULL,
	[TransactionType] [int] NULL,
	[DayNumber] [int] NULL,
	[ShiftNumber] [int] NULL,
	[TransactionUID] [int] NULL,
	[SequenceNumber] [bigint] NULL,
	[OwnerSequenceNumber] [bigint] NULL,
	[CouponCouponNumber] [int] NULL,
	[RecordCount] [int] NULL,
	[ReportedItemFlag] [varchar](1) NULL,
	[OwnerType] [int] NULL,
	[CouponSalesDetails_Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_CouponSalesDetails410_CouponSalesDetailsId] PRIMARY KEY CLUSTERED 
(
	[CouponSalesDetails_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
USE [7ELE]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[stg_CouponSales_409](
	[RecordId] [varchar](2) NULL,
	[StoreNumber] [int] NOT NULL,
	[TransactionType] [int] NULL,
	[DayNumber] [int] NULL,
	[ShiftNumber] [int] NULL,
	[TransactionUID] [int] NULL,
	[SequenceNumber] [int] NULL,
	[CouponId] [int] NULL,
	[CouponDescription] [varchar](18) NULL,
	[PLUNumber] [varchar](22) NULL,
	[CouponType] [varchar](2) NULL,
	[CouponValueCode] [varchar](2) NULL,
	[EntryMethod] [int] NULL,
	[HostMediaNumber] [int] NULL,
	[RecordAmount] [money] NULL,
	[RecordCount] [int] NULL,
	[ErrorCorrectionFlag] [varchar](1) NULL,
	[VoidFlag] [varchar](1) NULL,
	[TaxableFlag] [varchar](1) NULL,
	[TaxOverrideFlag] [varchar](1) NULL,
	[AnnulFlag] [varchar](1) NULL,
	[PrimaryCompanyId] [varchar](15) NULL,
	[OfferCode] [int] NULL,
	[SaveValue] [int] NULL,
	[PrimaryPurchaseRequirement] [int] NULL,
	[PrimaryPurchaseRequirementCode] [int] NULL,
	[PrimaryPurchaseFamilyCode] [int] NULL,
	[AdditionalPurchaseRulesCode] [int] NULL,
	[SecondPurchaseRequirement] [int] NULL,
	[SecondPurchaseRequirementCode] [int] NULL,
	[SecondPurchaseFamilyCode] [int] NULL,
	[SecondCompanyId] [int] NULL,
	[ThirdPurchaseRequirement] [int] NULL,
	[ThirdPurchaseRequirementCode] [int] NULL,
	[ThirdPurchaseFamilyCode] [int] NULL,
	[ThirdCompanyId] [int] NULL,
	[ExpirationDate] [varchar](6) NULL,
	[StartDate] [varchar](6) NULL,
	[SerialNumber] [varchar](15) NULL,
	[RetailerId] [int] NULL,
	[SaveValueCode] [int] NULL,
	[DiscountedItem] [int] NULL,
	[StoreCouponIndicator] [int] NULL,
	[NoMultiplyFla] [int] NULL,
	[CouponSales_Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_CouponSales409_CouponSalesId] PRIMARY KEY CLUSTERED 
(
	[CouponSales_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
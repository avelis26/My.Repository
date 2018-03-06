USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Staging_To_Prod_Details]
GO
CREATE PROCEDURE				[dbo].[usp_Staging_To_Prod_Details]
									@DetailsTable								varchar(32)
AS
SET NOCOUNT ON
--INSERT INTO						[dbo].[prod_122_Details]
INSERT INTO						@DetailsTable
(
								[RecordID],
								[StoreNumber],
								[TransactionType],
								[DayNumber],
								[ShiftNumber],
								[TransactionUID],
								[SequenceNumber],
								[ProductNumber],
								[PLUNumber],
								[RecordAmount],
								[RecordCount],
								[RecordType],
								[SizeIndx],
								[ErrorCorrectionFlag],
								[PriceOverideFlag],
								[TaxableFlag],
								[VoidFlag],
								[RecommendedFlag],
								[PriceMultiple],
								[CarryStatus],
								[TaxOverideFlag],
								[PromotionCount],
								[SalesPrice],
								[MUBasePrice],
								[HostItemId],
								[CouponCount],
								[RawFileName],
								[LineNo],
								[StageInsertStamp],
								[CsvFile],
								[DataLakeFolder],
								[Pk]
)
SELECT
								[RecordID],
								[StoreNumber],
								[TransactionType],
								[DayNumber],
								[ShiftNumber],
								[TransactionUID],
								[SequenceNumber],
								[ProductNumber],
								[PLUNumber],
								[RecordAmount],
								[RecordCount],
								[RecordType],
								[SizeIndx],
								[ErrorCorrectionFlag],
								[PriceOverideFlag],
								[TaxableFlag],
								[VoidFlag],
								[RecommendedFlag],
								[PriceMultiple],
								[CarryStatus],
								[TaxOverideFlag],
								[PromotionCount],
								[SalesPrice],
								[MUBasePrice],
								[HostItemId],
								[CouponCount],
								[RawFileName],
								[LineNo],
								[StageInsertStamp],
								[CsvFile],
								[DataLakeFolder],
								[Pk]
FROM							[dbo].[stg_122_Details]
GO

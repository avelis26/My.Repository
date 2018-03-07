USE								[7ELE]
GO
DROP PROCEDURE IF EXISTS		[dbo].[usp_Staging_To_Prod_Details]
GO
CREATE PROCEDURE				[dbo].[usp_Staging_To_Prod_Details]
									@StagingTable								varchar(32),
									@ProdTable									varchar(32)
AS
SET NOCOUNT ON
INSERT INTO						@ProdTable
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
FROM							@StagingTable
GO

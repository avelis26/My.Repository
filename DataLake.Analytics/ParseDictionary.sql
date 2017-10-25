CREATE VIEW [Src].[VwPOSAmexCardSales]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 4 )  AS DayNumber,
         Substring( [column 0], 16, 4 )  AS ShiftNumber,
         Substring( [column 0], 20, 14 ) AS TransactionDate,
         Substring( [column 0], 34, 19 ) AS CardAccountNumber,
         Substring( [column 0], 53, 6 )  AS EmployeeNumber,
         Substring( [column 0], 59, 11 ) AS SequenceNumber,
         Substring( [column 0], 70, 3 )  AS DeviceNumber,
         Substring( [column 0], 73, 9 )  AS ApprovalCode,
         Substring( [column 0], 82, 4 )  AS ResponseCode,
         Substring( [column 0], 86, 6 )  AS STTNumber,
         Substring( [column 0], 92, 6 )  AS LoadAmount,
         Substring( [column 0], 98, 6 )  AS FeeAmount,
         Substring( [column 0], 104, 6 ) AS CardBalance,
         Substring( [column 0], 110, 1 ) AS VoidFlag,
         Substring( [column 0], 111, 6 ) AS EmbeddedFee,
         Substring( [column 0], 117, 6 ) AS VendorFee
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '120' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSComments]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumbar,
         Substring( [column 0], 46, 80 ) AS Comments,
         Substring( [column 0], 126, 6 ) AS RecordType
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '127' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSConfiguration]
AS
  SELECT Substring( [column 0], 1, 2 )  AS RecordId,
         Substring( [column 0], 3, 6 )  AS StoreNumber,
         Substring( [column 0], 9, 3 )  AS TransactionType,
         Substring( [column 0], 12, 6 ) AS TerminalNumber,
         Substring( [column 0], 18, 6 ) AS Scanner,
         Substring( [column 0], 24, 6 ) AS MsrPort,
         Substring( [column 0], 30, 6 ) AS CustomerDisplayPort,
         Substring( [column 0], 36, 6 ) AS PinPadPort,
         Substring( [column 0], 42, 6 ) AS ForceDrop,
         Substring( [column 0], 48, 1 ) AS IsCloseDrawer,
         Substring( [column 0], 49, 1 ) AS IsShowSafeDrop,
         Substring( [column 0], 50, 1 ) AS IsOpenDrawer,
         Substring( [column 0], 51, 1 ) AS IsShiftSignOn,
         Substring( [column 0], 52, 1 ) AS IsPumpInterface,
         Substring( [column 0], 53, 1 ) AS IsAuditEOS,
         Substring( [column 0], 54, 1 ) AS IsRevenueEOS,
         Substring( [column 0], 55, 1 ) AS IsNetworkBatchEOS,
         Substring( [column 0], 56, 1 ) AS IsAcceptEOS,
         Substring( [column 0], 57, 1 ) AS IsAuditEOD,
         Substring( [column 0], 58, 1 ) AS IsRevenueEOD,
         Substring( [column 0], 59, 1 ) AS IsNetworkEOD,
         Substring( [column 0], 60, 1 ) AS IsAcceptEOD,
         Substring( [column 0], 61, 5 ) AS TerminalType,
         Substring( [column 0], 66, 6 ) AS AlarmDropAmount
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '135' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSCouponReject]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordId,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 9 )   AS DayNumber,
         Substring( [column 0], 21, 6 )   AS ShiftNumber,
         Substring( [column 0], 27, 9 )   AS TransactionUID,
         Substring( [column 0], 36, 9 )   AS SequenceNumber,
         Substring( [column 0], 45, 22 )  AS PLUNumber,
         Substring( [column 0], 67, 15 )  AS PrimaryCompany,
         Substring( [column 0], 82, 6 )   AS OfferCode,
         Substring( [column 0], 88, 9 )   AS SaveValue,
         Substring( [column 0], 97, 9 )   AS PrimaryPurchaseRequirement,
         Substring( [column 0], 106, 1 )  AS PrimaryPurchaseRequirementCode,
         Substring( [column 0], 107, 3 )  AS PrimaryPurchaseFamilyCode,
         Substring( [column 0], 110, 1 )  AS AdditionalPurchaseRulesCode,
         Substring( [column 0], 111, 9 )  AS SecondPurchaseRequirement,
         Substring( [column 0], 120, 1 )  AS SecondPurchaseRequirementCode,
         Substring( [column 0], 121, 3 )  AS SecondPurchaseFamilyCode,
         Substring( [column 0], 124, 15 ) AS SecondCompany,
         Substring( [column 0], 139, 9 )  AS ThirdPurchaseRequirement,
         Substring( [column 0], 148, 1 )  AS ThirdPurchaseRequirementCode,
         Substring( [column 0], 149, 3 )  AS ThirdPurchaseFamilyCode,
         Substring( [column 0], 152, 15 ) AS ThirdCompany,
         Substring( [column 0], 167, 6 )  AS ExpirationDate,
         Substring( [column 0], 173, 6 )  AS StartDate,
         Substring( [column 0], 179, 15 ) AS SerialNumber,
         Substring( [column 0], 194, 15 ) AS RetailerID,
         Substring( [column 0], 209, 1 )  AS SaveValueCode,
         Substring( [column 0], 210, 1 )  AS DiscountedItem,
         Substring( [column 0], 211, 1 )  AS IsStoreCoupon,
         Substring( [column 0], 212, 1 )  AS IsMultiple,
         Substring( [column 0], 213, 80 ) AS RejectReason
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '463' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSCouponSales]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordId,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 9 )   AS DayNumber,
         Substring( [column 0], 21, 6 )   AS ShiftNumber,
         Substring( [column 0], 27, 9 )   AS TransactionUID,
         Substring( [column 0], 36, 9 )   AS SequenceNumber,
         Substring( [column 0], 45, 9 )   AS CouponId,
         Substring( [column 0], 54, 18 )  AS CouponDescription,
         Substring( [column 0], 72, 22 )  AS PLUNumber,
         Substring( [column 0], 94, 2 )   AS CouponType,
         Substring( [column 0], 96, 2 )   AS CouponValueCode,
         Substring( [column 0], 98, 9 )   AS EntryMethod,
         Substring( [column 0], 107, 9 )  AS HostMediaNumber,
         Substring( [column 0], 116, 9 )  AS RecordAmount,
         Substring( [column 0], 125, 9 )  AS RecordCount,
         Substring( [column 0], 134, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 135, 1 )  AS VoidFlag,
         Substring( [column 0], 136, 1 )  AS TaxableFlag,
         Substring( [column 0], 137, 1 )  AS TaxOverrideFlag,
         Substring( [column 0], 138, 1 )  AS AnnulFlag,
         Substring( [column 0], 139, 15 ) AS PrimaryCompanyId,
         Substring( [column 0], 154, 6 )  AS OfferCode,
         Substring( [column 0], 160, 9 )  AS SaveValue,
         Substring( [column 0], 169, 9 )  AS PrimaryPurchaseRequirement,
         Substring( [column 0], 178, 1 )  AS PrimaryPurchaseRequirementCode,
         Substring( [column 0], 179, 3 )  AS PrimaryPurchaseFamilyCode,
         Substring( [column 0], 182, 1 )  AS AdditionalPurchaseRulesCode,
         Substring( [column 0], 183, 9 )  AS SecondPurchaseRequirement,
         Substring( [column 0], 192, 1 )  AS SecondPurchaseRequirementCode,
         Substring( [column 0], 193, 3 )  AS SecondPurchaseFamilyCode,
         Substring( [column 0], 196, 15 ) AS SecondCompanyId,
         Substring( [column 0], 211, 9 )  AS ThirdPurchaseRequirement,
         Substring( [column 0], 220, 1 )  AS ThirdPurchaseRequirementCode,
         Substring( [column 0], 221, 3 )  AS ThirdPurchaseFamilyCode,
         Substring( [column 0], 224, 15 ) AS ThirdCompanyId,
         Substring( [column 0], 239, 6 )  AS ExpirationDate,
         Substring( [column 0], 245, 6 )  AS StartDate,
         Substring( [column 0], 251, 15 ) AS SerialNumber,
         Substring( [column 0], 266, 15 ) AS RetailerId,
         Substring( [column 0], 281, 1 )  AS SaveValueCode,
         Substring( [column 0], 282, 1 )  AS DiscountedItem,
         Substring( [column 0], 283, 1 )  AS StoreCouponIndicator,
         Substring( [column 0], 284, 1 )  AS NoMultiplyFlag
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '409' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSDepartmentSales]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 6 )  AS DepartmentNumber,
         Substring( [column 0], 52, 6 )  AS SubDepartment,
         Substring( [column 0], 58, 6 )  AS RecordType,
         Substring( [column 0], 64, 6 )  AS RecordCount,
         Substring( [column 0], 70, 11 ) AS RecordAmount,
         Substring( [column 0], 81, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 82, 1 )  AS VoidFlag,
         Substring( [column 0], 83, 1 )  AS TaxableFlag,
         Substring( [column 0], 84, 1 )  AS PriceOverideFlag,
         Substring( [column 0], 85, 1 )  AS TaxOverideFlag,
         Substring( [column 0], 86, 14 ) AS HostItemId
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '123' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSFuelSales]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordId,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 6 )   AS DayNumber,
         Substring( [column 0], 18, 6 )   AS ShiftNumber,
         Substring( [column 0], 24, 11 )  AS TransactionUID,
         Substring( [column 0], 35, 11 )  AS SequenceNumber,
         Substring( [column 0], 46, 6 )   AS RecordType,
         Substring( [column 0], 52, 6 )   AS DispenserNumber,
         Substring( [column 0], 58, 6 )   AS SaleProductId,
         Substring( [column 0], 64, 6 )   AS HoseNumber,
         Substring( [column 0], 70, 6 )   AS MediaNumber,
         Substring( [column 0], 76, 6 )   AS ServiceLevelId,
         Substring( [column 0], 82, 11 )  AS PricePerUnit,
         Substring( [column 0], 93, 11 )  AS SaleVolume,
         Substring( [column 0], 104, 11 ) AS CreePage,
         Substring( [column 0], 115, 11 ) AS RecordAmount,
         Substring( [column 0], 126, 6 )  AS FuelPriceTable,
         Substring( [column 0], 132, 6 )  AS FuelPriceGroup,
         Substring( [column 0], 138, 6 )  AS PrimaryTankNumber,
         Substring( [column 0], 144, 11 ) AS PrimaryTankVolume,
         Substring( [column 0], 155, 6 )  AS SecondaryTankNumber,
         Substring( [column 0], 161, 11 ) AS SecondaryTankVolume,
         Substring( [column 0], 172, 1 )  AS ManualFlag,
         Substring( [column 0], 173, 1 )  AS AutoFinalFlag,
         Substring( [column 0], 174, 6 )  AS DeviceType,
         Substring( [column 0], 180, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 181, 1 )  AS VoidFlag,
         Substring( [column 0], 182, 1 )  AS PrepayFlag,
         Substring( [column 0], 183, 11 ) AS MediaAdjustAmount,
         Substring( [column 0], 194, 11 ) AS AdjustPricePerUnit
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '130';

CREATE VIEW [Src].[VwPOSICLoadSales]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordId,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 6 )   AS DayNumber,
         Substring( [column 0], 18, 6 )   AS ShiftNumber,
         Substring( [column 0], 24, 11 )  AS TransactionUID,
         Substring( [column 0], 35, 11 )  AS SequenceNumber,
         Substring( [column 0], 46, 11 )  AS LoadSaleSequenceNumber,
         Substring( [column 0], 57, 4 )   AS RecordType,
         Substring( [column 0], 61, 6 )   AS LoadAmount,
         Substring( [column 0], 67, 6 )   AS BalanceAmount,
         Substring( [column 0], 73, 19 )  AS AccountNumber,
         Substring( [column 0], 92, 6 )   AS STTNumber,
         Substring( [column 0], 98, 6 )   AS AuthorizationTime,
         Substring( [column 0], 104, 12 ) AS AuthorizationNumber,
         Substring( [column 0], 116, 6 )  AS AuthorizationCode,
         Substring( [column 0], 122, 12 ) AS NetworkTerminal,
         Substring( [column 0], 134, 2 )  AS NetworkLocalTerminal,
         Substring( [column 0], 136, 14 ) AS PLUNumber,
         Substring( [column 0], 150, 11 ) AS ItemId,
         Substring( [column 0], 161, 11 ) AS ItmCostAmount,
         Substring( [column 0], 172, 11 ) AS VendorId,
         Substring( [column 0], 183, 6 )  AS FeeAmount,
         Substring( [column 0], 189, 6 )  AS FeeAmountEmbedded,
         Substring( [column 0], 195, 6 )  AS FeeAmountVendor
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '133' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSItemSales]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordID,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 6 )   AS DayNumber,
         Substring( [column 0], 18, 6 )   AS ShiftNumber,
         Substring( [column 0], 24, 11 )  AS TransactionUID,
         Substring( [column 0], 35, 11 )  AS SequenceNumber,
         Substring( [column 0], 46, 11 )  AS ProductNumber,
         Substring( [column 0], 57, 14 )  AS PLUNumber,
         Substring( [column 0], 71, 11 )  AS RecordAmount,
         Substring( [column 0], 82, 6 )   AS RecordCount,
         Substring( [column 0], 88, 6 )   AS RecordType,
         Substring( [column 0], 94, 1 )   AS SizeIndx,
         Substring( [column 0], 95, 1 )   AS ErrorCorrectionFlag,
         Substring( [column 0], 96, 1 )   AS PriceOverideFlag,
         Substring( [column 0], 97, 1 )   AS TaxableFlag,
         Substring( [column 0], 98, 1 )   AS VoidFlag,
         Substring( [column 0], 99, 1 )   AS RecommendedFlag,
         Substring( [column 0], 100, 6 )  AS PriceMultiple,
         Substring( [column 0], 106, 6 )  AS CarryStatus,
         Substring( [column 0], 112, 1 )  AS TaxOverideFlag,
         Substring( [column 0], 113, 2 )  AS PromotionCount,
         Substring( [column 0], 115, 4 )  AS SalesPrice,
         Substring( [column 0], 119, 4 )  AS MUBasePrice,
         Substring( [column 0], 123, 14 ) AS HostItemId,
         Substring( [column 0], 137, 10 ) AS CouponCount
  FROM   [Ext].[POS]
  WHERE  Substring( [column 0], 9, 3 ) = '122'AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSMediaSales]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 6 )  AS MediaNumber,
         Substring( [column 0], 52, 11 ) AS NetworkMediaSequenceNumber,
         Substring( [column 0], 63, 2 )  AS MediaType,
         Substring( [column 0], 65, 6 )  AS RecordCount,
         Substring( [column 0], 71, 11 ) AS RecordAmount,
         Substring( [column 0], 82, 6 )  AS RecordType,
         Substring( [column 0], 88, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 89, 1 )  AS VoidFlag,
         Substring( [column 0], 90, 5 )  AS ExchangeRate,
         Substring( [column 0], 95, 11 ) AS ForeignAmount
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '124' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSMoneyOrderSales]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 6 )  AS MoneyOrderSaleAmount,
         Substring( [column 0], 52, 4 )  AS MoneyOrderFeeAmount,
         Substring( [column 0], 56, 12 ) AS MoneyOrderSerialNumber,
         Substring( [column 0], 68, 10 ) AS MoneyOrderDepartmentSaleSeqNumber,
         Substring( [column 0], 78, 10 ) AS MoneyOrderDepartmentFeeNumber,
         Substring( [column 0], 88, 10 ) AS MoneyOrderPrintedFlg
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '140';

CREATE VIEW [Src].[VwPOSNetworkSales]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordId,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 6 )   AS DayNumber,
         Substring( [column 0], 18, 6 )   AS ShiftNumber,
         Substring( [column 0], 24, 11 )  AS TransactionUID,
         Substring( [column 0], 35, 11 )  AS SequenceNumber,
         Substring( [column 0], 46, 4 )   AS OwnerSequenceNumber,
         Substring( [column 0], 50, 40 )  AS AccountNumber,
         Substring( [column 0], 90, 10 )  AS BatchNumber,
         Substring( [column 0], 100, 10 ) AS BatchSequenceNumber,
         Substring( [column 0], 110, 4 )  AS CardTransactionFee,
         Substring( [column 0], 114, 6 )  AS RecordType,
         Substring( [column 0], 120, 12 ) AS ReponseCodeText,
         Substring( [column 0], 132, 12 ) AS AuthorizationNumber,
         Substring( [column 0], 144, 6 )  AS AuthorizationCode1,
         Substring( [column 0], 150, 6 )  AS AuthorizationCode2,
         Substring( [column 0], 156, 26 ) AS CustomerName,
         Substring( [column 0], 182, 10 ) AS EntryType,
         Substring( [column 0], 192, 4 )  AS ExpirationDate,
         Substring( [column 0], 196, 6 )  AS AuthorizationTime,
         Substring( [column 0], 202, 10 ) AS VehicleNumber,
         Substring( [column 0], 212, 10 ) AS OdometerReading,
         Substring( [column 0], 222, 10 ) AS DriverNumber,
         Substring( [column 0], 232, 14 ) AS CustomizedReferenceNumber,
         Substring( [column 0], 246, 3 )  AS AccountType,
         Substring( [column 0], 249, 6 )  AS AuthorizationTraceId,
         Substring( [column 0], 255, 20 ) AS AuthorizationPartyName,
         Substring( [column 0], 275, 6 )  AS STTNumber,
         Substring( [column 0], 281, 4 )  AS BalanceAmount,
         Substring( [column 0], 285, 40 ) AS MaskedAccountNumber,
         Substring( [column 0], 325, 9 )  AS RoutingNumber,
         Substring( [column 0], 334, 10 ) AS CheckNumber,
         Substring( [column 0], 344, 10 ) AS CardType,
         Substring( [column 0], 354, 11 ) AS Amount
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '139' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSPaidInByReason]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 47, 11 ) AS Amount,
         Substring( [column 0], 58, 6 )  AS MediaNumber,
         Substring( [column 0], 64, 6 )  AS ReasonCode,
         Substring( [column 0], 70, 6 )  AS RecordType,
         Substring( [column 0], 76, 6 )  AS TerminalNumber,
         Substring( [column 0], 82, 1 )  AS VoidFlag
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '128' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSPaidOutByReason]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 47, 11 ) AS Amount,
         Substring( [column 0], 58, 6 )  AS MediaNumber,
         Substring( [column 0], 64, 6 )  AS ReasonCode,
         Substring( [column 0], 70, 6 )  AS RecordType,
         Substring( [column 0], 76, 6 )  AS TerminalNumber,
         Substring( [column 0], 82, 1 )  AS VoidFlag
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '129' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSPromotionSales]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 6 )  AS RecordType,
         Substring( [column 0], 52, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 53, 1 )  AS VoidFlag,
         Substring( [column 0], 54, 1 )  AS TaxableFlag,
         Substring( [column 0], 55, 1 )  AS TaxOverideFlag,
         Substring( [column 0], 56, 6 )  AS PromotionId,
         Substring( [column 0], 62, 6 )  AS RecordCount,
         Substring( [column 0], 68, 6 )  AS RecordAmount,
         Substring( [column 0], 74, 6 )  AS PromotionProductCode,
         Substring( [column 0], 80, 6 )  AS DepartmentNumber,
         Substring( [column 0], 86, 1 )  AS TAX_TBL_1,
         Substring( [column 0], 87, 1 )  AS TAX_TBL_2,
         Substring( [column 0], 88, 1 )  AS TAX_TBL_3,
         Substring( [column 0], 89, 1 )  AS TAX_TBL_4,
         Substring( [column 0], 90, 1 )  AS TAX_TBL_5,
         Substring( [column 0], 91, 1 )  AS TAX_TBL_6,
         Substring( [column 0], 92, 2 )  AS ALLOW_FOOD_STAMP
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '136' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSPromotionSalesDetails]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 11 ) AS OwnerSequenceNumber,
         Substring( [column 0], 57, 11 ) AS PromotionSequenceNumber,
         Substring( [column 0], 68, 6 )  AS RecordAmount,
         Substring( [column 0], 74, 6 )  AS RecordCount,
         Substring( [column 0], 80, 4 )  AS PromotionGroupId,
         Substring( [column 0], 84, 4 )  AS ThresholdQty
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '137' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSSafeActivity]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 1 )  AS SafeActivityType,
         Substring( [column 0], 47, 6 )  AS SafeMediaNumber,
         Substring( [column 0], 53, 2 )  AS SafeMediaType,
         Substring( [column 0], 55, 11 ) AS POSAmount,
         Substring( [column 0], 66, 11 ) AS SafeAmount,
         Substring( [column 0], 77, 11 ) AS ForeignAmount,
         Substring( [column 0], 88, 6 )  AS EnvelopeNumber,
         Substring( [column 0], 94, 1 )  AS CommunicationStatus
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '411';

CREATE VIEW [Src].[VwPOSSalesReject]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 9 )  AS DayNumber,
         Substring( [column 0], 21, 6 )  AS ShiftNumber,
         Substring( [column 0], 27, 9 )  AS TransactionUID,
         Substring( [column 0], 36, 9 )  AS SequenceNumber,
         Substring( [column 0], 45, 9 )  AS ItemId,
         Substring( [column 0], 54, 14 ) AS PLUNumber,
         Substring( [column 0], 68, 6 )  AS BestBeforeDate,
         Substring( [column 0], 74, 6 )  AS SellByDate,
         Substring( [column 0], 80, 6 )  AS ExpirationDate,
         Substring( [column 0], 86, 10 ) AS ExpirationDateTime,
         Substring( [column 0], 96, 80 ) AS RejectedReason
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '462' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSSaleTransactionSummary]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordId,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 8 )   AS TransactionDate,
         Substring( [column 0], 20, 11 )  AS TransactionHour,
         Substring( [column 0], 31, 11 )  AS MerchandiseAmount,
         Substring( [column 0], 42, 11 )  AS GasSalesAmount,
         Substring( [column 0], 53, 11 )  AS MerchandiseCount,
         Substring( [column 0], 64, 11 )  AS GasSaleCount,
         Substring( [column 0], 75, 11 )  AS POSCount,
         Substring( [column 0], 86, 11 )  AS CRINDCount,
         Substring( [column 0], 97, 1 )   AS PeriodCode,
         Substring( [column 0], 98, 8 )   AS ExpiryDate,
         Substring( [column 0], 106, 11 ) AS MerchandiseUnits
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '138' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSShiftStatus]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordID,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 1 )  AS BackOfficeDayStatus,
         Substring( [column 0], 13, 1 )  AS POSPostingDayStatus,
         Substring( [column 0], 14, 6 )  AS DayNumber,
         Substring( [column 0], 20, 6 )  AS ShiftNumber,
         Substring( [column 0], 26, 8 )  AS BusinessDate,
         Substring( [column 0], 34, 14 ) AS ShiftStartDate,
         Substring( [column 0], 48, 14 ) AS ShiftEndDate
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '131' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSStoreEmployeeFile]
AS
  SELECT Substring( [column 0], 1, 2 )    AS RecordId,
         Substring( [column 0], 3, 6 )    AS StoreNumber,
         Substring( [column 0], 9, 3 )    AS TransactionType,
         Substring( [column 0], 12, 6 )   AS EmployeeNumber,
         Substring( [column 0], 18, 30 )  AS EmployeeName,
         Substring( [column 0], 48, 8 )   AS Password,
         Substring( [column 0], 56, 8 )   AS ClassId,
         Substring( [column 0], 64, 1 )   AS SecurityLevel,
         Substring( [column 0], 65, 9 )   AS SSN,
         Substring( [column 0], 74, 14 )  AS PasswordChangeDate,
         Substring( [column 0], 88, 8 )   AS Password2,
         Substring( [column 0], 96, 8 )   AS Password3,
         Substring( [column 0], 104, 8 )  AS Password4,
         Substring( [column 0], 112, 8 )  AS Password5,
         Substring( [column 0], 120, 8 )  AS Password6,
         Substring( [column 0], 128, 14 ) AS LockoutDate
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '134' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSTaxSales]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS DayNumber,
         Substring( [column 0], 18, 6 )  AS ShiftNumber,
         Substring( [column 0], 24, 11 ) AS TransactionUID,
         Substring( [column 0], 35, 11 ) AS SequenceNumber,
         Substring( [column 0], 46, 1 )  AS ErrorCorrectionFlag,
         Substring( [column 0], 47, 6 )  AS RecordType,
         Substring( [column 0], 53, 11 ) AS RecordAmount,
         Substring( [column 0], 64, 6 )  AS TaxTable,
         Substring( [column 0], 70, 1 )  AS IsVoid,
         Substring( [column 0], 71, 1 )  AS IsDeduct
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '125' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSTransactionHeader]
AS
  SELECT Rtrim( Ltrim( Substring( [column 0], 1, 2 ) ) )    AS RecordId,
         Rtrim( Ltrim( Substring( [column 0], 3, 6 ) ) )    AS StoreNumber,
         Rtrim( Ltrim( Substring( [column 0], 9, 3 ) ) )    AS TransactionType,
         Rtrim( Ltrim( Substring( [column 0], 12, 6 ) ) )   AS DayNumber,
         Rtrim( Ltrim( Substring( [column 0], 18, 6 ) ) )   AS ShiftNumber,
         Rtrim( Ltrim( Substring( [column 0], 24, 11 ) ) )  AS TransactionUID,
         Rtrim( Ltrim( Substring( [column 0], 35, 1 ) ) )   AS Aborted,
         Rtrim( Ltrim( Substring( [column 0], 36, 6 ) ) )   AS DeviceNumber,
         Rtrim( Ltrim( Substring( [column 0], 42, 6 ) ) )   AS DeviceType,
         Rtrim( Ltrim( Substring( [column 0], 48, 6 ) ) )   AS EmployeeNumber,
         Rtrim( Ltrim( Substring( [column 0], 54, 8 ) ) )   AS EndDate,
         Rtrim( Ltrim( Substring( [column 0], 62, 6 ) ) )   AS EndTime,
         Rtrim( Ltrim( Substring( [column 0], 68, 8 ) ) )   AS StartDate,
         Rtrim( Ltrim( Substring( [column 0], 76, 6 ) ) )   AS StartTime,
         Rtrim( Ltrim( Substring( [column 0], 82, 1 ) ) )   AS [Status],
         Rtrim( Ltrim( Substring( [column 0], 83, 11 ) ) )  AS TotalAmount,
         Rtrim( Ltrim( Substring( [column 0], 94, 6 ) ) )   AS TransactionCode,
         Rtrim( Ltrim( Substring( [column 0], 100, 11 ) ) ) AS TransactionSequence,
         Rtrim( Ltrim( Substring( [column 0], 111, 19 ) ) ) AS 7RewardMemberID
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '121' AND
         Substring( [column 0], 1, 2 ) = 'D1';

CREATE VIEW [Src].[VwPOSTransactionType]
AS
  SELECT Substring( [column 0], 1, 2 )   AS RecordId,
         Substring( [column 0], 3, 6 )   AS StoreNumber,
         Substring( [column 0], 9, 3 )   AS TransactionType,
         Substring( [column 0], 12, 6 )  AS TransactionCode,
         Substring( [column 0], 18, 20 ) AS TransactionDescription,
         Substring( [column 0], 38, 6 )  AS AddOrSubstruct
  FROM   ext.POS
  WHERE  Substring( [column 0], 9, 3 ) = '132' AND
         Substring( [column 0], 1, 2 ) = 'D1'; 

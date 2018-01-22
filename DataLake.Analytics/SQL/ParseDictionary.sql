CREATE VIEW [120].[VwPOSAmexCardSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 004 ) AS DayNumber,
 Substring( [column 0], 016, 004 ) AS ShiftNumber,
 Substring( [column 0], 020, 014 ) AS TransactionDate,
 Substring( [column 0], 034, 019 ) AS CardAccountNumber,
 Substring( [column 0], 053, 006 ) AS EmployeeNumber,
 Substring( [column 0], 059, 011 ) AS SequenceNumber,
 Substring( [column 0], 070, 003 ) AS DeviceNumber,
 Substring( [column 0], 073, 009 ) AS ApprovalCode,
 Substring( [column 0], 082, 004 ) AS ResponseCode,
 Substring( [column 0], 086, 006 ) AS STTNumber,
 Substring( [column 0], 092, 006 ) AS LoadAmount,
 Substring( [column 0], 098, 006 ) AS FeeAmount,
 Substring( [column 0], 104, 006 ) AS CardBalance,
 Substring( [column 0], 110, 001 ) AS VoidFlag,
 Substring( [column 0], 111, 006 ) AS EmbeddedFee,
 Substring( [column 0], 117, 006 ) AS VendorFee
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '120' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [121].[VwPOSTransactionHeader]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 001 ) AS Aborted,
 Substring( [column 0], 036, 006 ) AS DeviceNumber,
 Substring( [column 0], 042, 006 ) AS DeviceType,
 Substring( [column 0], 048, 006 ) AS EmployeeNumber,
 Substring( [column 0], 054, 008 ) AS EndDate,
 Substring( [column 0], 062, 006 ) AS EndTime,
 Substring( [column 0], 068, 008 ) AS StartDate,
 Substring( [column 0], 076, 006 ) AS StartTime,
 Substring( [column 0], 082, 001 ) AS Status,
 Substring( [column 0], 083, 011 ) AS TotalAmount,
 Substring( [column 0], 094, 006 ) AS TransactionCode,
 Substring( [column 0], 100, 011 ) AS TransactionSequence,
 Substring( [column 0], 111, 019 ) AS RewardMemberID
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '121' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [122].[VwPOSItemSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordID,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 011 ) AS ProductNumber,
 Substring( [column 0], 057, 014 ) AS PLUNumber,
 Substring( [column 0], 071, 011 ) AS RecordAmount,
 Substring( [column 0], 082, 006 ) AS RecordCount,
 Substring( [column 0], 088, 006 ) AS RecordType,
 Substring( [column 0], 094, 001 ) AS SizeIndx,
 Substring( [column 0], 095, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 096, 001 ) AS PriceOverideFlag,
 Substring( [column 0], 097, 001 ) AS TaxableFlag,
 Substring( [column 0], 098, 001 ) AS VoidFlag,
 Substring( [column 0], 099, 001 ) AS RecommendedFlag,
 Substring( [column 0], 100, 006 ) AS PriceMultiple,
 Substring( [column 0], 106, 006 ) AS CarryStatus,
 Substring( [column 0], 112, 001 ) AS TaxOverideFlag,
 Substring( [column 0], 113, 002 ) AS PromotionCount,
 Substring( [column 0], 115, 004 ) AS SalesPrice,
 Substring( [column 0], 119, 004 ) AS MUBasePrice,
 Substring( [column 0], 123, 014 ) AS HostItemId,
 Substring( [column 0], 137, 002 ) AS CouponCount
 FROM [Ext].[POS]
 WHERE Substring( [column 0], 009, 003 ) = '122'AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [123].[VwPOSDepartmentSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 006 ) AS DepartmentNumber,
 Substring( [column 0], 052, 006 ) AS SubDepartment,
 Substring( [column 0], 058, 006 ) AS RecordType,
 Substring( [column 0], 064, 006 ) AS RecordCount,
 Substring( [column 0], 070, 011 ) AS RecordAmount,
 Substring( [column 0], 081, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 082, 001 ) AS VoidFlag,
 Substring( [column 0], 083, 001 ) AS TaxableFlag,
 Substring( [column 0], 084, 001 ) AS PriceOverideFlag,
 Substring( [column 0], 085, 001 ) AS TaxOverideFlag,
 Substring( [column 0], 086, 014 ) AS HostItemId
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '123' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [124].[VwPOSMediaSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 006 ) AS MediaNumber,
 Substring( [column 0], 052, 011 ) AS NetworkMediaSequenceNumber,
 Substring( [column 0], 063, 002 ) AS MediaType,
 Substring( [column 0], 065, 006 ) AS RecordCount,
 Substring( [column 0], 071, 011 ) AS RecordAmount,
 Substring( [column 0], 082, 006 ) AS RecordType,
 Substring( [column 0], 088, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 089, 001 ) AS VoidFlag,
 Substring( [column 0], 090, 005 ) AS ExchangeRate,
 Substring( [column 0], 095, 011 ) AS ForeignAmount
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '124' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [125].[VwPOSTaxSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 047, 006 ) AS RecordType,
 Substring( [column 0], 053, 011 ) AS RecordAmount,
 Substring( [column 0], 064, 006 ) AS TaxTable,
 Substring( [column 0], 070, 001 ) AS IsVoid,
 Substring( [column 0], 071, 001 ) AS IsDeduct
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '125' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [127].[VwPOSComments]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumbar,
 Substring( [column 0], 046, 080 ) AS Comments,
 Substring( [column 0], 126, 006 ) AS RecordType
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '127' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [128].[VwPOSPaidInByReason]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 047, 011 ) AS Amount,
 Substring( [column 0], 058, 006 ) AS MediaNumber,
 Substring( [column 0], 064, 006 ) AS ReasonCode,
 Substring( [column 0], 070, 006 ) AS RecordType,
 Substring( [column 0], 076, 006 ) AS TerminalNumber,
 Substring( [column 0], 082, 001 ) AS VoidFlag
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '128' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [129].[VwPOSPaidOutByReason]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 047, 011 ) AS Amount,
 Substring( [column 0], 058, 006 ) AS MediaNumber,
 Substring( [column 0], 064, 006 ) AS ReasonCode,
 Substring( [column 0], 070, 006 ) AS RecordType,
 Substring( [column 0], 076, 006 ) AS TerminalNumber,
 Substring( [column 0], 082, 001 ) AS VoidFlag
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '129' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [130].[VwPOSFuelSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 006 ) AS RecordType,
 Substring( [column 0], 052, 006 ) AS DispenserNumber,
 Substring( [column 0], 058, 006 ) AS SaleProductId,
 Substring( [column 0], 064, 006 ) AS HoseNumber,
 Substring( [column 0], 070, 006 ) AS MediaNumber,
 Substring( [column 0], 076, 006 ) AS ServiceLevelId,
 Substring( [column 0], 082, 011 ) AS PricePerUnit,
 Substring( [column 0], 093, 011 ) AS SaleVolume,
 Substring( [column 0], 104, 011 ) AS CreePage,
 Substring( [column 0], 115, 011 ) AS RecordAmount,
 Substring( [column 0], 126, 006 ) AS FuelPriceTable,
 Substring( [column 0], 132, 006 ) AS FuelPriceGroup,
 Substring( [column 0], 138, 006 ) AS PrimaryTankNumber,
 Substring( [column 0], 144, 011 ) AS PrimaryTankVolume,
 Substring( [column 0], 155, 006 ) AS SecondaryTankNumber,
 Substring( [column 0], 161, 011 ) AS SecondaryTankVolume,
 Substring( [column 0], 172, 001 ) AS ManualFlag,
 Substring( [column 0], 173, 001 ) AS AutoFinalFlag,
 Substring( [column 0], 174, 006 ) AS DeviceType,
 Substring( [column 0], 180, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 181, 001 ) AS VoidFlag,
 Substring( [column 0], 182, 001 ) AS PrepayFlag,
 Substring( [column 0], 183, 011 ) AS MediaAdjustAmount,
 Substring( [column 0], 194, 011 ) AS AdjustPricePerUnit
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '130' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [131].[VwPOSShiftStatus]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordID,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 001 ) AS BackOfficeDayStatus,
 Substring( [column 0], 013, 001 ) AS POSPostingDayStatus,
 Substring( [column 0], 014, 006 ) AS DayNumber,
 Substring( [column 0], 020, 006 ) AS ShiftNumber,
 Substring( [column 0], 026, 008 ) AS BusinessDate,
 Substring( [column 0], 034, 014 ) AS ShiftStartDate,
 Substring( [column 0], 048, 014 ) AS ShiftEndDate
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '131' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [132].[VwPOSTransactionType]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS TransactionCode,
 Substring( [column 0], 018, 020 ) AS TransactionDescription,
 Substring( [column 0], 038, 006 ) AS AddOrSubstruct
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '132' AND
 Substring( [column 0], 001, 002 ) = 'D1'; 
GO
CREATE VIEW [133].[VwPOSICLoadSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 011 ) AS LoadSaleSequenceNumber,
 Substring( [column 0], 057, 004 ) AS RecordType,
 Substring( [column 0], 061, 006 ) AS LoadAmount,
 Substring( [column 0], 067, 006 ) AS BalanceAmount,
 Substring( [column 0], 073, 019 ) AS AccountNumber,
 Substring( [column 0], 092, 006 ) AS STTNumber,
 Substring( [column 0], 098, 006 ) AS AuthorizationTime,
 Substring( [column 0], 104, 012 ) AS AuthorizationNumber,
 Substring( [column 0], 116, 006 ) AS AuthorizationCode,
 Substring( [column 0], 122, 012 ) AS NetworkTerminal,
 Substring( [column 0], 134, 002 ) AS NetworkLocalTerminal,
 Substring( [column 0], 136, 014 ) AS PLUNumber,
 Substring( [column 0], 150, 011 ) AS ItemId,
 Substring( [column 0], 161, 011 ) AS ItmCostAmount,
 Substring( [column 0], 172, 011 ) AS VendorId,
 Substring( [column 0], 183, 006 ) AS FeeAmount,
 Substring( [column 0], 189, 006 ) AS FeeAmountEmbedded,
 Substring( [column 0], 195, 006 ) AS FeeAmountVendor
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '133' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [134].[VwPOSStoreEmployeeFile]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS EmployeeNumber,
 Substring( [column 0], 018, 030 ) AS EmployeeName,
 Substring( [column 0], 048, 008 ) AS Password,
 Substring( [column 0], 056, 008 ) AS ClassId,
 Substring( [column 0], 064, 001 ) AS SecurityLevel,
 Substring( [column 0], 065, 009 ) AS SSN,
 Substring( [column 0], 074, 014 ) AS PasswordChangeDate,
 Substring( [column 0], 088, 008 ) AS Password2,
 Substring( [column 0], 096, 008 ) AS Password3,
 Substring( [column 0], 104, 008 ) AS Password4,
 Substring( [column 0], 112, 008 ) AS Password5,
 Substring( [column 0], 120, 008 ) AS Password6,
 Substring( [column 0], 128, 014 ) AS LockoutDate
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '134' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [135].[VwPOSConfiguration]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS TerminalNumber,
 Substring( [column 0], 018, 006 ) AS Scanner,
 Substring( [column 0], 024, 006 ) AS MsrPort,
 Substring( [column 0], 030, 006 ) AS CustomerDisplayPort,
 Substring( [column 0], 036, 006 ) AS PinPadPort,
 Substring( [column 0], 042, 006 ) AS ForceDrop,
 Substring( [column 0], 048, 001 ) AS IsCloseDrawer,
 Substring( [column 0], 049, 001 ) AS IsShowSafeDrop,
 Substring( [column 0], 050, 001 ) AS IsOpenDrawer,
 Substring( [column 0], 051, 001 ) AS IsShiftSignOn,
 Substring( [column 0], 052, 001 ) AS IsPumpInterface,
 Substring( [column 0], 053, 001 ) AS IsAuditEOS,
 Substring( [column 0], 054, 001 ) AS IsRevenueEOS,
 Substring( [column 0], 055, 001 ) AS IsNetworkBatchEOS,
 Substring( [column 0], 056, 001 ) AS IsAcceptEOS,
 Substring( [column 0], 057, 001 ) AS IsAuditEOD,
 Substring( [column 0], 058, 001 ) AS IsRevenueEOD,
 Substring( [column 0], 059, 001 ) AS IsNetworkEOD,
 Substring( [column 0], 060, 001 ) AS IsAcceptEOD,
 Substring( [column 0], 061, 005 ) AS TerminalType,
 Substring( [column 0], 066, 006 ) AS AlarmDropAmount
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '135' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [136].[VwPOSPromotionSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 006 ) AS RecordType,
 Substring( [column 0], 052, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 053, 001 ) AS VoidFlag,
 Substring( [column 0], 054, 001 ) AS TaxableFlag,
 Substring( [column 0], 055, 001 ) AS TaxOverideFlag,
 Substring( [column 0], 056, 006 ) AS PromotionId,
 Substring( [column 0], 062, 006 ) AS RecordCount,
 Substring( [column 0], 068, 006 ) AS RecordAmount,
 Substring( [column 0], 074, 006 ) AS PromotionProductCode,
 Substring( [column 0], 080, 006 ) AS DepartmentNumber,
 Substring( [column 0], 086, 001 ) AS TAX_TBL_1,
 Substring( [column 0], 087, 001 ) AS TAX_TBL_2,
 Substring( [column 0], 088, 001 ) AS TAX_TBL_3,
 Substring( [column 0], 089, 001 ) AS TAX_TBL_4,
 Substring( [column 0], 090, 001 ) AS TAX_TBL_5,
 Substring( [column 0], 091, 001 ) AS TAX_TBL_6,
 Substring( [column 0], 092, 002 ) AS ALLOW_FOOD_STAMP
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '136' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [137].[VwPOSPromotionSalesDetails]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 011 ) AS OwnerSequenceNumber,
 Substring( [column 0], 057, 011 ) AS PromotionSequenceNumber,
 Substring( [column 0], 068, 006 ) AS RecordAmount,
 Substring( [column 0], 074, 006 ) AS RecordCount,
 Substring( [column 0], 080, 004 ) AS PromotionGroupId,
 Substring( [column 0], 084, 004 ) AS ThresholdQty
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '137' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [138].[VwPOSSaleTransactionSummary]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 008 ) AS TransactionDate,
 Substring( [column 0], 020, 011 ) AS TransactionHour,
 Substring( [column 0], 031, 011 ) AS MerchandiseAmount,
 Substring( [column 0], 042, 011 ) AS GasSalesAmount,
 Substring( [column 0], 053, 011 ) AS MerchandiseCount,
 Substring( [column 0], 064, 011 ) AS GasSaleCount,
 Substring( [column 0], 075, 011 ) AS POSCount,
 Substring( [column 0], 086, 011 ) AS CRINDCount,
 Substring( [column 0], 097, 001 ) AS PeriodCode,
 Substring( [column 0], 098, 008 ) AS ExpiryDate,
 Substring( [column 0], 106, 011 ) AS MerchandiseUnits
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '138' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [139].[VwPOSNetworkSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 004 ) AS OwnerSequenceNumber,
 Substring( [column 0], 050, 040 ) AS AccountNumber,
 Substring( [column 0], 090, 010 ) AS BatchNumber,
 Substring( [column 0], 100, 010 ) AS BatchSequenceNumber,
 Substring( [column 0], 110, 004 ) AS CardTransactionFee,
 Substring( [column 0], 114, 006 ) AS RecordType,
 Substring( [column 0], 120, 012 ) AS ReponseCodeText,
 Substring( [column 0], 132, 012 ) AS AuthorizationNumber,
 Substring( [column 0], 144, 006 ) AS AuthorizationCode1,
 Substring( [column 0], 150, 006 ) AS AuthorizationCode2,
 Substring( [column 0], 156, 026 ) AS CustomerName,
 Substring( [column 0], 182, 010 ) AS EntryType,
 Substring( [column 0], 192, 004 ) AS ExpirationDate,
 Substring( [column 0], 196, 006 ) AS AuthorizationTime,
 Substring( [column 0], 202, 010 ) AS VehicleNumber,
 Substring( [column 0], 212, 010 ) AS OdometerReading,
 Substring( [column 0], 222, 010 ) AS DriverNumber,
 Substring( [column 0], 232, 014 ) AS CustomizedReferenceNumber,
 Substring( [column 0], 246, 003 ) AS AccountType,
 Substring( [column 0], 249, 006 ) AS AuthorizationTraceId,
 Substring( [column 0], 255, 020 ) AS AuthorizationPartyName,
 Substring( [column 0], 275, 006 ) AS STTNumber,
 Substring( [column 0], 281, 004 ) AS BalanceAmount,
 Substring( [column 0], 285, 040 ) AS MaskedAccountNumber,
 Substring( [column 0], 325, 009 ) AS RoutingNumber,
 Substring( [column 0], 334, 010 ) AS CheckNumber,
 Substring( [column 0], 344, 010 ) AS CardType,
 Substring( [column 0], 354, 011 ) AS Amount
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '139' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [140].[VwPOSMoneyOrderSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 006 ) AS MoneyOrderSaleAmount,
 Substring( [column 0], 052, 004 ) AS MoneyOrderFeeAmount,
 Substring( [column 0], 056, 012 ) AS MoneyOrderSerialNumber,
 Substring( [column 0], 068, 010 ) AS MoneyOrderDepartmentSaleSeqNumber,
 Substring( [column 0], 078, 010 ) AS MoneyOrderDepartmentFeeNumber,
 Substring( [column 0], 088, 010 ) AS MoneyOrderPrintedFlg
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '140' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [409].[VwPOSCouponSales]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 009 ) AS DayNumber,
 Substring( [column 0], 021, 006 ) AS ShiftNumber,
 Substring( [column 0], 027, 009 ) AS TransactionUID,
 Substring( [column 0], 036, 009 ) AS SequenceNumber,
 Substring( [column 0], 045, 009 ) AS CouponId,
 Substring( [column 0], 054, 018 ) AS CouponDescription,
 Substring( [column 0], 072, 022 ) AS PLUNumber,
 Substring( [column 0], 094, 002 ) AS CouponType,
 Substring( [column 0], 096, 002 ) AS CouponValueCode,
 Substring( [column 0], 098, 009 ) AS EntryMethod,
 Substring( [column 0], 107, 009 ) AS HostMediaNumber,
 Substring( [column 0], 116, 009 ) AS RecordAmount,
 Substring( [column 0], 125, 009 ) AS RecordCount,
 Substring( [column 0], 134, 001 ) AS ErrorCorrectionFlag,
 Substring( [column 0], 135, 001 ) AS VoidFlag,
 Substring( [column 0], 136, 001 ) AS TaxableFlag,
 Substring( [column 0], 137, 001 ) AS TaxOverrideFlag,
 Substring( [column 0], 138, 001 ) AS AnnulFlag,
 Substring( [column 0], 139, 015 ) AS PrimaryCompanyId,
 Substring( [column 0], 154, 006 ) AS OfferCode,
 Substring( [column 0], 160, 009 ) AS SaveValue,
 Substring( [column 0], 169, 009 ) AS PrimaryPurchaseRequirement,
 Substring( [column 0], 178, 001 ) AS PrimaryPurchaseRequirementCode,
 Substring( [column 0], 179, 003 ) AS PrimaryPurchaseFamilyCode,
 Substring( [column 0], 182, 001 ) AS AdditionalPurchaseRulesCode,
 Substring( [column 0], 183, 009 ) AS SecondPurchaseRequirement,
 Substring( [column 0], 192, 001 ) AS SecondPurchaseRequirementCode,
 Substring( [column 0], 193, 003 ) AS SecondPurchaseFamilyCode,
 Substring( [column 0], 196, 015 ) AS SecondCompanyId,
 Substring( [column 0], 211, 009 ) AS ThirdPurchaseRequirement,
 Substring( [column 0], 220, 001 ) AS ThirdPurchaseRequirementCode,
 Substring( [column 0], 221, 003 ) AS ThirdPurchaseFamilyCode,
 Substring( [column 0], 224, 015 ) AS ThirdCompanyId,
 Substring( [column 0], 239, 006 ) AS ExpirationDate,
 Substring( [column 0], 245, 006 ) AS StartDate,
 Substring( [column 0], 251, 015 ) AS SerialNumber,
 Substring( [column 0], 266, 015 ) AS RetailerId,
 Substring( [column 0], 281, 001 ) AS SaveValueCode,
 Substring( [column 0], 282, 001 ) AS DiscountedItem,
 Substring( [column 0], 283, 001 ) AS StoreCouponIndicator,
 Substring( [column 0], 284, 001 ) AS NoMultiplyFlag
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '409' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [410].[VwPOSCouponSalesDetails]
AS
 SELECT
 Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 010 ) AS TransactionUID,
 Substring( [column 0], 034, 010 ) AS SequenceNumber,
 Substring( [column 0], 044, 010 ) AS OwnerSequenceNumber,
 Substring( [column 0], 054, 010 ) AS CouponCouponNumber,
 Substring( [column 0], 064, 006 ) AS RecordCount,
 Substring( [column 0], 070, 001 ) AS ReportedItemFlag,
 Substring( [column 0], 071, 001 ) AS OwnerType
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '410' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [411].[VwPOSSafeActivity]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 006 ) AS DayNumber,
 Substring( [column 0], 018, 006 ) AS ShiftNumber,
 Substring( [column 0], 024, 011 ) AS TransactionUID,
 Substring( [column 0], 035, 011 ) AS SequenceNumber,
 Substring( [column 0], 046, 001 ) AS SafeActivityType,
 Substring( [column 0], 047, 006 ) AS SafeMediaNumber,
 Substring( [column 0], 053, 002 ) AS SafeMediaType,
 Substring( [column 0], 055, 011 ) AS POSAmount,
 Substring( [column 0], 066, 011 ) AS SafeAmount,
 Substring( [column 0], 077, 011 ) AS ForeignAmount,
 Substring( [column 0], 088, 006 ) AS EnvelopeNumber,
 Substring( [column 0], 094, 001 ) AS CommunicationStatus
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '411' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [462].[VwPOSSalesReject]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 009 ) AS DayNumber,
 Substring( [column 0], 021, 006 ) AS ShiftNumber,
 Substring( [column 0], 027, 009 ) AS TransactionUID,
 Substring( [column 0], 036, 009 ) AS SequenceNumber,
 Substring( [column 0], 045, 009 ) AS ItemId,
 Substring( [column 0], 054, 014 ) AS PLUNumber,
 Substring( [column 0], 068, 006 ) AS BestBeforeDate,
 Substring( [column 0], 074, 006 ) AS SellByDate,
 Substring( [column 0], 080, 006 ) AS ExpirationDate,
 Substring( [column 0], 086, 010 ) AS ExpirationDateTime,
 Substring( [column 0], 096, 080 ) AS RejectedReason
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '462' AND
 Substring( [column 0], 001, 002 ) = 'D1';
GO
CREATE VIEW [463].[VwPOSCouponReject]
AS
 SELECT Substring( [column 0], 001, 002 ) AS RecordId,
 Substring( [column 0], 003, 006 ) AS StoreNumber,
 Substring( [column 0], 009, 003 ) AS TransactionType,
 Substring( [column 0], 012, 009 ) AS DayNumber,
 Substring( [column 0], 021, 006 ) AS ShiftNumber,
 Substring( [column 0], 027, 009 ) AS TransactionUID,
 Substring( [column 0], 036, 009 ) AS SequenceNumber,
 Substring( [column 0], 045, 022 ) AS PLUNumber,
 Substring( [column 0], 067, 015 ) AS PrimaryCompany,
 Substring( [column 0], 082, 006 ) AS OfferCode,
 Substring( [column 0], 088, 009 ) AS SaveValue,
 Substring( [column 0], 097, 009 ) AS PrimaryPurchaseRequirement,
 Substring( [column 0], 106, 001 ) AS PrimaryPurchaseRequirementCode,
 Substring( [column 0], 107, 003 ) AS PrimaryPurchaseFamilyCode,
 Substring( [column 0], 110, 001 ) AS AdditionalPurchaseRulesCode,
 Substring( [column 0], 111, 009 ) AS SecondPurchaseRequirement,
 Substring( [column 0], 120, 001 ) AS SecondPurchaseRequirementCode,
 Substring( [column 0], 121, 003 ) AS SecondPurchaseFamilyCode,
 Substring( [column 0], 124, 015 ) AS SecondCompany,
 Substring( [column 0], 139, 009 ) AS ThirdPurchaseRequirement,
 Substring( [column 0], 148, 001 ) AS ThirdPurchaseRequirementCode,
 Substring( [column 0], 149, 003 ) AS ThirdPurchaseFamilyCode,
 Substring( [column 0], 152, 015 ) AS ThirdCompany,
 Substring( [column 0], 167, 006 ) AS ExpirationDate,
 Substring( [column 0], 173, 006 ) AS StartDate,
 Substring( [column 0], 179, 015 ) AS SerialNumber,
 Substring( [column 0], 194, 015 ) AS RetailerID,
 Substring( [column 0], 209, 001 ) AS SaveValueCode,
 Substring( [column 0], 210, 001 ) AS DiscountedItem,
 Substring( [column 0], 211, 001 ) AS IsStoreCoupon,
 Substring( [column 0], 212, 001 ) AS IsMultiple,
 Substring( [column 0], 213, 080 ) AS RejectReason
 FROM ext.POS
 WHERE Substring( [column 0], 009, 003 ) = '463' AND
 Substring( [column 0], 001, 002 ) = 'D1';
Go

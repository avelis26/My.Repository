/****** Object:  StoredProcedure [dbo].[uspAggregateTables_agg1]    Script Date: 2/6/2018 10:38:23 AM ******/
USE								[7ELE]
GO
IF EXISTS						(SELECT * FROM sys.procedures WHERE name = 'uspAggregateTables_agg1_test')
BEGIN
DROP PROCEDURE					[dbo].[uspAggregateTables_agg1_test]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAggregateTables_agg1_test]
	@StartDate date,
	@EndDate date
AS
SET NOCOUNT ON
TRUNCATE TABLE [dbo].[Agg1_DaypartAggregate_Backup]
TRUNCATE TABLE [dbo].[tmp_query_data_joined]






IF EXISTS					(SELECT * FROM sys.tables WHERE name = 'tmp_query_data_joined_test')
BEGIN
DROP TABLE					[dbo].[tmp_query_data_joined_test]
CREATE TABLE				[dbo].[tmp_query_data_joined_test]		(
							[RecordId]								[varchar](2)		NULL,
							[StoreNumber]							[int] NULL,
							[TransactionType]						[int] NOT NULL,
							[DayNumber]								[int] NOT NULL,
							[ShiftNumber]							[int] NOT NULL,
							[TransactionUID]						[int] NOT NULL,
							[Aborted]								[bit] NULL,
							[DeviceNumber]							[int] NULL,
							[DeviceType]							[int] NULL,
							[EmployeeNumber]						[int] NULL,
							[EndDate]								[date] NULL,
							[EndTime]								[time](7) NULL,
							[StartDate]								[date] NOT NULL,
							[StartTime]								[time](7) NULL,
							[Status]								[tinyint] NULL,
							[TotalAmount]							[money] NULL,
							[TransactionCode]						[int] NULL,
							[TransactionSequence]					[int] NULL,
							[RewardMemberID]						[varchar](20) NULL,
							[Header_Id]								[int] NOT NULL,
							[SequenceNumber]						[int] NULL,
							[ProductNumber]							[int] NULL,
							[PLUNumber]								[varchar](14) NULL,
							[RecordAmount]							[money] NULL,
							[RecordCount]							[int] NULL,
							[RecordType]							[int] NULL,
							[SizeIndx]								[int] NULL,
							[ErrorCorrectionFlag]					[bit] NULL,
							[PriceOverideFlag]						[bit] NULL,
							[TaxableFlag]							[bit] NULL,
							[VoidFlag]								[bit] NULL,
							[RecommendedFlag]						[bit] NULL,
							[PriceMultiple]							[int] NULL,
							[CarryStatus]							[int] NULL,
							[TaxOverideFlag]						[bit] NULL,
							[PromotionCount]						[int] NULL,
							[SalesPrice]							[money] NULL,
							[MUBasePrice]							[money] NULL,
							[HostItemId]							[varchar](20) NULL,
							[CouponCount]							[int] NULL,
							[Detail_Id]								[int] NOT NULL
) ON [PRIMARY]
END





















ALTER INDEX ALL ON tmp_query_data_joined
DISABLE;	 
	
insert into tmp_query_data_joined
	select 
	   th.[RecordId]
      ,th.[StoreNumber]
      ,th.[TransactionType]
      ,th.[DayNumber]
      ,th.[ShiftNumber]
      ,th.[TransactionUID]
      ,[Aborted]
      ,[DeviceNumber]
      ,[DeviceType]
      ,[EmployeeNumber]
      ,[EndDate]
      ,[EndTime]
      ,[StartDate]
      ,[StartTime]
      ,[Status]
      ,[TotalAmount]
      ,[TransactionCode]
      ,[TransactionSequence]
      ,[RewardMemberID]
      ,[Header_Id] 
      ,[SequenceNumber]
      ,[ProductNumber]
      ,[PLUNumber]
      ,[RecordAmount]
      ,[RecordCount]
      ,[RecordType]
      ,[SizeIndx]
      ,[ErrorCorrectionFlag]
      ,[PriceOverideFlag]
      ,[TaxableFlag]
      ,[VoidFlag]
      ,[RecommendedFlag]
      ,[PriceMultiple]
      ,[CarryStatus]
      ,[TaxOverideFlag]
      ,[PromotionCount]
      ,[SalesPrice]
      ,[MUBasePrice]
      ,[HostItemId]
      ,[CouponCount]
      ,[Detail_Id]
  
  from 
	[dbo].[prod_122_Details] AS td
	 INNER JOIN tmp_header_table AS th
		  ON td.StoreNumber = th.StoreNumber  
		  AND td.DayNumber = th.DayNumber  
		  AND td.ShiftNumber = th.ShiftNumber 
		  AND td.TransactionUID = th.TransactionUID  


/* Enable Index */ 
--16.47 mins
ALTER INDEX ALL ON tmp_query_data_joined
REBUILD;	






--STEP 3: CREATING FINAL TABLE WITH JOINS TO STORE AND PRODUCT TABLE 
--Joining to store table and product table 
truncate table tmp_query_data_FINAL


/* Disable Index */ 
ALTER INDEX ALL ON tmp_query_data_FINAL
DISABLE;



--1.36 hrs
insert into tmp_query_data_FINAL

SELECT 
	 X.*
 	,PSA_Cd
	,PSA_Ds
	,Category_Cd
	,Category_Ds 
	,SubCategory_Cd  
FROM
	 tmp_query_data_joined x
	 INNER JOIN [dbo].[ext_storeTable] AS sm
		  ON x.StoreNumber = sm.Store_Id
	 INNER JOIN [dbo].[ext_productTable] AS pr
		  ON slin = x.ProductNumber
		  AND UPC=x.PLUNumber 
WHERE 1=1 
	AND x.RecordType IN (1,5,18)
	AND x.Aborted = 0
	AND x.VoidFlag = 0 

/* Enable Index */ 
--36.24 mins
ALTER INDEX ALL ON tmp_query_data_FINAL
REBUILD;	


--select * from [Agg1_DaypartAggregate]

--STEP 4: DOING FINAL AGGREGATIONS FOR AGGREGATE 1 BASED ON THE TABLE CREATED IN LAST STEP
truncate table [dbo].[Agg1_DaypartAggregate]

--59.47 mins
insert into [dbo].[Agg1_DaypartAggregate]
	SELECT 
	EndDate
	,StoreNumber
	,PSA_Cd
	,PSA_Ds
	,Category_Cd
	,Category_Ds 
	,[Member_Status] = CASE WHEN RewardMemberID IS NULL THEN 'Non-Member' ELSE 'Member' END
	,Txn_Cnt_DayP1	= COUNT(DISTINCT(CASE WHEN EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' THEN (CONCAT(StoreNumber,DayNumber,ShiftNumber,TransactionUID,TransactionSequence))END))
	,Txn_Cnt_DayP2	= COUNT(DISTINCT(CASE WHEN EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' THEN (CONCAT(StoreNumber,DayNumber,ShiftNumber,TransactionUID,TransactionSequence))END))
	,Txn_Cnt_DayP3	= COUNT(DISTINCT(CASE WHEN EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' THEN (CONCAT(StoreNumber,DayNumber,ShiftNumber,TransactionUID,TransactionSequence))END))
	,Txn_Cnt_DayP4	= COUNT(DISTINCT(CASE WHEN EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' THEN (CONCAT(StoreNumber,DayNumber,ShiftNumber,TransactionUID,TransactionSequence))END))
	,Txn_Cnt_DayP5	= COUNT(DISTINCT(CASE WHEN EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' THEN (CONCAT(StoreNumber,DayNumber,ShiftNumber,TransactionUID,TransactionSequence))END))
	,Txn_Cnt_DayP6	= COUNT(DISTINCT(CASE WHEN EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' THEN (CONCAT(StoreNumber,DayNumber,ShiftNumber,TransactionUID,TransactionSequence))END))
	,Txn_Cnt_DayP7	= COUNT(DISTINCT(CASE WHEN EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' THEN (CONCAT(StoreNumber,DayNumber,ShiftNumber,TransactionUID,TransactionSequence))END))

---Total Amount - Daypart---
	,[Ttl_Amt_DayP1] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' THEN 0  
										  WHEN EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' AND RecordType IN (5) THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' AND RecordType IN (1) THEN RecordAmount 
									 END),0)

	,[Ttl_Amt_DayP2]  = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' THEN 0  
										  WHEN EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' AND RecordType IN (5) THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' AND RecordType IN (1) THEN RecordAmount 
									 END),0)
			
	,[Ttl_Amt_DayP3] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' THEN 0  
										  WHEN EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' AND RecordType IN (5) THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' AND RecordType IN (1) THEN RecordAmount 
									 END),0)

	,[Ttl_Amt_DayP4] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' THEN 0  
										  WHEN EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' AND RecordType IN (5) THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' AND RecordType IN (1) THEN RecordAmount 
									 END),0)

	,[Ttl_Amt_DayP5] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' THEN 0  
										 WHEN EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * ABS(RecordAmount) 
										 WHEN EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' AND RecordType IN (5) THEN (-1) * ABS(RecordAmount) 
										 WHEN EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' AND RecordType IN (1) THEN RecordAmount 
									END),0)
			
	,[Ttl_Amt_DayP6] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' THEN 0  
										 WHEN EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * ABS(RecordAmount) 
										 WHEN EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' AND RecordType IN (5) THEN (-1) * ABS(RecordAmount) 
										 WHEN EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' AND RecordType IN (1) THEN RecordAmount 
									END),0)

	,[Ttl_Amt_DayP7] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' THEN 0  
										  WHEN EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' AND RecordType IN (5) THEN (-1) * ABS(RecordAmount) 
										  WHEN EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' AND RecordType IN (1) THEN RecordAmount 
								     END),0)



---Item Count - Daypart---
	,[Ttl_Itm_Amt_DayP1] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' THEN 0  
										  WHEN EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * RecordCount
										  WHEN EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' AND RecordType IN (5) THEN (-1) * RecordCount 
										  WHEN EndTime >= '00:00:00.0000000' AND EndTime < '06:00:00.0000000' AND RecordType IN (1) THEN RecordCount
								     END),0)
		
	,[Ttl_Itm_Amt_DayP2]	= ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' THEN 0  
										  WHEN EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * RecordCount 
										  WHEN EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' AND RecordType IN (5) THEN (-1) * RecordCount 
										  WHEN EndTime >= '06:00:00.0000000' AND EndTime < '09:00:00.0000000' AND RecordType IN (1) THEN RecordCount
								      END),0)

	,[Ttl_Itm_Amt_DayP3] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' THEN 0  
										  WHEN EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * RecordCount 
										  WHEN EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' AND RecordType IN (5) THEN (-1) * RecordCount 
										  WHEN EndTime >= '09:00:00.0000000' AND EndTime < '11:00:00.0000000' AND RecordType IN (1) THEN RecordCount
								      END),0)
	
	,[Ttl_Itm_Amt_DayP4] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' THEN 0  
										  WHEN EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * RecordCount 
										  WHEN EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' AND RecordType IN (5) THEN (-1) * RecordCount 
										  WHEN EndTime >= '11:00:00.0000000' AND EndTime < '14:00:00.0000000' AND RecordType IN (1) THEN RecordCount
								      END),0)

	,[Ttl_Itm_Amt_DayP5] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' THEN 0  
										  WHEN EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * RecordCount 
										  WHEN EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' AND RecordType IN (5) THEN (-1) * RecordCount 
										  WHEN EndTime >= '14:00:00.0000000' AND EndTime < '16:00:00.0000000' AND RecordType IN (1) THEN RecordCount
								      END),0)	
		
	,[Ttl_Itm_Amt_DayP6] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' THEN 0  
										  WHEN EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * RecordCount 
										  WHEN EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' AND RecordType IN (5) THEN (-1) * RecordCount 
										  WHEN EndTime >= '16:00:00.0000000' AND EndTime < '19:00:00.0000000' AND RecordType IN (1) THEN RecordCount
								      END),0)
		
	,[Ttl_Itm_Amt_DayP7] = ISNULL(SUM(CASE WHEN RecordType IN (18) AND EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' THEN 0  
										  WHEN EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' AND RecordType IN (1) AND SubCategory_Cd = '99' THEN (-1) * RecordCount 
										  WHEN EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' AND RecordType IN (5) THEN (-1) * RecordCount 
										  WHEN EndTime >= '19:00:00.0000000' AND EndTime < '23:59:59.9999999' AND RecordType IN (1) THEN RecordCount
								      END),0)

--select *
FROM tmp_query_data_FINAL  
--where StoreNumber=17203 and DayNumber=8473 and ShiftNumber=1 and transactionUID=237
GROUP BY
	EndDate
	,StoreNumber
	,PSA_Cd
	,CASE WHEN RewardMemberID IS NULL THEN 'Non-Member' ELSE 'Member' END
	,PSA_Ds
	,Category_Cd
	,Category_Ds 
 
GO



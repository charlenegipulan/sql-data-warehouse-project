-- Stored Procedure: Load Bronze Layer (Source->Bronze)

--   Purpose: Loads data into 'bronze' schema from external CSV files.
--   It performs the following actions:
--   - Truncates bronze tables before loading data
--   - Uses BULK INSERT to load data from csv files into bronze tables

-- Usage example:
--   EXEC bronze.load_bronze;

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '====================';
        PRINT 'Loading Bronze Layer';
        PRINT '====================';

        PRINT '-----------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>>Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM '/data/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
        PRINT '...............';

        PRINT '>>Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>>Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM '/data/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
        PRINT '...............';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '>>Inserting Data Into: crm_sales_detail';
        BULK INSERT bronze.crm_sales_details
        FROM '/data/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
        PRINT '...............';

        PRINT '-----------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>>Inserting Data Into: erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM '/data/source_erp/CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
        PRINT '...............';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>>Inserting Data Into: erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM '/data/source_erp/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
        PRINT '...............';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>>Inserting Data Into: erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/data/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + 'seconds';
        PRINT '...............';

        SET @batch_end_time = GETDATE();
        PRINT '>> Loading Bronze Layer is Completed: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) as NVARCHAR) + 'seconds';
        PRINT '...............';

    END TRY
    BEGIN CATCH
        PRINT '=================='
        PRINT 'Error Occured During Loading Bronze Layer'
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '=================='
    END CATCH
END

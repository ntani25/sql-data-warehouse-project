/*
=========================================================================================================================
Use an External SQL Script: Load Bronze Layer (Source -> Bronze)
=========================================================================================================================
Script Purpose:
  These queries load data into the 'bronze' schema from external CSV files. The queries can be saved in a local script file 
  and ran all at once using your client interface.
  It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the LOAD DATA LOCAL INFILE command to load data from csv Files to bronze tables.

Parameters:
  None.
  This SQL script does not accept any parameters or return any values.
========================================================================================================================
*/
TRUNCATE TABLE crm_cust_info;


LOAD DATA LOCAL INFILE "C:/Users/ntani/OneDrive/Documents/10 docs/sql by Bara/sql-data-warehouse-project/datasets/source_crm/cust_info.csv"
	INTO TABLE crm_cust_info
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	-- 1. Read raw CSV fields into temporary @variables instead of direct columns
	(@v_id, @v_key, @v_firstname, @v_lastname, @v_marital_status, @v_gndr, @v_create_date)
	-- 2. Explicitly map variables to columns, catching empty strings and converting them to NULL
	SET 
		cst_id             = NULLIF(TRIM(@v_id), ''),
		cst_key            = NULLIF(TRIM(@v_key), ''),
		cst_firstname      = NULLIF(TRIM(@v_firstname), ''),
		cst_lastname       = NULLIF(TRIM(@v_lastname), ''),
		cst_marital_status = NULLIF(TRIM(@v_marital_status), ''),
		cst_gndr           = NULLIF(TRIM(@v_gndr), ''),
		-- Dates are especially fragile; handle empty or malformed strings gracefully
		cst_create_date    = IF(TRIM(@v_create_date) = '' OR @v_create_date IS NULL, NULL, STR_TO_DATE(TRIM(@v_create_date), '%Y-%m-%d'));


TRUNCATE TABLE crm_prd_info; 
        
LOAD DATA LOCAL INFILE "C:/Users/ntani/OneDrive/Documents/10 docs/sql by Bara/sql-data-warehouse-project/datasets/source_crm/prd_info.csv"
	INTO TABLE crm_prd_info
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	-- 1. Read raw CSV fields into temporary variables
	(@v_id, @v_key, @v_nm, @v_cost, @v_line, @v_start_dt, @v_end_dt)
	-- 2. Map and clean fields into the target schema
	SET 
		prd_id       = NULLIF(TRIM(@v_id), ''),
		prd_key      = NULLIF(TRIM(@v_key), ''),
		prd_nm       = NULLIF(TRIM(@v_nm), ''),
		
		-- Handle numeric cost safely (substitute 0 or NULL for missing values)
		prd_cost     = IF(TRIM(@v_cost) = '' OR @v_cost IS NULL, NULL, CAST(TRIM(@v_cost) AS SIGNED)),
		
		prd_line     = NULLIF(TRIM(@v_line), ''),
		
		-- Handle DATETIME parsing safely
		prd_start_dt = IF(TRIM(@v_start_dt) = '' OR @v_start_dt IS NULL, NULL, STR_TO_DATE(TRIM(@v_start_dt), '%Y-%m-%d %H:%i:%s')),
		prd_end_dt   = IF(TRIM(@v_end_dt) = '' OR @v_end_dt IS NULL, NULL, STR_TO_DATE(TRIM(@v_end_dt), '%Y-%m-%d %H:%i:%s'));


TRUNCATE TABLE crm_sales_details;
    
LOAD DATA LOCAL INFILE "C:/Users/ntani/OneDrive/Documents/10 docs/sql by Bara/sql-data-warehouse-project/datasets/source_crm/sales_details.csv"
	INTO TABLE crm_sales_details
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	-- 1. Read raw CSV fields into temporary variables
	(@v_ord_num, @v_prd_key, @v_cust_id, @v_order_dt, @v_ship_dt, @v_due_dt, @v_sales_dt, @v_quantity_dt, @v_price_dt)
	-- 2. Map fields and handle missing or blank data fields safely
	SET 
		sls_ord_num     = NULLIF(TRIM(@v_ord_num), ''),
		sls_prd_key     = NULLIF(TRIM(@v_prd_key), ''),
		
		-- Handle integers cleanly (convert empty values to NULL instead of breaking)
		sls_cust_id     = IF(TRIM(@v_cust_id) = '' OR @v_cust_id IS NULL, NULL, CAST(TRIM(@v_cust_id) AS SIGNED)),
		sls_order_dt    = IF(TRIM(@v_order_dt) = '' OR @v_order_dt IS NULL, NULL, CAST(TRIM(@v_order_dt) AS SIGNED)),
		sls_ship_dt     = IF(TRIM(@v_ship_dt) = '' OR @v_ship_dt IS NULL, NULL, CAST(TRIM(@v_ship_dt) AS SIGNED)),
		sls_due_dt      = IF(TRIM(@v_due_dt) = '' OR @v_due_dt IS NULL, NULL, CAST(TRIM(@v_due_dt) AS SIGNED)),
		sls_sales_dt    = IF(TRIM(@v_sales_dt) = '' OR @v_sales_dt IS NULL, NULL, CAST(TRIM(@v_sales_dt) AS SIGNED)),
		sls_quantity_dt = IF(TRIM(@v_quantity_dt) = '' OR @v_quantity_dt IS NULL, NULL, CAST(TRIM(@v_quantity_dt) AS SIGNED)),
		sls_price_dt    = IF(TRIM(@v_price_dt) = '' OR @v_price_dt IS NULL, NULL, CAST(TRIM(@v_price_dt) AS SIGNED));


TRUNCATE TABLE erp_cust_az12;
    
LOAD DATA LOCAL INFILE "C:/Users/ntani/OneDrive/Documents/10 docs/sql by Bara/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv"
	INTO TABLE erp_cust_az12
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	-- 1. Read raw CSV fields into temporary variables
	(@v_cid, @v_bdate, @v_gen)
	-- 2. Clean fields and parse dates safely
	SET 
		cid   = NULLIF(TRIM(@v_cid), ''),
		
		-- Safely convert birth dates, handling blanks or format mismatches
		bdate = IF(TRIM(@v_bdate) = '' OR @v_bdate IS NULL, NULL, STR_TO_DATE(TRIM(@v_bdate), '%Y-%m-%d')),
		
		gen   = NULLIF(TRIM(@v_gen), '');

	
TRUNCATE TABLE erp_loc_a101;
    
LOAD DATA LOCAL INFILE "C:/Users/ntani/OneDrive/Documents/10 docs/sql by Bara/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv"
	INTO TABLE erp_loc_a101
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	-- 1. Read raw CSV fields into temporary variables
	(@v_cid, @v_cntry)
	-- 2. Map fields and catch missing text values safely
	SET 
		cid   = NULLIF(TRIM(@v_cid), ''),
		cntry = NULLIF(TRIM(@v_cntry), '');

	
TRUNCATE TABLE erp_px_cat_g1v2;
    
LOAD DATA LOCAL INFILE "C:/Users/ntani/OneDrive/Documents/10 docs/sql by Bara/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv"
	INTO TABLE erp_px_cat_g1v2
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	-- 1. Read raw CSV fields into temporary variables
	(@v_id, @v_cat, @v_subcat, @v_maintenance)
	-- 2. Map fields and catch missing text values safely
	SET 
		id          = NULLIF(TRIM(@v_id), ''),
		cat         = NULLIF(TRIM(@v_cat), ''),
		subcat      = NULLIF(TRIM(@v_subcat), ''),
		maintenance = NULLIF(TRIM(@v_maintenance), '');       

SELECT 
    TABLE_NAME AS 'Loaded Table', 
    TABLE_ROWS AS 'Total Row Count', 
    CONCAT(ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024, 2), ' KB') AS 'Total Storage Size'
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dw_bronze'
  AND TABLE_NAME IN ('crm_cust_info', 'crm_prd_info', 'crm_sales_details', 'erp_cust_az12', 'erp_loc_a101', 'erp_px_cat_g1v2')
ORDER BY FIELD(TABLE_NAME, 'crm_cust_info', 'crm_prd_info', 'crm_sales_details', 'erp_cust_az12', 'erp_loc_a101', 'erp_px_cat_g1v2');

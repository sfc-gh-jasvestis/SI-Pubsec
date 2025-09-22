-- Troubleshooting Script for Schema Creation Issues
-- Singapore Smart Nation Intelligence Demo

-- Step 1: Check current context and permissions
SELECT 'TROUBLESHOOTING: Current Context' as STEP;

SELECT 
    CURRENT_ROLE() as CURRENT_ROLE,
    CURRENT_DATABASE() as CURRENT_DATABASE,
    CURRENT_SCHEMA() as CURRENT_SCHEMA,
    CURRENT_WAREHOUSE() as CURRENT_WAREHOUSE,
    CURRENT_USER() as CURRENT_USER;

-- Step 2: Check if you have the correct role
SELECT 'TROUBLESHOOTING: Role Check' as STEP;

SHOW GRANTS TO USER CURRENT_USER();

-- Step 3: Switch to the correct role if needed
-- Uncomment the line below if you need to switch roles
-- USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Step 4: Check if database exists
SELECT 'TROUBLESHOOTING: Database Check' as STEP;

SHOW DATABASES LIKE 'SG_PUBSEC_DEMO';

-- Step 5: Switch to the correct database
USE DATABASE SG_PUBSEC_DEMO;

-- Step 6: Check existing schemas
SELECT 'TROUBLESHOOTING: Schema Check' as STEP;

SHOW SCHEMAS IN DATABASE SG_PUBSEC_DEMO;

-- Step 7: Check role privileges on database
SELECT 'TROUBLESHOOTING: Database Privileges' as STEP;

SHOW GRANTS ON DATABASE SG_PUBSEC_DEMO;

-- Step 8: Try to create the schema with explicit error handling
SELECT 'TROUBLESHOOTING: Schema Creation Attempt' as STEP;

-- Method 1: Try with IF NOT EXISTS
BEGIN
    CREATE SCHEMA IF NOT EXISTS SG_PUBSEC_DEMO.EXTERNAL_DATA
        COMMENT = 'External data sources from Snowflake Marketplace';
    
    SELECT 'SUCCESS: Schema created with IF NOT EXISTS' as RESULT;
EXCEPTION
    WHEN OTHER THEN
        SELECT 'ERROR: ' || SQLERRM as RESULT;
END;

-- Method 2: Try without IF NOT EXISTS (in case schema exists but has issues)
BEGIN
    CREATE SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA_TEST
        COMMENT = 'Test schema for troubleshooting';
    
    SELECT 'SUCCESS: Test schema created without IF NOT EXISTS' as RESULT;
    
    -- Clean up test schema
    DROP SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA_TEST;
    
EXCEPTION
    WHEN OTHER THEN
        SELECT 'ERROR: ' || SQLERRM as RESULT;
END;

-- Step 9: Check if schema now exists
SELECT 'TROUBLESHOOTING: Final Schema Check' as STEP;

SHOW SCHEMAS IN DATABASE SG_PUBSEC_DEMO;

-- Step 10: If schema exists, check permissions
SELECT 'TROUBLESHOOTING: Schema Permissions' as STEP;

SHOW GRANTS ON SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA;

-- Step 11: Grant permissions if needed
BEGIN
    GRANT USAGE ON SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
    GRANT ALL ON SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
    
    SELECT 'SUCCESS: Permissions granted' as RESULT;
EXCEPTION
    WHEN OTHER THEN
        SELECT 'ERROR: ' || SQLERRM as RESULT;
END;

-- Step 12: Test table creation in the schema
SELECT 'TROUBLESHOOTING: Table Creation Test' as STEP;

BEGIN
    CREATE OR REPLACE TABLE SG_PUBSEC_DEMO.EXTERNAL_DATA.TEST_TABLE (
        ID NUMBER,
        NAME STRING
    );
    
    SELECT 'SUCCESS: Test table created in EXTERNAL_DATA schema' as RESULT;
    
    -- Clean up test table
    DROP TABLE SG_PUBSEC_DEMO.EXTERNAL_DATA.TEST_TABLE;
    
EXCEPTION
    WHEN OTHER THEN
        SELECT 'ERROR: ' || SQLERRM as RESULT;
END;

-- Summary and recommendations
SELECT 'TROUBLESHOOTING: Summary' as STEP;

SELECT 
    'If all steps succeeded, you can now run marketplace_integration.sql' as RECOMMENDATION
UNION ALL
SELECT 
    'If errors occurred, check the specific error messages above' as RECOMMENDATION
UNION ALL
SELECT 
    'Common issues: Wrong role, insufficient privileges, database context' as RECOMMENDATION
UNION ALL
SELECT 
    'Contact your Snowflake admin if permission errors persist' as RECOMMENDATION;

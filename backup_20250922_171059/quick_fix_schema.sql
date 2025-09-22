-- Quick Fix for EXTERNAL_DATA Schema Issues
-- Run this if you're getting schema creation errors

-- Ensure you're using the correct role and context
USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SG_PUBSEC_DEMO;

-- Method 1: Try to create the schema directly
CREATE SCHEMA IF NOT EXISTS SG_PUBSEC_DEMO.EXTERNAL_DATA
    COMMENT = 'External data sources from Snowflake Marketplace';

-- Method 2: If that fails, try dropping and recreating (only if safe to do so)
-- CAUTION: Only uncomment these lines if you're sure you want to recreate the schema
-- DROP SCHEMA IF EXISTS SG_PUBSEC_DEMO.EXTERNAL_DATA CASCADE;
-- CREATE SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA
--     COMMENT = 'External data sources from Snowflake Marketplace';

-- Grant proper permissions
GRANT USAGE ON SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Verify the schema was created
SHOW SCHEMAS IN DATABASE SG_PUBSEC_DEMO;

-- Test that you can create objects in the schema
CREATE OR REPLACE TABLE SG_PUBSEC_DEMO.EXTERNAL_DATA.SCHEMA_TEST (
    TEST_ID NUMBER,
    TEST_MESSAGE STRING DEFAULT 'Schema is working!'
);

-- Insert a test record
INSERT INTO SG_PUBSEC_DEMO.EXTERNAL_DATA.SCHEMA_TEST (TEST_ID) VALUES (1);

-- Verify the test
SELECT * FROM SG_PUBSEC_DEMO.EXTERNAL_DATA.SCHEMA_TEST;

-- Clean up the test table
DROP TABLE SG_PUBSEC_DEMO.EXTERNAL_DATA.SCHEMA_TEST;

SELECT 'EXTERNAL_DATA schema is ready for marketplace integration!' as STATUS;

-- Interactive Setup Script for Singapore Smart Nation Intelligence Demo
-- Public Sector Day Singapore 2025
-- 
-- INSTRUCTIONS:
-- 1. Replace all placeholder values marked with <PLACEHOLDER> with your actual values
-- 2. Run this script section by section in Snowsight
-- 3. Verify each step completes successfully before proceeding

-- =============================================================================
-- STEP 1: ACCOUNT INFORMATION SETUP
-- =============================================================================
-- Please replace these placeholders with your actual values:

-- Your Snowflake account identifier (e.g., abc12345.us-east-1)
SET ACCOUNT_IDENTIFIER = '<YOUR_ACCOUNT_IDENTIFIER>';

-- Your email for demo notifications
SET DEMO_EMAIL = '<YOUR_EMAIL_ADDRESS>';

-- Your current username (should have ACCOUNTADMIN privileges)
SET CURRENT_USERNAME = '<YOUR_USERNAME>';

-- =============================================================================
-- STEP 2: VERIFY PREREQUISITES
-- =============================================================================

-- Check if you have ACCOUNTADMIN role
SELECT CURRENT_ROLE() as CURRENT_ROLE;
-- This should return 'ACCOUNTADMIN' - if not, run: USE ROLE ACCOUNTADMIN;

-- Check Snowflake Intelligence availability
SHOW PARAMETERS LIKE 'CORTEX_ENABLED_CROSS_REGION' IN ACCOUNT;
-- This should show TRUE or you should see Cortex features available

-- Check available regions for AI models
-- SHOW REGIONS;

-- =============================================================================
-- STEP 3: CREATE SNOWFLAKE INTELLIGENCE ENVIRONMENT (Following Official Docs)
-- =============================================================================

-- Switch to ACCOUNTADMIN role for setup
USE ROLE ACCOUNTADMIN;

-- Create the standard Snowflake Intelligence database (as per documentation)
CREATE DATABASE IF NOT EXISTS snowflake_intelligence
    COMMENT = 'Snowflake Intelligence configuration and agents';
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE PUBLIC;

-- Create the agents schema (as per documentation)
CREATE SCHEMA IF NOT EXISTS snowflake_intelligence.agents
    COMMENT = 'Snowflake Intelligence agents for all users';
GRANT USAGE ON SCHEMA snowflake_intelligence.agents TO ROLE PUBLIC;

-- Create our demo-specific database for data
CREATE DATABASE IF NOT EXISTS SG_PUBSEC_DEMO
    COMMENT = 'Singapore Smart Nation Intelligence Demo - Public Sector Day 2025';

CREATE SCHEMA IF NOT EXISTS SG_PUBSEC_DEMO.CITIZEN_DATA
    COMMENT = 'Privacy-compliant synthetic citizen data';

CREATE SCHEMA IF NOT EXISTS SG_PUBSEC_DEMO.SERVICES
    COMMENT = 'Government service interactions and workflows';

CREATE SCHEMA IF NOT EXISTS SG_PUBSEC_DEMO.ANALYTICS
    COMMENT = 'Analytics views and performance metrics';

CREATE SCHEMA IF NOT EXISTS SG_PUBSEC_DEMO.EXTERNAL_DATA
    COMMENT = 'External data sources from Snowflake Marketplace';

-- =============================================================================
-- STEP 4: CREATE SNOWFLAKE INTELLIGENCE ADMIN ROLE (Following Official Docs)
-- =============================================================================

-- Create the standard Snowflake Intelligence admin role (as per documentation)
CREATE ROLE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_ADMIN
    COMMENT = 'Role for managing Snowflake Intelligence agents and demo';

-- Grant database and schema privileges for Snowflake Intelligence
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA snowflake_intelligence.agents TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant CREATE AGENT privilege on the schema (not account)
GRANT CREATE AGENT ON SCHEMA snowflake_intelligence.agents TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant other necessary privileges
GRANT CREATE CORTEX SEARCH SERVICE ON SCHEMA snowflake_intelligence.agents TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant database and schema privileges for demo data
GRANT USAGE ON DATABASE SG_PUBSEC_DEMO TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SG_PUBSEC_DEMO.CITIZEN_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SG_PUBSEC_DEMO.SERVICES TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SG_PUBSEC_DEMO.ANALYTICS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SG_PUBSEC_DEMO.EXTERNAL_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant role to current user
GRANT ROLE SNOWFLAKE_INTELLIGENCE_ADMIN TO USER IDENTIFIER($CURRENT_USERNAME);

-- =============================================================================
-- STEP 5: CREATE COMPUTE WAREHOUSE
-- =============================================================================

-- Create dedicated warehouse for demo
CREATE WAREHOUSE IF NOT EXISTS SG_DEMO_WH
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Singapore Public Sector Intelligence Demo';

-- Grant warehouse privileges
GRANT USAGE ON WAREHOUSE SG_DEMO_WH TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT OPERATE ON WAREHOUSE SG_DEMO_WH TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- =============================================================================
-- STEP 6: SWITCH TO SNOWFLAKE INTELLIGENCE ROLE AND CONTEXT
-- =============================================================================

-- Switch to the Snowflake Intelligence role and context
USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE snowflake_intelligence;
USE SCHEMA agents;
USE WAREHOUSE SG_DEMO_WH;

-- =============================================================================
-- STEP 7: VERIFICATION QUERIES
-- =============================================================================

-- Verify setup is complete
SELECT 'Setup verification started' as STATUS;

-- Check current context
SELECT 
    CURRENT_ROLE() as CURRENT_ROLE,
    CURRENT_DATABASE() as CURRENT_DATABASE,
    CURRENT_SCHEMA() as CURRENT_SCHEMA,
    CURRENT_WAREHOUSE() as CURRENT_WAREHOUSE;

-- Check database and schemas exist
SHOW SCHEMAS IN DATABASE SG_PUBSEC_DEMO;

-- Check warehouse is accessible
SHOW WAREHOUSES LIKE 'SG_DEMO_WH';

-- Check role privileges
SHOW GRANTS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- =============================================================================
-- STEP 8: NEXT STEPS MESSAGE
-- =============================================================================

SELECT 
    '✅ Basic setup complete!' as STATUS,
    'Ready to run data generation scripts' as NEXT_STEP,
    'Run generate_synthetic_data.sql next' as INSTRUCTION;

-- =============================================================================
-- TROUBLESHOOTING SECTION
-- =============================================================================

-- If you encounter issues, run these diagnostic queries:

-- Check if Snowflake Intelligence is available
-- SHOW PARAMETERS LIKE '%CORTEX%' IN ACCOUNT;

-- Check available AI models
-- SELECT SNOWFLAKE.CORTEX.COMPLETE('llama2-7b-chat', 'Hello, this is a test');

-- Check role hierarchy
-- SHOW ROLES;

-- Check user privileges
-- SHOW GRANTS TO USER IDENTIFIER($CURRENT_USERNAME);

-- =============================================================================
-- SECURITY NOTES
-- =============================================================================

/*
IMPORTANT SECURITY CONSIDERATIONS:

1. SERVICE USER: The SG_INTELLIGENCE_SERVICE user is created for automation
   - In production, configure key-pair authentication
   - Store private keys securely (preferably in a secrets manager)
   - Rotate keys regularly

2. ROLE PRIVILEGES: The SG_INTELLIGENCE_ADMIN role has broad privileges
   - Review and restrict privileges for production use
   - Implement principle of least privilege
   - Regular access reviews

3. DATA PRIVACY: This demo uses synthetic data only
   - Never use real citizen data without proper governance
   - Implement data classification and masking for production
   - Ensure compliance with PDPA and other regulations

4. WAREHOUSE COSTS: Monitor compute usage
   - Auto-suspend is set to 60 seconds to minimize costs
   - Adjust warehouse size based on actual usage patterns
   - Implement resource monitors for cost control
*/

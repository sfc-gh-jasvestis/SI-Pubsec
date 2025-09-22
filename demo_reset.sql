-- ============================================================================
-- SINGAPORE SMART NATION INTELLIGENCE DEMO - COMPLETE RESET
-- Public Sector Day Singapore 2025
-- ============================================================================

-- This script completely removes all demo components for a fresh start
-- WARNING: This will delete ALL demo data, objects, and configurations

-- ============================================================================
-- SECTION 1: CONFIRMATION AND SAFETY CHECK
-- ============================================================================

-- Switch to ACCOUNTADMIN role for cleanup
USE ROLE ACCOUNTADMIN;

SELECT 'WARNING: This script will completely remove the Singapore Smart Nation Intelligence Demo' as WARNING_MESSAGE,
       'All data, tables, views, procedures, agents, and configurations will be deleted' as IMPACT,
       'Press Ctrl+C now if you want to cancel this operation' as ACTION_REQUIRED;

-- Wait message for user confirmation
SELECT 'Proceeding with demo reset in 5 seconds...' as COUNTDOWN;

-- ============================================================================
-- SECTION 2: REMOVE SNOWFLAKE INTELLIGENCE AGENTS
-- ============================================================================

-- Switch to the intelligence admin role
USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Drop any existing agents (replace with actual agent names if created)
-- Note: Agents must be dropped manually through UI or specific commands
SELECT 'Step 1: Please manually remove any Snowflake Intelligence agents from the UI' as MANUAL_STEP,
       'Navigate to Data > Agents and delete: SNOWFLAKE_Smart_Nation_Assistant' as INSTRUCTIONS;

-- ============================================================================
-- SECTION 3: REMOVE CORTEX SERVICES
-- ============================================================================

-- Drop Cortex Search Services
DROP CORTEX SEARCH SERVICE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE;

-- Drop Semantic Models (if created)
DROP SEMANTIC MODEL IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.CITIZEN_SERVICES_MODEL;
DROP SEMANTIC MODEL IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.POLICY_IMPACT_MODEL;
DROP SEMANTIC MODEL IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.SERVICE_PERFORMANCE_MODEL;
DROP SEMANTIC MODEL IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.WEATHER_SERVICE_CORRELATION_MODEL;

SELECT 'Phase 1: Cortex services removed' as RESET_PHASE;

-- ============================================================================
-- SECTION 4: REMOVE STORED PROCEDURES
-- ============================================================================

-- Drop custom stored procedures
DROP PROCEDURE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GENERATE_POLICY_BRIEF(STRING, STRING);
DROP PROCEDURE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_SERVICE_ALERT(STRING, STRING, STRING);
DROP PROCEDURE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.OPTIMIZE_RESOURCES(STRING, STRING);

SELECT 'Phase 2: Stored procedures removed' as RESET_PHASE;

-- ============================================================================
-- SECTION 5: REMOVE VIEWS
-- ============================================================================

-- Drop analytics views
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.CITIZEN_SATISFACTION_SUMMARY;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE_DASHBOARD;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_SERVICE_CORRELATION_SIMPLE;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_SERVICE_CORRELATION;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.ECONOMIC_POLICY_IMPACT;

-- Drop weather service integration views
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_IMPACT_SUMMARY;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.REGIONAL_SERVICE_RESILIENCE;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.HOURLY_WEATHER_SERVICE_PATTERNS;
DROP VIEW IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.AGENCY_WEATHER_PREPAREDNESS;

SELECT 'Phase 3: Analytics views removed' as RESET_PHASE;

-- ============================================================================
-- SECTION 6: REMOVE ALL TABLES AND DATA
-- ============================================================================

-- Drop citizen data tables
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES;

-- Drop service tables
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS;
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS;

-- Drop analytics tables
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE;
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT;
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.CURRENT_EVENTS_IMPACT;

-- Drop external data tables
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA;
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS;
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.TRANSPORT_DATA;
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.HEALTH_TRENDS;

-- Drop intelligence tables
DROP TABLE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE;

SELECT 'Phase 4: All tables and data removed' as RESET_PHASE;

-- ============================================================================
-- SECTION 7: REMOVE STAGES AND FILE FORMATS
-- ============================================================================

-- Drop semantic model stage and file formats
DROP STAGE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE;
DROP FILE FORMAT IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.YAML_FORMAT;

SELECT 'Phase 5: Stages and file formats removed' as RESET_PHASE;

-- ============================================================================
-- SECTION 8: REMOVE SCHEMAS
-- ============================================================================

-- Drop all demo schemas
DROP SCHEMA IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS;
DROP SCHEMA IF EXISTS SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA;
DROP SCHEMA IF EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS;
DROP SCHEMA IF EXISTS SNOWFLAKE_PUBSEC_DEMO.SERVICES;
DROP SCHEMA IF EXISTS SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA;
DROP SCHEMA IF EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE;

SELECT 'Phase 6: Demo schemas removed' as RESET_PHASE;

-- ============================================================================
-- SECTION 9: REMOVE DATABASE AND WAREHOUSE
-- ============================================================================

-- Drop the demo database
DROP DATABASE IF EXISTS SNOWFLAKE_PUBSEC_DEMO;

-- Drop the demo warehouse
DROP WAREHOUSE IF EXISTS SNOWFLAKE_DEMO_WH;

SELECT 'Phase 7: Demo database and warehouse removed' as RESET_PHASE;

-- ============================================================================
-- SECTION 10: CLEAN UP ROLES AND PERMISSIONS
-- ============================================================================

-- Switch back to ACCOUNTADMIN for role cleanup
USE ROLE ACCOUNTADMIN;

-- Revoke role from users (optional - comment out if you want to keep the role)
-- REVOKE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN FROM USER CURRENT_USER();

-- Drop the demo role (optional - comment out if you want to keep the role for future demos)
-- DROP ROLE IF EXISTS SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Note: We keep the standard Snowflake Intelligence infrastructure
-- DROP SCHEMA IF EXISTS snowflake_intelligence.agents;
-- DROP DATABASE IF EXISTS snowflake_intelligence;

SELECT 'Phase 8: Role cleanup completed (role preserved for future use)' as RESET_PHASE;

-- ============================================================================
-- SECTION 11: RESET CONFIRMATION
-- ============================================================================

-- Final verification
SELECT 'Singapore Smart Nation Intelligence Demo has been completely reset!' as RESET_STATUS,
       'All demo data, tables, views, procedures, and services have been removed' as CONFIRMATION,
       'The environment is now clean and ready for a fresh demo setup' as NEXT_STEP;

-- Show what remains (should be minimal)
SHOW DATABASES LIKE '%PUBSEC%';
SHOW WAREHOUSES LIKE '%DEMO%';

SELECT 'Demo reset completed successfully!' as FINAL_MESSAGE,
       'You can now run complete_demo_setup.sql to recreate the demo' as INSTRUCTIONS;

-- ============================================================================
-- RESET COMPLETE - ENVIRONMENT CLEANED
-- ============================================================================

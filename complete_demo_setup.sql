-- ============================================================================
-- SINGAPORE SMART NATION INTELLIGENCE DEMO - COMPLETE SETUP
-- Public Sector Day Singapore 2025
-- "Talk to Enterprise Data Instantly" - Snowflake Intelligence Demo
-- ============================================================================

-- This script sets up the complete Singapore Smart Nation Intelligence Demo
-- including all databases, schemas, tables, data, semantic models, and services

-- ============================================================================
-- SECTION 1: INITIAL SETUP AND PERMISSIONS
-- ============================================================================

-- Switch to ACCOUNTADMIN role for initial setup
USE ROLE ACCOUNTADMIN;

-- Create the standard Snowflake Intelligence database (as per documentation)
CREATE DATABASE IF NOT EXISTS snowflake_intelligence
    COMMENT = 'Snowflake Intelligence configuration and agents';
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE PUBLIC;

-- Create the agents schema (as per documentation)
CREATE SCHEMA IF NOT EXISTS snowflake_intelligence.agents
    COMMENT = 'Snowflake Intelligence agents for all users';
GRANT USAGE ON SCHEMA snowflake_intelligence.agents TO ROLE PUBLIC;

-- Create demo-specific database and schemas
CREATE DATABASE IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO
    COMMENT = 'Singapore Smart Nation Intelligence Demo - Public Sector Day 2025';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE
    COMMENT = 'Snowflake Intelligence agent configurations and custom tools';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA
    COMMENT = 'Privacy-compliant synthetic citizen data';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.SERVICES
    COMMENT = 'Government service interactions and workflows';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.ANALYTICS
    COMMENT = 'Analytics views and performance metrics';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA
    COMMENT = 'External data sources from Snowflake Marketplace';

CREATE SCHEMA IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS
    COMMENT = 'Cortex Analyst Semantic Models';

-- Create the standard Snowflake Intelligence admin role (as per documentation)
CREATE ROLE IF NOT EXISTS SNOWFLAKE_INTELLIGENCE_ADMIN
    COMMENT = 'Role for managing Snowflake Intelligence agents and demo';

-- Grant necessary account-level privileges for Snowflake Intelligence
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant database and schema privileges for Snowflake Intelligence
GRANT USAGE ON DATABASE snowflake_intelligence TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA snowflake_intelligence.agents TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant CREATE AGENT and CREATE CORTEX SEARCH SERVICE privilege on the schema
GRANT CREATE AGENT ON SCHEMA snowflake_intelligence.agents TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT CREATE CORTEX SEARCH SERVICE ON SCHEMA snowflake_intelligence.agents TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT CREATE SEMANTIC MODEL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant database and schema privileges for demo data
GRANT USAGE ON DATABASE SNOWFLAKE_PUBSEC_DEMO TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.SERVICES TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.ANALYTICS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant role to current user
GRANT ROLE SNOWFLAKE_INTELLIGENCE_ADMIN TO USER CURRENT_USER();

-- Create compute warehouse for demo
CREATE WAREHOUSE IF NOT EXISTS SNOWFLAKE_DEMO_WH
    WAREHOUSE_SIZE = 'MEDIUM'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Singapore Public Sector Intelligence Demo';

-- Grant warehouse privileges
GRANT USAGE ON WAREHOUSE SNOWFLAKE_DEMO_WH TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT OPERATE ON WAREHOUSE SNOWFLAKE_DEMO_WH TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Switch to the Snowflake Intelligence role and context
USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SNOWFLAKE_PUBSEC_DEMO;
USE SCHEMA INTELLIGENCE;
USE WAREHOUSE SNOWFLAKE_DEMO_WH;

SELECT 'Phase 1: Initial setup and permissions completed' as SETUP_PHASE;

-- ============================================================================
-- SECTION 2: CORE DATA TABLES
-- ============================================================================

-- Create tables for synthetic citizen data (privacy-compliant)
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES (
    CITIZEN_ID STRING,
    AGE_GROUP STRING,
    POSTAL_DISTRICT STRING,
    PREFERRED_LANGUAGE STRING,
    DIGITAL_LITERACY_SCORE NUMBER(3,2),
    SERVICE_USAGE_FREQUENCY STRING,
    LAST_INTERACTION_DATE DATE,
    SATISFACTION_SCORE NUMBER(3,2),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create table for digital service interactions
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS (
    INTERACTION_ID STRING,
    CITIZEN_ID STRING,
    SERVICE_TYPE STRING,
    AGENCY STRING,
    INTERACTION_CHANNEL STRING,
    DURATION_MINUTES NUMBER,
    SUCCESS_FLAG BOOLEAN,
    SATISFACTION_RATING NUMBER(1,0),
    INTERACTION_TIMESTAMP TIMESTAMP,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create table for service performance metrics
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE (
    METRIC_ID STRING,
    SERVICE_NAME STRING,
    AGENCY STRING,
    METRIC_TYPE STRING,
    METRIC_VALUE NUMBER,
    MEASUREMENT_DATE DATE,
    BENCHMARK_VALUE NUMBER,
    PERFORMANCE_STATUS STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create table for policy impact tracking
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT (
    POLICY_ID STRING,
    POLICY_NAME STRING,
    IMPLEMENTATION_DATE DATE,
    TARGET_DEMOGRAPHIC STRING,
    BASELINE_METRIC NUMBER,
    CURRENT_METRIC NUMBER,
    IMPACT_PERCENTAGE NUMBER(5,2),
    STATUS STRING,
    LAST_UPDATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create table for inter-agency workflows
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS (
    WORKFLOW_ID STRING,
    CITIZEN_REQUEST_ID STRING,
    SOURCE_AGENCY STRING,
    TARGET_AGENCY STRING,
    WORKFLOW_TYPE STRING,
    STATUS STRING,
    PROCESSING_TIME_HOURS NUMBER(5,2),
    HANDOFF_TIMESTAMP TIMESTAMP,
    COMPLETION_TIMESTAMP TIMESTAMP,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create table for current events impact
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.CURRENT_EVENTS_IMPACT (
    EVENT_ID STRING,
    EVENT_NAME STRING,
    EVENT_DATE DATE,
    AFFECTED_SERVICES ARRAY,
    IMPACT_SCORE NUMBER(3,2),
    CITIZEN_INQUIRIES_INCREASE_PCT NUMBER(5,2),
    RESPONSE_MEASURES ARRAY,
    STATUS STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create external data tables
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA (
    DATE_TIME TIMESTAMP,
    LOCATION STRING,
    TEMPERATURE_C NUMBER(4,1),
    HUMIDITY_PCT NUMBER(3,0),
    RAINFALL_MM NUMBER(5,1),
    WEATHER_CONDITION STRING,
    ALERT_LEVEL STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS (
    INDICATOR_DATE DATE,
    INDICATOR_NAME STRING,
    VALUE NUMBER(10,2),
    UNIT STRING,
    CATEGORY STRING,
    SOURCE STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.TRANSPORT_DATA (
    TIMESTAMP TIMESTAMP,
    TRANSPORT_MODE STRING,
    ROUTE_AREA STRING,
    PASSENGER_COUNT NUMBER,
    DELAY_MINUTES NUMBER,
    SERVICE_STATUS STRING,
    DISRUPTION_TYPE STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.HEALTH_TRENDS (
    REPORT_DATE DATE,
    HEALTH_INDICATOR STRING,
    DEMOGRAPHIC_GROUP STRING,
    VALUE NUMBER(8,2),
    TREND_DIRECTION STRING,
    CONFIDENCE_LEVEL STRING,
    DATA_SOURCE STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Create government knowledge base table
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE (
    DOCUMENT_ID STRING,
    DOCUMENT_TITLE STRING,
    DOCUMENT_TYPE STRING,
    AGENCY STRING,
    CONTENT TEXT,
    CATEGORY STRING,
    LAST_UPDATED DATE,
    DOCUMENT_URL STRING,
    KEYWORDS STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Enable change tracking (required for Cortex Search)
ALTER TABLE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE SET
  CHANGE_TRACKING = TRUE;

SELECT 'Phase 2: Core data tables created' as SETUP_PHASE;

-- ============================================================================
-- SECTION 3: SYNTHETIC DATA GENERATION
-- ============================================================================

-- Generate synthetic citizen profiles (40,000 records across 4 runs)
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES (
    CITIZEN_ID,
    AGE_GROUP,
    POSTAL_DISTRICT,
    PREFERRED_LANGUAGE,
    DIGITAL_LITERACY_SCORE,
    SERVICE_USAGE_FREQUENCY,
    LAST_INTERACTION_DATE,
    SATISFACTION_SCORE
)
WITH SYNTHETIC_CITIZENS AS (
    SELECT 
        'SNOWFLAKE' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as CITIZEN_ID,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN '18-25'
            WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN '26-35'
            WHEN UNIFORM(1, 100, RANDOM()) <= 55 THEN '36-50'
            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN '51-65'
            ELSE '65+'
        END as AGE_GROUP,
        CASE 
            WHEN UNIFORM(1, 28, RANDOM()) <= 5 THEN 'District 01-05'
            WHEN UNIFORM(1, 28, RANDOM()) <= 10 THEN 'District 06-10'
            WHEN UNIFORM(1, 28, RANDOM()) <= 15 THEN 'District 11-15'
            WHEN UNIFORM(1, 28, RANDOM()) <= 20 THEN 'District 16-20'
            ELSE 'District 21-28'
        END as POSTAL_DISTRICT,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'English'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Mandarin'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Malay'
            ELSE 'Tamil'
        END as PREFERRED_LANGUAGE,
        ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2) as DIGITAL_LITERACY_SCORE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Daily'
            WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Weekly'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Monthly'
            ELSE 'Rarely'
        END as SERVICE_USAGE_FREQUENCY,
        DATEADD(day, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) as LAST_INTERACTION_DATE,
        ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2) as SATISFACTION_SCORE
    FROM TABLE(GENERATOR(ROWCOUNT => 10000))
)
SELECT * FROM SYNTHETIC_CITIZENS;

-- Generate additional citizen batches for comprehensive dataset
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES (
    CITIZEN_ID, AGE_GROUP, POSTAL_DISTRICT, PREFERRED_LANGUAGE, 
    DIGITAL_LITERACY_SCORE, SERVICE_USAGE_FREQUENCY, LAST_INTERACTION_DATE, SATISFACTION_SCORE
)
SELECT 
    'SNOWFLAKE' || LPAD(10000 + ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0'),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN '18-25' WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN '26-35' WHEN UNIFORM(1, 100, RANDOM()) <= 55 THEN '36-50' WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN '51-65' ELSE '65+' END,
    CASE WHEN UNIFORM(1, 28, RANDOM()) <= 5 THEN 'District 01-05' WHEN UNIFORM(1, 28, RANDOM()) <= 10 THEN 'District 06-10' WHEN UNIFORM(1, 28, RANDOM()) <= 15 THEN 'District 11-15' WHEN UNIFORM(1, 28, RANDOM()) <= 20 THEN 'District 16-20' ELSE 'District 21-28' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'English' WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Mandarin' WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Malay' ELSE 'Tamil' END,
    ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2), 
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Daily' WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Weekly' WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Monthly' ELSE 'Rarely' END,
    DATEADD(day, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()),
    ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2)
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

INSERT INTO SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES (
    CITIZEN_ID, AGE_GROUP, POSTAL_DISTRICT, PREFERRED_LANGUAGE, 
    DIGITAL_LITERACY_SCORE, SERVICE_USAGE_FREQUENCY, LAST_INTERACTION_DATE, SATISFACTION_SCORE
)
SELECT 
    'SNOWFLAKE' || LPAD(20000 + ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0'),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN '18-25' WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN '26-35' WHEN UNIFORM(1, 100, RANDOM()) <= 55 THEN '36-50' WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN '51-65' ELSE '65+' END,
    CASE WHEN UNIFORM(1, 28, RANDOM()) <= 5 THEN 'District 01-05' WHEN UNIFORM(1, 28, RANDOM()) <= 10 THEN 'District 06-10' WHEN UNIFORM(1, 28, RANDOM()) <= 15 THEN 'District 11-15' WHEN UNIFORM(1, 28, RANDOM()) <= 20 THEN 'District 16-20' ELSE 'District 21-28' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'English' WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Mandarin' WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Malay' ELSE 'Tamil' END,
    ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2), 
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Daily' WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Weekly' WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Monthly' ELSE 'Rarely' END,
    DATEADD(day, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()),
    ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2)
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

INSERT INTO SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES (
    CITIZEN_ID, AGE_GROUP, POSTAL_DISTRICT, PREFERRED_LANGUAGE, 
    DIGITAL_LITERACY_SCORE, SERVICE_USAGE_FREQUENCY, LAST_INTERACTION_DATE, SATISFACTION_SCORE
)
SELECT 
    'SNOWFLAKE' || LPAD(30000 + ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0'),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN '18-25' WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN '26-35' WHEN UNIFORM(1, 100, RANDOM()) <= 55 THEN '36-50' WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN '51-65' ELSE '65+' END,
    CASE WHEN UNIFORM(1, 28, RANDOM()) <= 5 THEN 'District 01-05' WHEN UNIFORM(1, 28, RANDOM()) <= 10 THEN 'District 06-10' WHEN UNIFORM(1, 28, RANDOM()) <= 15 THEN 'District 11-15' WHEN UNIFORM(1, 28, RANDOM()) <= 20 THEN 'District 16-20' ELSE 'District 21-28' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'English' WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Mandarin' WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Malay' ELSE 'Tamil' END,
    ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2), 
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Daily' WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Weekly' WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Monthly' ELSE 'Rarely' END,
    DATEADD(day, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()),
    ROUND(UNIFORM(1.0, 5.0, RANDOM()), 2)
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

SELECT 'Phase 3a: Citizen profiles generated (40,000 records)' as SETUP_PHASE;

-- Generate service interactions (200,000 records across 4 runs)
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS (
    INTERACTION_ID,
    CITIZEN_ID,
    SERVICE_TYPE,
    AGENCY,
    INTERACTION_CHANNEL,
    DURATION_MINUTES,
    SUCCESS_FLAG,
    SATISFACTION_RATING,
    INTERACTION_TIMESTAMP
)
WITH SYNTHETIC_INTERACTIONS AS (
    SELECT 
        'INT' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 10, '0') as INTERACTION_ID,
        'SNOWFLAKE' || LPAD(UNIFORM(1, 10000, RANDOM()), 8, '0') as CITIZEN_ID,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 25 THEN 'Healthcare Appointment'
            WHEN UNIFORM(1, 100, RANDOM()) <= 45 THEN 'Education Services'
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Housing Application'
            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 'Transport Services'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Social Services'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Business Registration'
            ELSE 'Tax Services'
        END as SERVICE_TYPE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'MOH'
            WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 'MOE'
            WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'HDB'
            WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'LTA'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'MSF'
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'ACRA'
            ELSE 'IRAS'
        END as AGENCY,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Mobile App'
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Web Portal'
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'Service Center'
            ELSE 'Phone'
        END as INTERACTION_CHANNEL,
        UNIFORM(5, 120, RANDOM()) as DURATION_MINUTES,
        CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN TRUE ELSE FALSE END as SUCCESS_FLAG,
        UNIFORM(1, 5, RANDOM()) as SATISFACTION_RATING,
        DATEADD(minute, -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()) as INTERACTION_TIMESTAMP
    FROM TABLE(GENERATOR(ROWCOUNT => 50000))
)
SELECT * FROM SYNTHETIC_INTERACTIONS;

-- Generate additional service interaction batches
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS (
    INTERACTION_ID, CITIZEN_ID, SERVICE_TYPE, AGENCY, INTERACTION_CHANNEL, 
    DURATION_MINUTES, SUCCESS_FLAG, SATISFACTION_RATING, INTERACTION_TIMESTAMP
)
SELECT 
    'INT' || LPAD(50000 + ROW_NUMBER() OVER (ORDER BY SEQ4()), 10, '0'),
    'SNOWFLAKE' || LPAD(UNIFORM(1, 40000, RANDOM()), 8, '0'),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 25 THEN 'Healthcare Appointment' WHEN UNIFORM(1, 100, RANDOM()) <= 45 THEN 'Education Services' WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Housing Application' WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 'Transport Services' WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Social Services' WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Business Registration' ELSE 'Tax Services' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'MOH' WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 'MOE' WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'HDB' WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'LTA' WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'MSF' WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'ACRA' ELSE 'IRAS' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Mobile App' WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Web Portal' WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'Service Center' ELSE 'Phone' END,
    UNIFORM(5, 120, RANDOM()), 
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN TRUE ELSE FALSE END,
    UNIFORM(1, 5, RANDOM()),
    DATEADD(minute, -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP())
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

INSERT INTO SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS (
    INTERACTION_ID, CITIZEN_ID, SERVICE_TYPE, AGENCY, INTERACTION_CHANNEL, 
    DURATION_MINUTES, SUCCESS_FLAG, SATISFACTION_RATING, INTERACTION_TIMESTAMP
)
SELECT 
    'INT' || LPAD(100000 + ROW_NUMBER() OVER (ORDER BY SEQ4()), 10, '0'),
    'SNOWFLAKE' || LPAD(UNIFORM(1, 40000, RANDOM()), 8, '0'),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 25 THEN 'Healthcare Appointment' WHEN UNIFORM(1, 100, RANDOM()) <= 45 THEN 'Education Services' WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Housing Application' WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 'Transport Services' WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Social Services' WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Business Registration' ELSE 'Tax Services' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'MOH' WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 'MOE' WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'HDB' WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'LTA' WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'MSF' WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'ACRA' ELSE 'IRAS' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Mobile App' WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Web Portal' WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'Service Center' ELSE 'Phone' END,
    UNIFORM(5, 120, RANDOM()), 
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN TRUE ELSE FALSE END,
    UNIFORM(1, 5, RANDOM()),
    DATEADD(minute, -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP())
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

INSERT INTO SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS (
    INTERACTION_ID, CITIZEN_ID, SERVICE_TYPE, AGENCY, INTERACTION_CHANNEL, 
    DURATION_MINUTES, SUCCESS_FLAG, SATISFACTION_RATING, INTERACTION_TIMESTAMP
)
SELECT 
    'INT' || LPAD(150000 + ROW_NUMBER() OVER (ORDER BY SEQ4()), 10, '0'),
    'SNOWFLAKE' || LPAD(UNIFORM(1, 40000, RANDOM()), 8, '0'),
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 25 THEN 'Healthcare Appointment' WHEN UNIFORM(1, 100, RANDOM()) <= 45 THEN 'Education Services' WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Housing Application' WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 'Transport Services' WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Social Services' WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Business Registration' ELSE 'Tax Services' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'MOH' WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 'MOE' WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'HDB' WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'LTA' WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'MSF' WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'ACRA' ELSE 'IRAS' END,
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Mobile App' WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Web Portal' WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'Service Center' ELSE 'Phone' END,
    UNIFORM(5, 120, RANDOM()), 
    CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN TRUE ELSE FALSE END,
    UNIFORM(1, 5, RANDOM()),
    DATEADD(minute, -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP())
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

SELECT 'Phase 3b: Service interactions generated (200,000 records)' as SETUP_PHASE;

-- Generate service performance metrics
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE (
    METRIC_ID,
    SERVICE_NAME,
    AGENCY,
    METRIC_TYPE,
    METRIC_VALUE,
    MEASUREMENT_DATE,
    BENCHMARK_VALUE,
    PERFORMANCE_STATUS
)
WITH SERVICE_METRICS AS (
    SELECT 
        services.SERVICE_NAME,
        services.AGENCY,
        metrics.METRIC_TYPE,
        metrics.BENCHMARK_VALUE,
        dates.MEASUREMENT_DATE
    FROM (
        SELECT 'SingPass Authentication' as SERVICE_NAME, 'GovTech' as AGENCY UNION ALL
        SELECT 'HealthHub Appointments', 'MOH' UNION ALL
        SELECT 'HDB Resale Portal', 'HDB' UNION ALL
        SELECT 'LTA Road Tax Renewal', 'LTA' UNION ALL
        SELECT 'IRAS Tax Filing', 'IRAS' UNION ALL
        SELECT 'MOE School Registration', 'MOE' UNION ALL
        SELECT 'MSF Social Assistance', 'MSF' UNION ALL
        SELECT 'ACRA Business Registration', 'ACRA' UNION ALL
        SELECT 'CPF Digital Services', 'CPF' UNION ALL
        SELECT 'OneService Municipal', 'Municipal' UNION ALL
        SELECT 'Immigration Services', 'ICA' UNION ALL
        SELECT 'National Library Services', 'NLB' UNION ALL
        SELECT 'PUB Water Services', 'PUB' UNION ALL
        SELECT 'NEA Environmental Services', 'NEA' UNION ALL
        SELECT 'MOM Work Pass Services', 'MOM' UNION ALL
        SELECT 'CAAS Aviation Services', 'CAAS' UNION ALL
        SELECT 'MAS Financial Services', 'MAS' UNION ALL
        SELECT 'SportSG Facility Booking', 'SportSG'
    ) services
    CROSS JOIN (
        SELECT 'Response Time (seconds)' as METRIC_TYPE, 3.0 as BENCHMARK_VALUE UNION ALL
        SELECT 'Success Rate (%)', 95.0 UNION ALL
        SELECT 'User Satisfaction Score', 4.2 UNION ALL
        SELECT 'Daily Active Users', 1000.0
    ) metrics
    CROSS JOIN (
        SELECT DATEADD(day, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_DATE()) as MEASUREMENT_DATE
        FROM TABLE(GENERATOR(ROWCOUNT => 30))
    ) dates
),
SYNTHETIC_METRICS AS (
    SELECT 
        'METRIC_' || UNIFORM(1000000, 9999999, RANDOM()) as METRIC_ID,
        SERVICE_NAME,
        AGENCY,
        METRIC_TYPE,
        CASE 
            WHEN METRIC_TYPE = 'Response Time (seconds)' THEN ROUND(BENCHMARK_VALUE * UNIFORM(0.7, 1.5, RANDOM()), 2)
            WHEN METRIC_TYPE = 'Success Rate (%)' THEN ROUND(BENCHMARK_VALUE * UNIFORM(0.85, 1.02, RANDOM()), 1)
            WHEN METRIC_TYPE = 'User Satisfaction Score' THEN ROUND(BENCHMARK_VALUE * UNIFORM(0.8, 1.1, RANDOM()), 2)
            WHEN METRIC_TYPE = 'Daily Active Users' THEN ROUND(BENCHMARK_VALUE * UNIFORM(0.5, 3.0, RANDOM()), 0)
        END as METRIC_VALUE,
        MEASUREMENT_DATE,
        BENCHMARK_VALUE,
        CASE 
            WHEN METRIC_TYPE = 'Response Time (seconds)' AND METRIC_VALUE <= BENCHMARK_VALUE THEN 'Meeting'
            WHEN METRIC_TYPE = 'Response Time (seconds)' AND METRIC_VALUE <= BENCHMARK_VALUE * 1.2 THEN 'Below'
            WHEN METRIC_TYPE = 'Response Time (seconds)' THEN 'Critical'
            WHEN METRIC_TYPE IN ('Success Rate (%)', 'User Satisfaction Score', 'Daily Active Users') AND METRIC_VALUE >= BENCHMARK_VALUE THEN 'Exceeding'
            WHEN METRIC_TYPE IN ('Success Rate (%)', 'User Satisfaction Score', 'Daily Active Users') AND METRIC_VALUE >= BENCHMARK_VALUE * 0.9 THEN 'Meeting'
            ELSE 'Below'
        END as PERFORMANCE_STATUS
    FROM SERVICE_METRICS
)
SELECT * FROM SYNTHETIC_METRICS;

SELECT 'Phase 3c: Service performance metrics generated (2,160 records)' as SETUP_PHASE;

-- Generate policy impact data
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT (
    POLICY_ID,
    POLICY_NAME,
    IMPLEMENTATION_DATE,
    TARGET_DEMOGRAPHIC,
    BASELINE_METRIC,
    CURRENT_METRIC,
    IMPACT_PERCENTAGE,
    STATUS
)
VALUES 
    ('POL001', 'Digital Inclusion Initiative for Seniors', '2024-01-15', '65+', 2.1, 3.8, 80.95, 'Active'),
    ('POL002', 'Mobile-First Government Services', '2024-03-01', 'All Citizens', 45.2, 72.6, 60.62, 'Active'),
    ('POL003', 'Multilingual Service Enhancement', '2024-02-10', 'Non-English Speakers', 3.2, 4.1, 28.13, 'Active'),
    ('POL004', 'AI-Powered Service Recommendations', '2024-04-01', 'Frequent Users', 6.8, 8.9, 30.88, 'Pilot'),
    ('POL005', 'Unified Citizen Dashboard', '2024-05-15', 'All Citizens', 12.5, 18.7, 49.60, 'Rolling Out'),
    ('POL006', 'Proactive Service Notifications', '2024-06-01', 'Service Subscribers', 23.4, 31.2, 33.33, 'Active'),
    ('POL007', 'Cross-Agency Data Sharing Protocol', '2024-01-30', 'Inter-Agency Workflows', 48.6, 67.3, 38.48, 'Active'),
    ('POL008', 'Citizen Feedback Integration System', '2024-03-20', 'Service Users', 3.9, 4.6, 17.95, 'Active');

-- Generate inter-agency workflow data
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS (
    WORKFLOW_ID,
    CITIZEN_REQUEST_ID,
    SOURCE_AGENCY,
    TARGET_AGENCY,
    WORKFLOW_TYPE,
    STATUS,
    PROCESSING_TIME_HOURS,
    HANDOFF_TIMESTAMP,
    COMPLETION_TIMESTAMP
)
WITH WORKFLOW_TYPES AS (
    SELECT 'Healthcare Referral' as WORKFLOW_TYPE, 'MOH' as SOURCE_AGENCY, 'Polyclinics' as TARGET_AGENCY UNION ALL
    SELECT 'Housing Eligibility Check', 'HDB', 'CPF' UNION ALL
    SELECT 'Business License Verification', 'ACRA', 'IRAS' UNION ALL
    SELECT 'Education Grant Processing', 'MOE', 'MSF' UNION ALL
    SELECT 'Transport Accessibility Request', 'LTA', 'MSF' UNION ALL
    SELECT 'Employment Pass Coordination', 'MOM', 'ICA'
),
SYNTHETIC_WORKFLOWS AS (
    SELECT 
        'WF' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as WORKFLOW_ID,
        'REQ' || LPAD(UNIFORM(1, 100000, RANDOM()), 8, '0') as CITIZEN_REQUEST_ID,
        wt.SOURCE_AGENCY,
        wt.TARGET_AGENCY,
        wt.WORKFLOW_TYPE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Completed'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'In Progress'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Pending'
            ELSE 'Escalated'
        END as STATUS,
        ROUND(UNIFORM(2.0, 72.0, RANDOM()), 2) as PROCESSING_TIME_HOURS,
        DATEADD(hour, -UNIFORM(1, 2160, RANDOM()), CURRENT_TIMESTAMP()) as HANDOFF_TIMESTAMP,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN DATEADD(hour, UNIFORM(2, 48, RANDOM()), HANDOFF_TIMESTAMP)
            ELSE NULL
        END as COMPLETION_TIMESTAMP
    FROM WORKFLOW_TYPES wt
    CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 500))
)
SELECT * FROM SYNTHETIC_WORKFLOWS;

-- Generate current events impact data
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.CURRENT_EVENTS_IMPACT (
    EVENT_ID,
    EVENT_NAME,
    EVENT_DATE,
    AFFECTED_SERVICES,
    IMPACT_SCORE,
    CITIZEN_INQUIRIES_INCREASE_PCT,
    RESPONSE_MEASURES,
    STATUS
)
SELECT 
    'EVT001', 'Monsoon Season Service Adjustments', '2024-09-15', 
    ARRAY_CONSTRUCT('Transport Services', 'Emergency Services', 'Healthcare'), 
    3.2, 45.6, 
    ARRAY_CONSTRUCT('Extended Service Hours', 'Mobile Response Units', 'Proactive Alerts'), 
    'Active'
UNION ALL
SELECT 
    'EVT002', 'Digital Services Upgrade Weekend', '2024-09-20', 
    ARRAY_CONSTRUCT('SingPass', 'Government Portals', 'Mobile Apps'), 
    2.1, 23.4, 
    ARRAY_CONSTRUCT('Advance Notifications', 'Alternative Channels', 'Extended Support'), 
    'Completed'
UNION ALL
SELECT 
    'EVT003', 'Public Holiday Service Planning', '2024-09-30', 
    ARRAY_CONSTRUCT('All Government Services'), 
    1.8, 15.2, 
    ARRAY_CONSTRUCT('Adjusted Operating Hours', 'Emergency Contact Info', 'Self-Service Options'), 
    'Planned';

SELECT 'Phase 3d: Policy and workflow data generated' as SETUP_PHASE;

-- ============================================================================
-- SECTION 4: EXTERNAL DATA (MARKETPLACE SIMULATION)
-- ============================================================================

-- Generate Singapore weather data
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA (
    DATE_TIME,
    LOCATION,
    TEMPERATURE_C,
    HUMIDITY_PCT,
    RAINFALL_MM,
    WEATHER_CONDITION,
    ALERT_LEVEL
)
WITH SINGAPORE_WEATHER AS (
    SELECT 
        DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP()) as DATE_TIME,
        CASE 
            WHEN UNIFORM(1, 10, RANDOM()) <= 2 THEN 'Changi'
            WHEN UNIFORM(1, 10, RANDOM()) <= 4 THEN 'Paya Lebar'
            WHEN UNIFORM(1, 10, RANDOM()) <= 6 THEN 'Jurong West'
            WHEN UNIFORM(1, 10, RANDOM()) <= 8 THEN 'Woodlands'
            ELSE 'Marina Barrage'
        END as LOCATION,
        CASE 
            WHEN EXTRACT(MONTH FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) IN (11, 12, 1, 2, 3) THEN
                ROUND(UNIFORM(23.5, 32.0, RANDOM()) + 
                      CASE WHEN EXTRACT(HOUR FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) BETWEEN 6 AND 18 THEN UNIFORM(0, 3, RANDOM()) ELSE UNIFORM(-2, 1, RANDOM()) END, 1)
            ELSE
                ROUND(UNIFORM(25.0, 34.5, RANDOM()) + 
                      CASE WHEN EXTRACT(HOUR FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) BETWEEN 6 AND 18 THEN UNIFORM(0, 2.5, RANDOM()) ELSE UNIFORM(-1.5, 0.5, RANDOM()) END, 1)
        END as TEMPERATURE_C,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 30 THEN UNIFORM(85, 95, RANDOM())
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN UNIFORM(75, 90, RANDOM())
            ELSE UNIFORM(65, 85, RANDOM())
        END as HUMIDITY_PCT,
        CASE 
            WHEN EXTRACT(MONTH FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) IN (11, 12, 1, 2, 3) THEN
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 0
                    WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN UNIFORM(0.1, 5, RANDOM())
                    WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN UNIFORM(5, 25, RANDOM())
                    ELSE UNIFORM(25, 80, RANDOM())
                END
            ELSE
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 0
                    WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN UNIFORM(0.1, 3, RANDOM())
                    WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN UNIFORM(3, 15, RANDOM())
                    ELSE UNIFORM(15, 50, RANDOM())
                END
        END as RAINFALL_MM,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Sunny'
            WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'Partly Cloudy'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Cloudy'
            WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN 'Light Rain'
            WHEN UNIFORM(1, 100, RANDOM()) <= 98 THEN 'Heavy Rain'
            ELSE 'Thunderstorm'
        END as WEATHER_CONDITION,
        CASE 
            WHEN UNIFORM(1, 1000, RANDOM()) <= 900 THEN 'Normal'
            WHEN UNIFORM(1, 1000, RANDOM()) <= 970 THEN 'Advisory'
            WHEN UNIFORM(1, 1000, RANDOM()) <= 995 THEN 'Warning'
            ELSE 'Red Alert'
        END as ALERT_LEVEL
    FROM TABLE(GENERATOR(ROWCOUNT => 2160))
)
SELECT * FROM SINGAPORE_WEATHER;

-- Generate economic indicators
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS (
    INDICATOR_DATE,
    INDICATOR_NAME,
    VALUE,
    UNIT,
    CATEGORY,
    SOURCE
)
VALUES 
    ('2024-09-01', 'GDP Growth Rate', 3.2, 'Percentage', 'Economic Growth', 'MAS'),
    ('2024-09-01', 'Unemployment Rate', 2.1, 'Percentage', 'Employment', 'MOM'),
    ('2024-09-01', 'Inflation Rate', 2.8, 'Percentage', 'Prices', 'SINGSTAT'),
    ('2024-09-01', 'Digital Economy Contribution', 17.3, 'Percentage of GDP', 'Digital', 'IMDA'),
    ('2024-08-01', 'GDP Growth Rate', 3.1, 'Percentage', 'Economic Growth', 'MAS'),
    ('2024-08-01', 'Unemployment Rate', 2.2, 'Percentage', 'Employment', 'MOM'),
    ('2024-08-01', 'Inflation Rate', 2.9, 'Percentage', 'Prices', 'SINGSTAT'),
    ('2024-08-01', 'Digital Economy Contribution', 17.1, 'Percentage of GDP', 'Digital', 'IMDA');

-- Generate transport data
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.TRANSPORT_DATA (
    TIMESTAMP,
    TRANSPORT_MODE,
    ROUTE_AREA,
    PASSENGER_COUNT,
    DELAY_MINUTES,
    SERVICE_STATUS,
    DISRUPTION_TYPE
)
WITH TRANSPORT_SAMPLE AS (
    SELECT 
        DATEADD(minute, -UNIFORM(1, 43200, RANDOM()), CURRENT_TIMESTAMP()) as TIMESTAMP,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'MRT'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Bus'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Taxi'
            ELSE 'Private Hire'
        END as TRANSPORT_MODE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Central Business District'
            WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Orchard Road'
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Jurong East'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Tampines'
            ELSE 'Woodlands'
        END as ROUTE_AREA,
        UNIFORM(50, 2000, RANDOM()) as PASSENGER_COUNT,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 0
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN UNIFORM(1, 10, RANDOM())
            ELSE UNIFORM(10, 45, RANDOM())
        END as DELAY_MINUTES,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Normal'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Minor Delay'
            ELSE 'Service Disruption'
        END as SERVICE_STATUS,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'None'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Weather'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Technical Issue'
            ELSE 'Incident'
        END as DISRUPTION_TYPE
    FROM TABLE(GENERATOR(ROWCOUNT => 1000))
)
SELECT * FROM TRANSPORT_SAMPLE;

-- Generate health trends data
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.HEALTH_TRENDS (
    REPORT_DATE,
    HEALTH_INDICATOR,
    DEMOGRAPHIC_GROUP,
    VALUE,
    TREND_DIRECTION,
    CONFIDENCE_LEVEL,
    DATA_SOURCE
)
VALUES 
    ('2024-09-15', 'Preventive Health Screening Uptake', 'Adults 40-65', 78.5, 'Increasing', 'High', 'MOH'),
    ('2024-09-15', 'Mental Health Service Utilization', 'Young Adults 18-35', 23.2, 'Increasing', 'Medium', 'IMH'),
    ('2024-09-15', 'Chronic Disease Management', 'Seniors 65+', 85.7, 'Stable', 'High', 'Polyclinics'),
    ('2024-09-15', 'Digital Health App Usage', 'All Demographics', 67.3, 'Increasing', 'High', 'HealthHub'),
    ('2024-08-15', 'Preventive Health Screening Uptake', 'Adults 40-65', 76.8, 'Increasing', 'High', 'MOH'),
    ('2024-08-15', 'Mental Health Service Utilization', 'Young Adults 18-35', 21.9, 'Increasing', 'Medium', 'IMH'),
    ('2024-08-15', 'Chronic Disease Management', 'Seniors 65+', 85.1, 'Stable', 'High', 'Polyclinics'),
    ('2024-08-15', 'Digital Health App Usage', 'All Demographics', 65.8, 'Increasing', 'High', 'HealthHub');

SELECT 'Phase 4: External data generated (weather, economic, transport, health)' as SETUP_PHASE;

-- ============================================================================
-- SECTION 5: GOVERNMENT KNOWLEDGE BASE
-- ============================================================================

-- Insert comprehensive Singapore government knowledge content
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE (
    DOCUMENT_ID,
    DOCUMENT_TITLE,
    DOCUMENT_TYPE,
    AGENCY,
    CONTENT,
    CATEGORY,
    LAST_UPDATED,
    DOCUMENT_URL,
    KEYWORDS
)
VALUES 
    ('DOC001', 'Digital Government Blueprint 2025', 'Policy Document', 'Smart Nation Office', 
     'Singapore Digital Government Blueprint outlines the strategic direction for digital transformation of government services. Key initiatives include SingPass digital identity, GovTech digital services platform, and AI-powered citizen services. The blueprint emphasizes citizen-centric design, data-driven decision making, and seamless inter-agency collaboration. Priority areas include healthcare digitization, education technology integration, and smart urban planning systems.', 
     'Digital Transformation', '2024-09-01', 'https://www.smartnation.gov.sg/digital-blueprint', 'digital government, SingPass, GovTech, AI services'),

    ('DOC002', 'Smart Nation Initiative Overview', 'Strategic Plan', 'Smart Nation Office', 
     'Smart Nation Singapore is a national initiative to harness technology and data to improve living, create economic opportunities, and build stronger communities. Key pillars include Digital Economy, Digital Government, and Digital Society. Major projects encompass autonomous vehicles, cashless payments, smart healthcare systems, and urban sensing platforms. The initiative promotes innovation through public-private partnerships and citizen engagement.', 
     'Smart Nation', '2024-08-15', 'https://www.smartnation.gov.sg', 'smart nation, digital economy, autonomous vehicles, cashless payments'),

    ('DOC003', 'SingPass Digital Identity Services', 'Service Guide', 'GovTech', 
     'SingPass is Singapore national digital identity platform providing secure access to government and private sector services. Features include biometric authentication, digital wallet, document storage, and API integration. Citizens can access over 1,400 government services through SingPass. The platform supports multi-factor authentication, facial recognition, and blockchain-based document verification for enhanced security.', 
     'Digital Identity', '2024-09-10', 'https://www.singpass.gov.sg', 'SingPass, digital identity, biometric, authentication, government services'),

    ('DOC004', 'Healthcare Digital Transformation Strategy', 'Policy Document', 'MOH', 
     'Ministry of Health digital transformation strategy focuses on integrated healthcare delivery, predictive analytics, and personalized medicine. Key components include HealthHub digital platform, telemedicine services, AI-powered diagnostics, and electronic health records integration. The strategy emphasizes preventive care, chronic disease management, and health data interoperability across healthcare providers.', 
     'Healthcare', '2024-08-20', 'https://www.moh.gov.sg', 'healthcare, HealthHub, telemedicine, AI diagnostics, electronic health records'),

    ('DOC005', 'EdTech Masterplan 2030', 'Strategic Plan', 'MOE', 
     'Ministry of Education EdTech Masterplan 2030 outlines technology-transformed learning to prepare students for a technology-transformed world. Key initiatives include AI-enabled personalized learning, digital literacy integration, 21st century competencies development, and enhanced collaborative culture. The plan emphasizes teacher professional development, learning analytics, and intelligent responsive learning environments.', 
     'Education', '2024-07-30', 'https://www.moe.gov.sg/education-in-sg/educational-technology-journey/edtech-masterplan', 'EdTech Masterplan, digital literacy, AI-enabled learning, 21st century competencies'),

    ('FAQ001', 'How to Apply for HDB Housing', 'FAQ', 'HDB', 
     'Housing Development Board (HDB) housing application process: 1) Register for HDB Flat Eligibility (HFE) letter online, 2) Submit application during sales launch, 3) Complete required documents including income assessment, 4) Attend appointment for verification, 5) Sign lease agreement upon successful allocation. Eligibility criteria include citizenship, age, income ceiling, and first-time applicant status. Various housing schemes available including BTO, SBF, and resale options.', 
     'Housing', '2024-09-01', 'https://www.hdb.gov.sg', 'HDB, housing application, BTO, eligibility, lease agreement'),

    ('FAQ002', 'SingPass Account Setup and Troubleshooting', 'FAQ', 'GovTech', 
     'SingPass account setup: 1) Visit SingPass website or download mobile app, 2) Register using NRIC and personal details, 3) Verify identity through SMS or physical verification, 4) Set up 2FA authentication, 5) Complete profile setup. Troubleshooting common issues: password reset through SMS verification, account lockout resolution through customer service, biometric setup for mobile app, and API integration for developers.', 
     'Digital Services', '2024-09-15', 'https://www.singpass.gov.sg', 'SingPass, account setup, 2FA, biometric, troubleshooting'),

    ('FAQ003', 'Healthcare Subsidies and Medisave Usage', 'FAQ', 'MOH', 
     'Healthcare subsidies in Singapore: Medisave for hospitalization and approved medical procedures, Medishield Life for catastrophic medical expenses, Community Health Assist Scheme (CHAS) for primary care, and Pioneer Generation Package for seniors. Medisave usage guidelines include withdrawal limits, approved procedures, and family member coverage. Subsidy eligibility based on income assessment and citizenship status.', 
     'Healthcare', '2024-08-30', 'https://www.moh.gov.sg', 'healthcare subsidies, Medisave, Medishield, CHAS, Pioneer Generation'),

    ('FAQ004', 'Business Registration and Licensing', 'FAQ', 'ACRA', 
     'Business registration process: 1) Reserve company name through BizFile+, 2) Prepare incorporation documents, 3) Submit application with required fees, 4) Obtain business registration certificate, 5) Apply for relevant business licenses. Required documents include memorandum and articles of association, director and shareholder details, registered office address. Various business structures available including private limited company, sole proprietorship, and partnership.', 
     'Business Services', '2024-08-10', 'https://www.acra.gov.sg', 'business registration, ACRA, BizFile+, incorporation, licensing'),

    ('FAQ005', 'Work Pass and Employment Guidelines', 'FAQ', 'MOM', 
     'Work pass applications for foreign workers: Employment Pass for professionals, S Pass for mid-skilled workers, Work Permit for semi-skilled workers. Application process includes employer sponsorship, salary requirements, educational qualifications, and quota limitations. Renewal procedures, dependent pass applications, and permanent residence pathways. Compliance requirements for employers including levy payments and worker welfare standards.', 
     'Employment', '2024-09-08', 'https://www.mom.gov.sg', 'work pass, Employment Pass, S Pass, Work Permit, MOM');

SELECT 'Phase 5: Government knowledge base populated (15 documents)' as SETUP_PHASE;

-- ============================================================================
-- SECTION 6: ANALYTICS VIEWS AND STORED PROCEDURES
-- ============================================================================

-- Create stored procedures for demo automation
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GENERATE_POLICY_BRIEF(
    POLICY_NAME STRING,
    RECIPIENT_EMAIL STRING DEFAULT 'demo@govtech.gov.sg'
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET brief_content STRING := 'Policy Brief Generated for: ' || POLICY_NAME ||
                               ' - Sent to: ' || RECIPIENT_EMAIL ||
                               ' at ' || CURRENT_TIMESTAMP()::STRING;

    INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE
    VALUES (
        'BRIEF_' || UNIFORM(1000000, 9999999, RANDOM()),
        'Policy Briefing Service',
        'Prime Ministers Office',
        'Briefings Generated',
        1,
        CURRENT_DATE(),
        5,
        'Active',
        CURRENT_TIMESTAMP()
    );

    RETURN brief_content;
END;
$$;

CREATE OR REPLACE PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_SERVICE_ALERT(
    ALERT_MESSAGE STRING,
    SEVERITY STRING DEFAULT 'MEDIUM',
    TARGET_AGENCIES STRING DEFAULT 'ALL'
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET alert_id STRING := 'ALERT_' || UNIFORM(1000000, 9999999, RANDOM());

    INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE
    VALUES (
        alert_id,
        'Alert System',
        'Smart Nation Office',
        'Alerts Sent',
        1,
        CURRENT_DATE(),
        10,
        'Active',
        CURRENT_TIMESTAMP()
    );

    RETURN 'Alert sent: ' || alert_id || ' - Message: ' || ALERT_MESSAGE ||
           ' - Severity: ' || SEVERITY || ' - Targets: ' || TARGET_AGENCIES;
END;
$$;

CREATE OR REPLACE PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.OPTIMIZE_RESOURCES(
    SERVICE_TYPE STRING,
    TIME_PERIOD STRING DEFAULT 'NEXT_WEEK'
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET optimization_id STRING := 'OPT_' || UNIFORM(1000000, 9999999, RANDOM());

    LET recommendation STRING := 'Resource optimization completed for ' || SERVICE_TYPE ||
                                ' for period: ' || TIME_PERIOD ||
                                '. Recommendation ID: ' || optimization_id;

    INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE
    VALUES (
        optimization_id,
        'Resource Optimization',
        'Ministry of Finance',
        'Optimizations Performed',
        1,
        CURRENT_DATE(),
        3,
        'Active',
        CURRENT_TIMESTAMP()
    );

    RETURN recommendation;
END;
$$;

-- Grant execute permissions on procedures
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GENERATE_POLICY_BRIEF(STRING, STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_SERVICE_ALERT(STRING, STRING, STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.OPTIMIZE_RESOURCES(STRING, STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Create analytics views
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.CITIZEN_SATISFACTION_SUMMARY AS
SELECT
    cp.AGE_GROUP,
    cp.POSTAL_DISTRICT,
    AVG(cp.SATISFACTION_SCORE) as AVG_SATISFACTION,
    COUNT(*) as CITIZEN_COUNT,
    AVG(cp.DIGITAL_LITERACY_SCORE) as AVG_DIGITAL_LITERACY
FROM SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES cp
GROUP BY cp.AGE_GROUP, cp.POSTAL_DISTRICT;

CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE_DASHBOARD AS
SELECT
    sp.AGENCY,
    sp.SERVICE_NAME,
    sp.METRIC_TYPE,
    AVG(sp.METRIC_VALUE) as AVG_PERFORMANCE,
    AVG(sp.BENCHMARK_VALUE) as BENCHMARK,
    COUNT(CASE WHEN sp.PERFORMANCE_STATUS = 'Exceeding' THEN 1 END) as EXCEEDING_COUNT,
    COUNT(*) as TOTAL_METRICS
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE sp
WHERE sp.MEASUREMENT_DATE >= DATEADD(day, -30, CURRENT_DATE())
GROUP BY sp.AGENCY, sp.SERVICE_NAME, sp.METRIC_TYPE;

-- Create weather-service correlation views
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_SERVICE_CORRELATION_SIMPLE AS
SELECT 
    DATE(si.INTERACTION_TIMESTAMP) as SERVICE_DATE,
    wd.WEATHER_CONDITION,
    wd.RAINFALL_MM,
    wd.ALERT_LEVEL,
    si.SERVICE_TYPE,
    si.INTERACTION_CHANNEL,
    COUNT(*) as INTERACTION_COUNT,
    AVG(si.DURATION_MINUTES) as AVG_DURATION,
    AVG(si.SATISFACTION_RATING) as AVG_SATISFACTION
FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS si
JOIN SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA wd 
    ON DATE(si.INTERACTION_TIMESTAMP) = DATE(wd.DATE_TIME)
    AND wd.LOCATION = 'Marina Barrage'
GROUP BY 1,2,3,4,5,6;

-- Create economic policy impact view
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.ECONOMIC_POLICY_IMPACT AS
SELECT 
    pi.POLICY_NAME,
    pi.IMPLEMENTATION_DATE,
    pi.IMPACT_PERCENTAGE,
    ei.INDICATOR_NAME,
    ei.VALUE as ECONOMIC_VALUE,
    ei.INDICATOR_DATE
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT pi
CROSS JOIN SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS ei
WHERE ei.INDICATOR_DATE >= pi.IMPLEMENTATION_DATE;

SELECT 'Phase 6: Analytics views and stored procedures created' as SETUP_PHASE;

-- ============================================================================
-- SECTION 7: CORTEX SEARCH SERVICE
-- ============================================================================

-- Create Cortex Search service for government knowledge
CREATE OR REPLACE CORTEX SEARCH SERVICE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE
ON CONTENT
WAREHOUSE = SNOWFLAKE_DEMO_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        DOCUMENT_URL as DOCUMENT_ID,  -- Use URL as the primary ID for proper linking
        DOCUMENT_TITLE || ' - ' || AGENCY || ' (' || DOCUMENT_TYPE || ')' as TITLE,
        CONTENT,
        OBJECT_CONSTRUCT(
            'document_id', DOCUMENT_ID,
            'title', DOCUMENT_TITLE,
            'type', DOCUMENT_TYPE,
            'agency', AGENCY,
            'category', CATEGORY,
            'last_updated', LAST_UPDATED,
            'url', DOCUMENT_URL,
            'keywords', KEYWORDS,
            'source_link', DOCUMENT_URL  -- Explicit source link field
        ) as METADATA
    FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
);

-- Grant permissions for the search service
GRANT USAGE ON CORTEX SEARCH SERVICE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE 
TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

SELECT 'Phase 7: Cortex Search service created' as SETUP_PHASE;

-- ============================================================================
-- SECTION 8: SEMANTIC MODEL INFRASTRUCTURE
-- ============================================================================

-- Create stage for semantic model files
CREATE STAGE IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE
    COMMENT = 'Stage for Cortex Analyst semantic model YAML files';

-- Create file format for YAML files
CREATE OR REPLACE FILE FORMAT SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.YAML_FORMAT
    TYPE = 'CSV'
    FIELD_DELIMITER = NONE
    RECORD_DELIMITER = NONE
    SKIP_HEADER = 0
    FIELD_OPTIONALLY_ENCLOSED_BY = NONE
    ESCAPE_UNENCLOSED_FIELD = NONE
    COMMENT = 'File format for YAML semantic model files';

-- Grant necessary privileges for Cortex Analyst
GRANT USAGE ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT READ ON STAGE SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

SELECT 'Phase 8: Semantic model infrastructure created' as SETUP_PHASE;

-- ============================================================================
-- SECTION 9: FINAL SUMMARY AND VERIFICATION
-- ============================================================================

-- Create comprehensive demo summary view
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS AS
SELECT 
    'Total Citizens in System' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES
UNION ALL
SELECT 
    'Total Service Interactions' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS
UNION ALL
SELECT 
    'Active Government Services Monitored' as METRIC,
    COUNT(DISTINCT SERVICE_NAME)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE
UNION ALL
SELECT 
    'Policy Initiatives Tracked' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT
UNION ALL
SELECT 
    'Inter-Agency Workflows Processed' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS
UNION ALL
SELECT 
    'Weather Data Points (90 days)' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA
UNION ALL
SELECT 
    'Government Knowledge Documents' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
UNION ALL
SELECT 
    'Services Meeting Performance Benchmarks' as METRIC,
    ROUND((COUNT(CASE WHEN PERFORMANCE_STATUS IN ('Meeting', 'Exceeding') THEN 1 END) * 100.0 / COUNT(*)), 1)::STRING || '%' as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE
WHERE MEASUREMENT_DATE >= DATEADD(day, -7, CURRENT_DATE())
UNION ALL
SELECT 
    'Inter-Agency Workflows Completed (This Month)' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS
WHERE STATUS = 'Completed' 
AND COMPLETION_TIMESTAMP >= DATE_TRUNC('month', CURRENT_DATE());

-- Final verification and summary
SELECT 'Singapore Smart Nation Intelligence Demo setup completed successfully!' as SETUP_STATUS,
       'Ready for Snowflake Intelligence Agent configuration and Public Sector Day 2025 demonstration' as NEXT_STEP;

-- Show comprehensive summary of generated data
SELECT 
    'FINAL DEMO STATISTICS' as SECTION,
    '' as METRIC,
    '' as VALUE
UNION ALL
SELECT * FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS
ORDER BY SECTION DESC, METRIC;

-- ============================================================================
-- SETUP COMPLETE - SINGAPORE SMART NATION INTELLIGENCE DEMO READY
-- ============================================================================

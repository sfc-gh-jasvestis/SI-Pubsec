-- ============================================================================
-- SINGAPORE SMART NATION INTELLIGENCE DEMO - COMPLETE SETUP
-- Public Sector Day Singapore 2025
-- "Talk to Enterprise Data Instantly" - Snowflake Intelligence Demo
-- ============================================================================

-- This script sets up the complete Singapore Smart Nation Intelligence Demo
-- including all databases, schemas, tables, data, semantic models, and services
--
-- UPDATED: Includes all correlation fixes for realistic data relationships:
-- - Service interactions: Success correlates with satisfaction and duration
-- - Citizen profiles: Digital literacy correlates with age group
-- - Inter-agency workflows: Status correlates with completion timestamps
-- - Weather data: Alert levels correlate with actual weather conditions
-- - Transport data: Delay minutes correlate with service status

-- ============================================================================
-- SECTION 1: INITIAL SETUP AND PERMISSIONS
-- ============================================================================

-- Switch to ACCOUNTADMIN role for initial setup
USE ROLE ACCOUNTADMIN;

-- Set session timezone to Singapore time for accurate timestamps
ALTER SESSION SET TIMEZONE = 'Asia/Singapore';

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

-- Grant database and schema privileges for demo data
GRANT USAGE ON DATABASE SNOWFLAKE_PUBSEC_DEMO TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.SERVICES TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.ANALYTICS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant all privileges on all future tables in INTELLIGENCE schema
GRANT ALL ON ALL TABLES IN SCHEMA SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT ALL ON FUTURE TABLES IN SCHEMA SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant role to current user (using session variable)
SET current_user_name = CURRENT_USER();
GRANT ROLE SNOWFLAKE_INTELLIGENCE_ADMIN TO USER IDENTIFIER($current_user_name);

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

-- Create email log table for notification tracking
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.EMAIL_LOG (
    EMAIL_ID STRING,
    RECIPIENT_EMAIL STRING,
    SUBJECT STRING,
    BODY TEXT,
    SENT_TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    STATUS STRING DEFAULT 'SENT'
);

-- Create citizen journey tracking tables
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.SERVICES.CITIZEN_PORTAL_INTERACTIONS (
    PORTAL_INTERACTION_ID STRING,
    CITIZEN_ID STRING,
    INTERACTION_TYPE STRING,  -- 'Inquiry', 'Service Request', 'Feedback', 'Follow-up'
    CHANNEL STRING,  -- 'Web Portal', 'Mobile App', 'Chatbot', 'Service Center'
    INQUIRY_CATEGORY STRING,
    INQUIRY_DETAILS TEXT,
    ASSIGNED_AGENCY STRING,
    INTERACTION_TIMESTAMP TIMESTAMP,
    RESPONSE_TIME_HOURS NUMBER(5,2),
    STATUS STRING,  -- 'Received', 'Processing', 'Escalated', 'Resolved'
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_FULFILLMENT (
    FULFILLMENT_ID STRING,
    CITIZEN_ID STRING,
    SERVICE_REQUEST_ID STRING,
    SERVICE_TYPE STRING,
    REQUESTING_AGENCY STRING,
    FULFILLING_AGENCY STRING,
    REQUEST_DATE DATE,
    FULFILLMENT_DATE DATE,
    PROCESSING_TIME_DAYS NUMBER(5,1),
    COST_TO_DELIVER NUMBER(10,2),
    CITIZEN_SATISFACTION_SCORE NUMBER(3,2),
    FULFILLMENT_STATUS STRING,  -- 'Completed', 'In Progress', 'Cancelled', 'Escalated'
    NOTES TEXT,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.WEB_SCRAPE_LOG (
    SCRAPE_ID STRING,
    URL TEXT,
    SCRAPED_CONTENT TEXT,
    CONTENT_TYPE STRING,
    SCRAPE_TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP(),
    STATUS STRING,
    ERROR_MESSAGE TEXT,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

SELECT 'Phase 2: Core data tables created (including citizen journey tracking)' as SETUP_PHASE;

-- ============================================================================
-- SECTION 3: SYNTHETIC DATA GENERATION
-- ============================================================================

-- Generate synthetic citizen profiles with age-correlated digital literacy (40,000 records)
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
        DATEADD(day, -UNIFORM(1, 365, RANDOM()), CURRENT_DATE()) as LAST_INTERACTION_DATE
    FROM TABLE(GENERATOR(ROWCOUNT => 40000))
),
CITIZENS_WITH_CORRELATION AS (
    SELECT 
        CITIZEN_ID,
        AGE_GROUP,
        POSTAL_DISTRICT,
        PREFERRED_LANGUAGE,
        LAST_INTERACTION_DATE,
        -- Digital literacy correlates with age group (younger = higher literacy)
        CASE 
            WHEN AGE_GROUP = '18-25' THEN ROUND(UNIFORM(3.5, 5.0, RANDOM()), 2)
            WHEN AGE_GROUP = '26-35' THEN ROUND(UNIFORM(3.0, 5.0, RANDOM()), 2)
            WHEN AGE_GROUP = '36-50' THEN ROUND(UNIFORM(2.5, 4.5, RANDOM()), 2)
            WHEN AGE_GROUP = '51-65' THEN ROUND(UNIFORM(2.0, 4.0, RANDOM()), 2)
            ELSE ROUND(UNIFORM(1.0, 3.0, RANDOM()), 2)
        END as DIGITAL_LITERACY_SCORE,
        -- Service usage frequency correlates with age and digital literacy
        CASE 
            WHEN AGE_GROUP IN ('18-25', '26-35') THEN 
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Daily'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Weekly'
                    ELSE 'Monthly'
                END
            WHEN AGE_GROUP IN ('36-50', '51-65') THEN 
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Daily'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Weekly'
                    ELSE 'Monthly'
                END
            ELSE 
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 10 THEN 'Daily'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 30 THEN 'Weekly'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Monthly'
                    ELSE 'Rarely'
                END
        END as SERVICE_USAGE_FREQUENCY,
        -- Satisfaction correlates with digital literacy (higher literacy = easier to use services)
        CASE 
            WHEN AGE_GROUP IN ('18-25', '26-35') THEN ROUND(UNIFORM(3.5, 5.0, RANDOM()), 2)
            WHEN AGE_GROUP IN ('36-50', '51-65') THEN ROUND(UNIFORM(3.0, 4.5, RANDOM()), 2)
            ELSE ROUND(UNIFORM(2.5, 4.0, RANDOM()), 2)
        END as SATISFACTION_SCORE
    FROM SYNTHETIC_CITIZENS
)
SELECT 
    CITIZEN_ID,
    AGE_GROUP,
    POSTAL_DISTRICT,
    PREFERRED_LANGUAGE,
    DIGITAL_LITERACY_SCORE,
    SERVICE_USAGE_FREQUENCY,
    LAST_INTERACTION_DATE,
    SATISFACTION_SCORE
FROM CITIZENS_WITH_CORRELATION;

SELECT 'Phase 3a: Citizen profiles generated (40,000 records)' as SETUP_PHASE;

-- Generate service interactions with proper correlation between success and satisfaction (200,000 records)
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
        'SNOWFLAKE' || LPAD(UNIFORM(1, 40000, RANDOM()), 8, '0') as CITIZEN_ID,
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
        UNIFORM(1, 100, RANDOM()) as SUCCESS_RANDOM,
        DATEADD(minute, -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()) as INTERACTION_TIMESTAMP
    FROM TABLE(GENERATOR(ROWCOUNT => 200000))
),
INTERACTIONS_WITH_CORRELATION AS (
    SELECT 
        INTERACTION_ID,
        CITIZEN_ID,
        SERVICE_TYPE,
        AGENCY,
        INTERACTION_CHANNEL,
        INTERACTION_TIMESTAMP,
        -- Duration correlates with success (failed interactions take longer)
        CASE 
            WHEN SUCCESS_RANDOM <= 85 THEN UNIFORM(5, 45, RANDOM())
            ELSE UNIFORM(30, 120, RANDOM())
        END as DURATION_MINUTES,
        -- Success flag
        CASE WHEN SUCCESS_RANDOM <= 85 THEN TRUE ELSE FALSE END as SUCCESS_FLAG,
        -- Satisfaction correlates strongly with success
        CASE 
            WHEN SUCCESS_RANDOM <= 85 THEN 
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 5
                    WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 4
                    ELSE 3
                END
            ELSE 
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 1
                    WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 2
                    ELSE 3
                END
        END as SATISFACTION_RATING
    FROM SYNTHETIC_INTERACTIONS
)
SELECT 
    INTERACTION_ID,
    CITIZEN_ID,
    SERVICE_TYPE,
    AGENCY,
    INTERACTION_CHANNEL,
    DURATION_MINUTES,
    SUCCESS_FLAG,
    SATISFACTION_RATING,
    INTERACTION_TIMESTAMP
FROM INTERACTIONS_WITH_CORRELATION;

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

-- Generate inter-agency workflow data with proper status-timestamp correlation
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
        DATEADD(hour, -UNIFORM(1, 2160, RANDOM()), CURRENT_TIMESTAMP()) as HANDOFF_TIMESTAMP,
        UNIFORM(1, 100, RANDOM()) as STATUS_RANDOM
    FROM WORKFLOW_TYPES wt
    CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 500))
),
WORKFLOWS_WITH_CORRELATION AS (
    SELECT 
        WORKFLOW_ID,
        CITIZEN_REQUEST_ID,
        SOURCE_AGENCY,
        TARGET_AGENCY,
        WORKFLOW_TYPE,
        HANDOFF_TIMESTAMP,
        -- Status determination
        CASE 
            WHEN STATUS_RANDOM <= 70 THEN 'Completed'
            WHEN STATUS_RANDOM <= 85 THEN 'In Progress'
            WHEN STATUS_RANDOM <= 95 THEN 'Pending'
            ELSE 'Escalated'
        END as STATUS,
        -- Processing time correlates with status
        CASE 
            WHEN STATUS_RANDOM <= 70 THEN ROUND(UNIFORM(2.0, 48.0, RANDOM()), 2)
            WHEN STATUS_RANDOM <= 85 THEN 
                -- In Progress: limit to reasonable processing time (max 168 hours = 1 week)
                ROUND(LEAST(DATEDIFF(hour, HANDOFF_TIMESTAMP, CURRENT_TIMESTAMP()), 168.0), 2)
            WHEN STATUS_RANDOM <= 95 THEN ROUND(UNIFORM(0.5, 4.0, RANDOM()), 2)
            ELSE ROUND(UNIFORM(48.0, 168.0, RANDOM()), 2)
        END as PROCESSING_TIME_HOURS,
        -- Completion timestamp only for completed workflows
        CASE 
            WHEN STATUS_RANDOM <= 70 THEN DATEADD(hour, UNIFORM(2, 48, RANDOM()), HANDOFF_TIMESTAMP)
            ELSE NULL
        END as COMPLETION_TIMESTAMP
    FROM SYNTHETIC_WORKFLOWS
)
SELECT 
    WORKFLOW_ID,
    CITIZEN_REQUEST_ID,
    SOURCE_AGENCY,
    TARGET_AGENCY,
    WORKFLOW_TYPE,
    STATUS,
    PROCESSING_TIME_HOURS,
    HANDOFF_TIMESTAMP,
    COMPLETION_TIMESTAMP
FROM WORKFLOWS_WITH_CORRELATION;

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

-- Generate citizen portal interactions data (15,000 records)
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.SERVICES.CITIZEN_PORTAL_INTERACTIONS (
    PORTAL_INTERACTION_ID,
    CITIZEN_ID,
    INTERACTION_TYPE,
    CHANNEL,
    INQUIRY_CATEGORY,
    INQUIRY_DETAILS,
    ASSIGNED_AGENCY,
    INTERACTION_TIMESTAMP,
    RESPONSE_TIME_HOURS,
    STATUS
)
WITH SYNTHETIC_PORTAL_INTERACTIONS AS (
    SELECT 
        'PORTAL' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as PORTAL_INTERACTION_ID,
        'SNOWFLAKE' || LPAD(UNIFORM(1, 40000, RANDOM()), 8, '0') as CITIZEN_ID,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Inquiry'
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Service Request'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Feedback'
            ELSE 'Follow-up'
        END as INTERACTION_TYPE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 45 THEN 'Web Portal'
            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 'Mobile App'
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'Chatbot'
            ELSE 'Service Center'
        END as CHANNEL,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'Housing Application'
            WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 'Healthcare Services'
            WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Education Services'
            WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'Tax & Finance'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Transport Services'
            ELSE 'Social Services'
        END as INQUIRY_CATEGORY,
        DATEADD(hour, -UNIFORM(1, 4320, RANDOM()), CURRENT_TIMESTAMP()) as INTERACTION_TIMESTAMP,
        UNIFORM(1, 100, RANDOM()) as STATUS_RANDOM
    FROM TABLE(GENERATOR(ROWCOUNT => 15000))
),
PORTAL_WITH_STATUS AS (
    SELECT 
        PORTAL_INTERACTION_ID,
        CITIZEN_ID,
        INTERACTION_TYPE,
        CHANNEL,
        INQUIRY_CATEGORY,
        'Citizen inquiry regarding ' || INQUIRY_CATEGORY || ' via ' || CHANNEL as INQUIRY_DETAILS,
        CASE 
            WHEN INQUIRY_CATEGORY = 'Housing Application' THEN 'HDB'
            WHEN INQUIRY_CATEGORY = 'Healthcare Services' THEN 'MOH'
            WHEN INQUIRY_CATEGORY = 'Education Services' THEN 'MOE'
            WHEN INQUIRY_CATEGORY = 'Tax & Finance' THEN 'IRAS'
            WHEN INQUIRY_CATEGORY = 'Transport Services' THEN 'LTA'
            ELSE 'MSF'
        END as ASSIGNED_AGENCY,
        INTERACTION_TIMESTAMP,
        CASE 
            WHEN STATUS_RANDOM <= 75 THEN ROUND(UNIFORM(0.5, 24.0, RANDOM()), 2)
            WHEN STATUS_RANDOM <= 90 THEN ROUND(UNIFORM(24.0, 72.0, RANDOM()), 2)
            ELSE ROUND(UNIFORM(72.0, 168.0, RANDOM()), 2)
        END as RESPONSE_TIME_HOURS,
        CASE 
            WHEN STATUS_RANDOM <= 75 THEN 'Resolved'
            WHEN STATUS_RANDOM <= 90 THEN 'Processing'
            WHEN STATUS_RANDOM <= 95 THEN 'Escalated'
            ELSE 'Received'
        END as STATUS
    FROM SYNTHETIC_PORTAL_INTERACTIONS
)
SELECT * FROM PORTAL_WITH_STATUS;

-- Generate service fulfillment data (8,000 records)
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_FULFILLMENT (
    FULFILLMENT_ID,
    CITIZEN_ID,
    SERVICE_REQUEST_ID,
    SERVICE_TYPE,
    REQUESTING_AGENCY,
    FULFILLING_AGENCY,
    REQUEST_DATE,
    FULFILLMENT_DATE,
    PROCESSING_TIME_DAYS,
    COST_TO_DELIVER,
    CITIZEN_SATISFACTION_SCORE,
    FULFILLMENT_STATUS,
    NOTES
)
WITH SYNTHETIC_FULFILLMENT AS (
    SELECT 
        'FULFILL' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as FULFILLMENT_ID,
        'SNOWFLAKE' || LPAD(UNIFORM(1, 40000, RANDOM()), 8, '0') as CITIZEN_ID,
        'REQ' || LPAD(UNIFORM(1, 100000, RANDOM()), 8, '0') as SERVICE_REQUEST_ID,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 25 THEN 'Housing Grant Application'
            WHEN UNIFORM(1, 100, RANDOM()) <= 45 THEN 'Healthcare Subsidy'
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Education Grant'
            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 'Business License'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Tax Rebate'
            ELSE 'Social Assistance'
        END as SERVICE_TYPE,
        DATEADD(day, -UNIFORM(1, 180, RANDOM()), CURRENT_DATE()) as REQUEST_DATE,
        UNIFORM(1, 100, RANDOM()) as STATUS_RANDOM
    FROM TABLE(GENERATOR(ROWCOUNT => 8000))
),
FULFILLMENT_WITH_DETAILS AS (
    SELECT 
        FULFILLMENT_ID,
        CITIZEN_ID,
        SERVICE_REQUEST_ID,
        SERVICE_TYPE,
        CASE 
            WHEN SERVICE_TYPE = 'Housing Grant Application' THEN 'HDB'
            WHEN SERVICE_TYPE = 'Healthcare Subsidy' THEN 'MOH'
            WHEN SERVICE_TYPE = 'Education Grant' THEN 'MOE'
            WHEN SERVICE_TYPE = 'Business License' THEN 'ACRA'
            WHEN SERVICE_TYPE = 'Tax Rebate' THEN 'IRAS'
            ELSE 'MSF'
        END as REQUESTING_AGENCY,
        CASE 
            WHEN SERVICE_TYPE IN ('Housing Grant Application', 'Social Assistance') THEN 'CPF'
            WHEN SERVICE_TYPE = 'Healthcare Subsidy' THEN 'Polyclinics'
            WHEN SERVICE_TYPE = 'Education Grant' THEN 'MOE'
            WHEN SERVICE_TYPE = 'Business License' THEN 'ACRA'
            WHEN SERVICE_TYPE = 'Tax Rebate' THEN 'IRAS'
            ELSE 'MSF'
        END as FULFILLING_AGENCY,
        REQUEST_DATE,
        STATUS_RANDOM,
        CASE 
            WHEN STATUS_RANDOM <= 70 THEN 
                DATEADD(day, UNIFORM(3, 45, RANDOM()), REQUEST_DATE)
            ELSE NULL
        END as FULFILLMENT_DATE,
        CASE 
            WHEN STATUS_RANDOM <= 70 THEN ROUND(UNIFORM(3.0, 45.0, RANDOM()), 1)
            WHEN STATUS_RANDOM <= 90 THEN ROUND(UNIFORM(1.0, 30.0, RANDOM()), 1)
            ELSE ROUND(UNIFORM(45.0, 90.0, RANDOM()), 1)
        END as PROCESSING_TIME_DAYS,
        ROUND(UNIFORM(50.0, 500.0, RANDOM()), 2) as COST_TO_DELIVER,
        CASE 
            WHEN STATUS_RANDOM <= 70 THEN ROUND(UNIFORM(3.5, 5.0, RANDOM()), 2)
            WHEN STATUS_RANDOM <= 90 THEN ROUND(UNIFORM(3.0, 4.5, RANDOM()), 2)
            ELSE ROUND(UNIFORM(2.0, 3.5, RANDOM()), 2)
        END as CITIZEN_SATISFACTION_SCORE,
        CASE 
            WHEN STATUS_RANDOM <= 70 THEN 'Completed'
            WHEN STATUS_RANDOM <= 90 THEN 'In Progress'
            WHEN STATUS_RANDOM <= 95 THEN 'Escalated'
            ELSE 'Cancelled'
        END as FULFILLMENT_STATUS
    FROM SYNTHETIC_FULFILLMENT
)
SELECT 
    FULFILLMENT_ID,
    CITIZEN_ID,
    SERVICE_REQUEST_ID,
    SERVICE_TYPE,
    REQUESTING_AGENCY,
    FULFILLING_AGENCY,
    REQUEST_DATE,
    FULFILLMENT_DATE,
    PROCESSING_TIME_DAYS,
    COST_TO_DELIVER,
    CITIZEN_SATISFACTION_SCORE,
    FULFILLMENT_STATUS,
    CASE 
        WHEN FULFILLMENT_STATUS = 'Completed' THEN 'Service successfully delivered'
        WHEN FULFILLMENT_STATUS = 'In Progress' THEN 'Processing application'
        WHEN FULFILLMENT_STATUS = 'Escalated' THEN 'Requires additional documentation'
        ELSE 'Cancelled by citizen'
    END as NOTES
FROM FULFILLMENT_WITH_DETAILS;

SELECT 'Phase 3e: Citizen journey tracking data generated (23,000 records)' as SETUP_PHASE;

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

-- Generate transport data with proper correlation between delay and status
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
        -- Use a single random number to determine both status and delay consistently
        UNIFORM(1, 100, RANDOM()) as STATUS_RANDOM
    FROM TABLE(GENERATOR(ROWCOUNT => 1000))
),
TRANSPORT_WITH_STATUS AS (
    SELECT 
        TIMESTAMP,
        TRANSPORT_MODE,
        ROUTE_AREA,
        PASSENGER_COUNT,
        STATUS_RANDOM,
        -- Determine service status first
        CASE 
            WHEN STATUS_RANDOM <= 85 THEN 'Normal'
            WHEN STATUS_RANDOM <= 95 THEN 'Minor Delay'
            ELSE 'Service Disruption'
        END as SERVICE_STATUS,
        -- Then set delay minutes based on the service status
        CASE 
            WHEN STATUS_RANDOM <= 85 THEN 
                -- Normal service: mostly 0 delay, occasionally 1-2 minutes
                CASE WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 0 ELSE UNIFORM(1, 2, RANDOM()) END
            WHEN STATUS_RANDOM <= 95 THEN 
                -- Minor Delay: 3-15 minutes delay
                UNIFORM(3, 15, RANDOM())
            ELSE 
                -- Service Disruption: 15-45 minutes delay
                UNIFORM(15, 45, RANDOM())
        END as DELAY_MINUTES,
        -- Set disruption type based on service status
        CASE 
            WHEN STATUS_RANDOM <= 85 THEN 
                -- Normal service: mostly no disruption
                CASE WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'None' ELSE 'Weather' END
            WHEN STATUS_RANDOM <= 95 THEN 
                -- Minor Delay: weather or technical issues
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Weather'
                    ELSE 'Technical Issue'
                END
            ELSE 
                -- Service Disruption: technical issues or incidents
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Technical Issue'
                    ELSE 'Incident'
                END
        END as DISRUPTION_TYPE
    FROM TRANSPORT_SAMPLE
)
SELECT 
    TIMESTAMP,
    TRANSPORT_MODE,
    ROUTE_AREA,
    PASSENGER_COUNT,
    DELAY_MINUTES,
    SERVICE_STATUS,
    DISRUPTION_TYPE
FROM TRANSPORT_WITH_STATUS;

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
     'Digital Transformation', '2024-09-01', 'https://www.smartnation.gov.sg', 'digital government, SingPass, GovTech, AI services'),

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

    ('DOC006', 'Urban Planning and Smart City Infrastructure', 'Technical Guide', 'URA', 
     'Urban Redevelopment Authority smart city infrastructure guide covers intelligent transportation systems, smart building standards, environmental monitoring networks, and integrated urban planning platforms. Key technologies include IoT sensors, 5G connectivity, digital twins, and predictive analytics for urban management. The guide emphasizes sustainable development and citizen quality of life improvements.', 
     'Urban Planning', '2024-08-05', 'https://www.ura.gov.sg', 'urban planning, smart city, IoT sensors, 5G, digital twins, sustainable development'),

    ('DOC007', 'Cybersecurity Framework for Government Agencies', 'Security Policy', 'CSA', 
     'Cyber Security Agency framework provides comprehensive cybersecurity guidelines for government agencies. Components include threat assessment protocols, incident response procedures, security architecture standards, and staff training requirements. The framework emphasizes zero-trust security models, continuous monitoring, and inter-agency threat intelligence sharing for robust cyber defense.', 
     'Cybersecurity', '2024-09-05', 'https://www.csa.gov.sg', 'cybersecurity, threat assessment, incident response, zero-trust, threat intelligence'),

    ('DOC008', 'Data Governance and Privacy Protection Guidelines', 'Policy Document', 'PDPC', 
     'Personal Data Protection Commission guidelines establish data governance standards for government agencies. Key principles include data minimization, purpose limitation, consent management, and privacy by design. The guidelines cover data sharing protocols, citizen rights, breach notification procedures, and compliance monitoring frameworks to ensure responsible data stewardship.', 
     'Data Governance', '2024-08-25', 'https://www.pdpc.gov.sg', 'data governance, privacy protection, data minimization, consent management, compliance'),

    ('DOC009', 'Inter-Agency Collaboration Framework', 'Operational Guide', 'PMO', 
     'Prime Minister Office inter-agency collaboration framework facilitates seamless coordination across government agencies. Components include shared service platforms, standardized APIs, common data formats, and collaborative workflow systems. The framework promotes efficiency, reduces duplication, and enables holistic policy implementation through integrated government operations.', 
     'Inter-Agency Collaboration', '2024-07-15', 'https://www.pmo.gov.sg', 'inter-agency, collaboration, shared services, APIs, workflow systems'),

    ('DOC010', 'Citizen Engagement and Feedback Systems', 'Service Guide', 'REACH', 
     'REACH citizen engagement platform enables government-citizen communication through multiple channels including online portals, mobile apps, community forums, and feedback systems. The platform supports policy consultation, service feedback, and community participation in government decision-making processes. Features include sentiment analysis, trend identification, and responsive communication protocols.', 
     'Citizen Engagement', '2024-09-12', 'https://www.reach.gov.sg', 'citizen engagement, feedback systems, policy consultation, community participation, sentiment analysis'),

    ('FAQ005', 'Work Pass and Employment Guidelines', 'FAQ', 'MOM', 
     'Work pass applications for foreign workers: Employment Pass for professionals, S Pass for mid-skilled workers, Work Permit for semi-skilled workers. Application process includes employer sponsorship, salary requirements, educational qualifications, and quota limitations. Renewal procedures, dependent pass applications, and permanent residence pathways. Compliance requirements for employers including levy payments and worker welfare standards.', 
     'Employment', '2024-09-08', 'https://www.mom.gov.sg', 'work pass, Employment Pass, S Pass, Work Permit, MOM');

SELECT 'Phase 5: Government knowledge base populated (15 documents)' as SETUP_PHASE;

-- ============================================================================
-- SECTION 6: ANALYTICS VIEWS AND STORED PROCEDURES
-- ============================================================================

-- Create email notification integration (requires ACCOUNTADMIN)
-- Note: This needs to be configured with actual SMTP settings
-- For demo purposes, we'll create a mock email function that logs to a table

-- Create email sending function
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_EMAIL(
    RECIPIENT_EMAIL STRING,
    SUBJECT STRING,
    BODY TEXT
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Generate unique email ID using LET statement
    LET v_email_id STRING := 'EMAIL_' || ABS(HASH(CURRENT_TIMESTAMP()::STRING || RECIPIENT_EMAIL))::STRING;
    
    -- Log the email (in production, this would call SYSTEM$SEND_EMAIL or external email service)
    INSERT INTO SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.EMAIL_LOG (
        EMAIL_ID,
        RECIPIENT_EMAIL,
        SUBJECT,
        BODY,
        SENT_TIMESTAMP,
        STATUS
    )
    VALUES (
        :v_email_id,
        :RECIPIENT_EMAIL,
        :SUBJECT,
        :BODY,
        CURRENT_TIMESTAMP(),
        'SENT'
    );
    
    LET v_result STRING := 'Email sent successfully. ID: ' || :v_email_id || ' to ' || RECIPIENT_EMAIL;
    
    -- In production environment, uncomment and configure:
    -- CALL SYSTEM$SEND_EMAIL(
    --     'your_notification_integration_name',
    --     RECIPIENT_EMAIL,
    --     SUBJECT,
    --     BODY
    -- );
    
    RETURN :v_result;
END;
$$;

-- Create stored procedures for demo automation
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GENERATE_POLICY_BRIEF(
    POLICY_NAME STRING,
    RECIPIENT_EMAIL STRING DEFAULT 'jonathan.asvestis@snowflake.com'
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    -- Create email content using LET statements
    LET v_email_subject STRING := 'Policy Brief: ' || POLICY_NAME;
    LET v_email_body STRING := 'Dear Policy Analyst,\n\n' ||
                  'A new policy brief has been generated for: ' || POLICY_NAME || '\n\n' ||
                  'Generated at: ' || CURRENT_TIMESTAMP()::STRING || '\n\n' ||
                  'Please review the latest policy impact metrics in the dashboard.\n\n' ||
                  'Best regards,\n' ||
                  'Singapore Smart Nation Intelligence System';
    
    -- Send email
    LET v_email_result STRING;
    CALL SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_EMAIL(
        :RECIPIENT_EMAIL,
        :v_email_subject,
        :v_email_body
    ) INTO :v_email_result;
    
    -- Create result message
    LET v_result_message STRING := 'Policy Brief Generated for: ' || POLICY_NAME || 
                     ' - ' || :v_email_result;

    -- Insert with a timestamp-based ID
    INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE (
        METRIC_ID,
        SERVICE_NAME,
        AGENCY,
        METRIC_TYPE,
        METRIC_VALUE,
        MEASUREMENT_DATE,
        BENCHMARK_VALUE,
        PERFORMANCE_STATUS,
        CREATED_AT
    )
    VALUES (
        'BRIEF_' || EXTRACT(EPOCH FROM CURRENT_TIMESTAMP())::STRING,
        'Policy Briefing Service',
        'Prime Ministers Office',
        'Briefings Generated',
        1,
        CURRENT_DATE(),
        5,
        'Active',
        CURRENT_TIMESTAMP()
    );

    RETURN :v_result_message;
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
    LET alert_id STRING := (ABS(HASH(ALERT_MESSAGE || CURRENT_TIMESTAMP()::STRING)) % 9000000 + 1000000)::STRING;

    INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE (
        METRIC_ID,
        SERVICE_NAME,
        AGENCY,
        METRIC_TYPE,
        METRIC_VALUE,
        MEASUREMENT_DATE,
        BENCHMARK_VALUE,
        PERFORMANCE_STATUS,
        CREATED_AT
    )
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
    LET optimization_id STRING := (ABS(HASH(SERVICE_TYPE || CURRENT_TIMESTAMP()::STRING)) % 9000000 + 1000000)::STRING;

    LET recommendation STRING := 'Resource optimization completed for ' || SERVICE_TYPE ||
                                ' for period: ' || TIME_PERIOD ||
                                '. Recommendation ID: ' || optimization_id;

    INSERT INTO SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE (
        METRIC_ID,
        SERVICE_NAME,
        AGENCY,
        METRIC_TYPE,
        METRIC_VALUE,
        MEASUREMENT_DATE,
        BENCHMARK_VALUE,
        PERFORMANCE_STATUS,
        CREATED_AT
    )
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

-- ============================================================================
-- SECTION 6B: ADVANCED INTELLIGENCE CAPABILITIES
-- ============================================================================

-- Create external access integration for web scraping
-- Note: Requires ACCOUNTADMIN role
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE NETWORK RULE SNOWFLAKE_PUBSEC_DEMO_WEB_ACCESS
    MODE = EGRESS
    TYPE = HOST_PORT
    VALUE_LIST = ('0.0.0.0:443', '0.0.0.0:80');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION SNOWFLAKE_PUBSEC_DEMO_WEB_INTEGRATION
    ALLOWED_NETWORK_RULES = (SNOWFLAKE_PUBSEC_DEMO_WEB_ACCESS)
    ENABLED = TRUE
    COMMENT = 'External access for web scraping government websites and policy documents';

GRANT USAGE ON INTEGRATION SNOWFLAKE_PUBSEC_DEMO_WEB_INTEGRATION TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Create stage for semantic model files (needed for presigned URL function)
CREATE STAGE IF NOT EXISTS SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE
    COMMENT = 'Stage for Cortex Analyst semantic model YAML files and shared documents';

GRANT READ ON STAGE SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT WRITE ON STAGE SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SNOWFLAKE_PUBSEC_DEMO;
USE SCHEMA INTELLIGENCE;

-- Create web scraping function
CREATE OR REPLACE FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.WEB_SCRAPE(url STRING)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
HANDLER = 'scrape_url'
EXTERNAL_ACCESS_INTEGRATIONS = (SNOWFLAKE_PUBSEC_DEMO_WEB_INTEGRATION)
PACKAGES = ('requests', 'beautifulsoup4', 'lxml')
AS
$$
import requests
from bs4 import BeautifulSoup
import _snowflake

def scrape_url(url):
    try:
        # Set headers to mimic browser request
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }
        
        # Make HTTP request
        response = requests.get(url, headers=headers, timeout=10)
        response.raise_for_status()
        
        # Parse HTML content
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Extract text content
        text_content = soup.get_text(separator=' ', strip=True)
        
        # Extract title
        title = soup.title.string if soup.title else 'No title'
        
        # Extract meta description
        meta_desc = soup.find('meta', attrs={'name': 'description'})
        description = meta_desc['content'] if meta_desc else ''
        
        # Extract all links
        links = [a.get('href') for a in soup.find_all('a', href=True)]
        
        # Log to database
        insert_query = f"""
            INSERT INTO SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.WEB_SCRAPE_LOG 
            (SCRAPE_ID, URL, SCRAPED_CONTENT, CONTENT_TYPE, STATUS)
            VALUES (
                'SCRAPE_' || ABS(HASH('{url}' || CURRENT_TIMESTAMP()::STRING))::STRING,
                '{url}',
                '{text_content[:10000]}',
                'text/html',
                'SUCCESS'
            )
        """
        
        return {
            'status': 'success',
            'url': url,
            'title': title,
            'description': description,
            'content': text_content[:5000],  # Limit content size
            'link_count': len(links),
            'links': links[:20]  # First 20 links only
        }
        
    except Exception as e:
        return {
            'status': 'error',
            'url': url,
            'error': str(e)
        }
$$;

-- Create presigned URL function for secure file sharing
-- Note: Using Python wrapper because GET_PRESIGNED_URL requires constant expiry time
CREATE OR REPLACE FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GET_FILE_PRESIGNED_URL(
    file_path STRING,
    expiry_hours NUMBER
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
HANDLER = 'get_url'
AS
$$
def get_url(file_path, expiry_hours):
    import _snowflake
    
    # Calculate expiry in seconds
    expiry_seconds = int(expiry_hours * 3600)
    
    # Call the system function with calculated value
    query = f"""
        SELECT GET_PRESIGNED_URL(
            @SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE,
            '{file_path}',
            {expiry_seconds}
        )
    """
    
    session = _snowflake.get_active_session()
    result = session.sql(query).collect()
    
    if result and len(result) > 0:
        return result[0][0]
    else:
        return None
$$;

-- Create procedure to analyze policy websites
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ANALYZE_POLICY_WEBSITE(
    WEBSITE_URL STRING
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET v_scrape_result VARIANT;
    LET v_analysis_summary STRING;
    
    -- Scrape the website
    v_scrape_result := (SELECT SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.WEB_SCRAPE(:WEBSITE_URL));
    
    -- Create analysis summary
    v_analysis_summary := 'Policy Website Analysis:\n' ||
                         'URL: ' || :WEBSITE_URL || '\n' ||
                         'Title: ' || v_scrape_result:title::STRING || '\n' ||
                         'Status: ' || v_scrape_result:status::STRING || '\n' ||
                         'Content Preview: ' || SUBSTR(v_scrape_result:content::STRING, 1, 500);
    
    RETURN :v_analysis_summary;
END;
$$;

-- Create procedure to share policy documents securely
CREATE OR REPLACE PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SHARE_DOCUMENT(
    DOCUMENT_NAME STRING,
    RECIPIENT_EMAIL STRING,
    EXPIRY_HOURS NUMBER DEFAULT 48
)
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    LET v_presigned_url STRING;
    LET v_email_subject STRING;
    LET v_email_body STRING;
    LET v_email_result STRING;
    
    -- Generate presigned URL
    v_presigned_url := (
        SELECT SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GET_FILE_PRESIGNED_URL(
            :DOCUMENT_NAME,
            :EXPIRY_HOURS
        )
    );
    
    -- Prepare email
    v_email_subject := 'Secure Document Access: ' || :DOCUMENT_NAME;
    v_email_body := 'Dear Colleague,\n\n' ||
                    'You have been granted secure access to the following document:\n\n' ||
                    'Document: ' || :DOCUMENT_NAME || '\n' ||
                    'Access Link: ' || :v_presigned_url || '\n\n' ||
                    'This link will expire in ' || :EXPIRY_HOURS || ' hours.\n\n' ||
                    'Best regards,\n' ||
                    'Singapore Smart Nation Intelligence System';
    
    -- Send email with secure link
    CALL SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_EMAIL(
        :RECIPIENT_EMAIL,
        :v_email_subject,
        :v_email_body
    ) INTO :v_email_result;
    
    RETURN 'Document shared successfully. ' || :v_email_result;
END;
$$;

-- Grant execute permissions on procedures
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_EMAIL(STRING, STRING, TEXT) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GENERATE_POLICY_BRIEF(STRING, STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SEND_SERVICE_ALERT(STRING, STRING, STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.OPTIMIZE_RESOURCES(STRING, STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ANALYZE_POLICY_WEBSITE(STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON PROCEDURE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SHARE_DOCUMENT(STRING, STRING, NUMBER) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Grant usage on functions
GRANT USAGE ON FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.WEB_SCRAPE(STRING) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT USAGE ON FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GET_FILE_PRESIGNED_URL(STRING, NUMBER) TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

SELECT 'Phase 6b: Advanced intelligence capabilities created (web scraping & file sharing)' as SETUP_PHASE;

-- Create analytics views

-- Core analytical view for Cortex Analyst semantic model
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.CITIZEN_SERVICE_ANALYTICS AS
SELECT
    -- Citizen demographics
    cp.AGE_GROUP,
    cp.POSTAL_DISTRICT,
    cp.PREFERRED_LANGUAGE,
    cp.DIGITAL_LITERACY_SCORE,
    
    -- Service details
    si.SERVICE_TYPE,
    si.AGENCY,
    si.INTERACTION_CHANNEL,
    si.INTERACTION_TIMESTAMP,
    TO_DATE(si.INTERACTION_TIMESTAMP) as INTERACTION_DATE,
    EXTRACT(MONTH FROM si.INTERACTION_TIMESTAMP) as INTERACTION_MONTH,
    DAYOFWEEK(si.INTERACTION_TIMESTAMP) as DAY_OF_WEEK,
    EXTRACT(HOUR FROM si.INTERACTION_TIMESTAMP) as HOUR_OF_DAY,
    
    -- Performance metrics
    si.DURATION_MINUTES,
    si.SATISFACTION_RATING as INTERACTION_SATISFACTION,
    si.SUCCESS_FLAG,
    
    -- Categorized metrics for easier analysis
    CASE 
        WHEN si.DURATION_MINUTES < 5 THEN 'Fast'
        WHEN si.DURATION_MINUTES < 15 THEN 'Moderate'
        WHEN si.DURATION_MINUTES < 30 THEN 'Slow'
        ELSE 'Very Slow'
    END as RESPONSE_TIME_CATEGORY,
    
    CASE 
        WHEN si.SATISFACTION_RATING >= 4 THEN 'High'
        WHEN si.SATISFACTION_RATING >= 3 THEN 'Medium'
        ELSE 'Low'
    END as SATISFACTION_CATEGORY,
    
    -- Aggregation-friendly columns
    1 as INTERACTION_COUNT,
    CASE WHEN si.SUCCESS_FLAG = TRUE THEN 1 ELSE 0 END as SUCCESS_COUNT,
    CASE WHEN si.SUCCESS_FLAG = FALSE THEN 1 ELSE 0 END as FAILURE_COUNT

FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS si
INNER JOIN SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES cp 
    ON si.CITIZEN_ID = cp.CITIZEN_ID;

-- Policy Performance Analytics view for Cortex Analyst semantic model
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_PERFORMANCE_ANALYTICS AS
SELECT
    POLICY_ID,
    POLICY_NAME,
    TARGET_DEMOGRAPHIC,
    STATUS as POLICY_STATUS,
    IMPLEMENTATION_DATE,
    EXTRACT(YEAR FROM IMPLEMENTATION_DATE) as IMPLEMENTATION_YEAR,
    EXTRACT(MONTH FROM IMPLEMENTATION_DATE) as IMPLEMENTATION_MONTH,
    
    -- Metrics
    BASELINE_METRIC,
    CURRENT_METRIC,
    IMPACT_PERCENTAGE,
    (CURRENT_METRIC - BASELINE_METRIC) as ABSOLUTE_IMPROVEMENT,
    
    -- Calculate ROI as impact relative to baseline
    ROUND((CURRENT_METRIC - BASELINE_METRIC) * 100.0 / BASELINE_METRIC, 2) as ROI_PERCENTAGE,
    
    -- Days since implementation
    DATEDIFF(day, IMPLEMENTATION_DATE, CURRENT_DATE()) as DAYS_SINCE_IMPLEMENTATION,
    
    -- Success category based on impact percentage
    CASE 
        WHEN IMPACT_PERCENTAGE >= 60 THEN 'Highly Successful'
        WHEN IMPACT_PERCENTAGE >= 40 THEN 'Successful'
        WHEN IMPACT_PERCENTAGE >= 20 THEN 'Moderately Successful'
        ELSE 'Needs Improvement'
    END as SUCCESS_CATEGORY,
    
    LAST_UPDATED

FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT;

-- Service Performance Analytics view for Cortex Analyst semantic model
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE_ANALYTICS AS
SELECT
    METRIC_ID,
    SERVICE_NAME,
    AGENCY,
    
    -- Categorize services
    CASE 
        WHEN SERVICE_NAME ILIKE '%SingPass%' OR SERVICE_NAME ILIKE '%MyInfo%' THEN 'Identity Services'
        WHEN SERVICE_NAME ILIKE '%Health%' OR SERVICE_NAME ILIKE '%Medical%' OR AGENCY = 'MOH' THEN 'Healthcare Services'
        WHEN SERVICE_NAME ILIKE '%Tax%' OR SERVICE_NAME ILIKE '%IRAS%' OR AGENCY = 'IRAS' THEN 'Tax Services'
        WHEN SERVICE_NAME ILIKE '%HDB%' OR SERVICE_NAME ILIKE '%Housing%' THEN 'Housing Services'
        WHEN SERVICE_NAME ILIKE '%School%' OR SERVICE_NAME ILIKE '%Education%' OR AGENCY = 'MOE' THEN 'Education Services'
        WHEN SERVICE_NAME ILIKE '%LTA%' OR SERVICE_NAME ILIKE '%Transport%' OR SERVICE_NAME ILIKE '%Road%' THEN 'Transport Services'
        WHEN SERVICE_NAME ILIKE '%Social%' OR SERVICE_NAME ILIKE '%MSF%' THEN 'Social Services'
        WHEN SERVICE_NAME ILIKE '%Business%' OR SERVICE_NAME ILIKE '%ACRA%' OR SERVICE_NAME ILIKE '%Work Pass%' THEN 'Business Services'
        ELSE 'Other Services'
    END as SERVICE_CATEGORY,
    
    METRIC_TYPE,
    METRIC_VALUE,
    BENCHMARK_VALUE,
    PERFORMANCE_STATUS,
    MEASUREMENT_DATE,
    EXTRACT(YEAR FROM MEASUREMENT_DATE) as MEASUREMENT_YEAR,
    EXTRACT(MONTH FROM MEASUREMENT_DATE) as MEASUREMENT_MONTH,
    EXTRACT(WEEK FROM MEASUREMENT_DATE) as MEASUREMENT_WEEK,
    DAYOFWEEK(MEASUREMENT_DATE) as DAY_OF_WEEK,
    
    -- Performance vs benchmark percentage
    ROUND(((METRIC_VALUE - BENCHMARK_VALUE) / BENCHMARK_VALUE) * 100, 2) as PERFORMANCE_VS_BENCHMARK_PCT,
    
    -- Flag for meeting benchmark
    CASE WHEN PERFORMANCE_STATUS IN ('Meeting', 'Exceeding') THEN 1 ELSE 0 END as MEETS_BENCHMARK_FLAG,
    
    CREATED_AT

FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE;

CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.CITIZEN_SATISFACTION_SUMMARY AS
SELECT
    cp.AGE_GROUP,
    cp.POSTAL_DISTRICT,
    ROUND(AVG(cp.SATISFACTION_SCORE), 2) as AVG_SATISFACTION,
    COUNT(*) as CITIZEN_COUNT,
    ROUND(AVG(cp.DIGITAL_LITERACY_SCORE), 2) as AVG_DIGITAL_LITERACY
FROM SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES cp
GROUP BY cp.AGE_GROUP, cp.POSTAL_DISTRICT;

CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE_DASHBOARD AS
SELECT
    sp.AGENCY,
    sp.SERVICE_NAME,
    sp.METRIC_TYPE,
    ROUND(AVG(sp.METRIC_VALUE), 2) as AVG_PERFORMANCE,
    ROUND(AVG(sp.BENCHMARK_VALUE), 2) as BENCHMARK,
    COUNT(CASE WHEN sp.PERFORMANCE_STATUS = 'Exceeding' THEN 1 END) as EXCEEDING_COUNT,
    COUNT(*) as TOTAL_METRICS
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE sp
WHERE sp.MEASUREMENT_DATE >= DATEADD(day, -30, CURRENT_DATE())
GROUP BY sp.AGENCY, sp.SERVICE_NAME, sp.METRIC_TYPE;

-- Create weather-service correlation views
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_SERVICE_CORRELATION_SIMPLE AS
SELECT 
    CONVERT_TIMEZONE('UTC', 'Asia/Singapore', DATE(si.INTERACTION_TIMESTAMP)) as SERVICE_DATE,
    wd.WEATHER_CONDITION,
    ROUND(wd.RAINFALL_MM, 2) as RAINFALL_MM,
    wd.ALERT_LEVEL,
    si.SERVICE_TYPE,
    si.INTERACTION_CHANNEL,
    COUNT(*) as INTERACTION_COUNT,
    ROUND(AVG(si.DURATION_MINUTES), 2) as AVG_DURATION,
    ROUND(AVG(si.SATISFACTION_RATING), 2) as AVG_SATISFACTION
FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS si
JOIN SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA wd 
    ON DATE(si.INTERACTION_TIMESTAMP) = DATE(wd.DATE_TIME)
    AND wd.LOCATION = 'Marina Barrage'
GROUP BY 1,2,3,4,5,6;

-- Create comprehensive weather-service correlation view (required by semantic model)
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_SERVICE_CORRELATION AS
WITH HOURLY_WEATHER AS (
    SELECT 
        CONVERT_TIMEZONE('UTC', 'Asia/Singapore', DATE_TRUNC('hour', DATE_TIME)) as HOUR_TIMESTAMP,
        CASE 
            WHEN LOCATION IN ('Changi', 'Paya Lebar') THEN 'East'
            WHEN LOCATION IN ('Jurong West') THEN 'West'
            WHEN LOCATION IN ('Woodlands') THEN 'North'
            WHEN LOCATION IN ('Marina Barrage') THEN 'Central'
            ELSE 'Central'
        END as REGION,
        ROUND(AVG(TEMPERATURE_C), 2) as AVG_TEMP_C,
        ROUND(AVG(HUMIDITY_PCT), 2) as AVG_HUMIDITY,
        ROUND(SUM(RAINFALL_MM), 2) as TOTAL_RAINFALL,
        MAX(CASE WHEN ALERT_LEVEL != 'Normal' THEN 1 ELSE 0 END) as WEATHER_ALERT_FLAG,
        MODE(WEATHER_CONDITION) as DOMINANT_WEATHER
    FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA
    GROUP BY 1, 2
),
HOURLY_SERVICES AS (
    SELECT 
        CONVERT_TIMEZONE('UTC', 'Asia/Singapore', DATE_TRUNC('hour', si.INTERACTION_TIMESTAMP)) as HOUR_TIMESTAMP,
        CASE 
            WHEN cp.POSTAL_DISTRICT IN ('District 16-20') THEN 'East'
            WHEN cp.POSTAL_DISTRICT IN ('District 21-28') THEN 'West'  
            WHEN cp.POSTAL_DISTRICT IN ('District 11-15') THEN 'North'
            WHEN cp.POSTAL_DISTRICT IN ('District 01-05', 'District 06-10') THEN 'Central'
            ELSE 'Central'
        END as REGION,
        si.SERVICE_TYPE,
        si.AGENCY,
        si.INTERACTION_CHANNEL,
        COUNT(*) as INTERACTION_COUNT,
        ROUND(AVG(si.DURATION_MINUTES), 2) as AVG_DURATION,
        SUM(CASE WHEN si.SUCCESS_FLAG THEN 1 ELSE 0 END) as SUCCESS_COUNT,
        ROUND(AVG(si.SATISFACTION_RATING), 2) as AVG_SATISFACTION,
        COUNT(CASE WHEN si.INTERACTION_CHANNEL = 'Mobile App' THEN 1 END) as MOBILE_COUNT,
        COUNT(CASE WHEN si.INTERACTION_CHANNEL = 'Service Center' THEN 1 END) as IN_PERSON_COUNT
    FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS si
    JOIN SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES cp ON si.CITIZEN_ID = cp.CITIZEN_ID
    WHERE si.INTERACTION_TIMESTAMP >= DATEADD(day, -90, CURRENT_TIMESTAMP())
    GROUP BY 1, 2, 3, 4, 5
)
SELECT 
    hw.HOUR_TIMESTAMP,
    hw.REGION,
    hw.AVG_TEMP_C,
    hw.AVG_HUMIDITY,
    hw.TOTAL_RAINFALL,
    hw.WEATHER_ALERT_FLAG,
    hw.DOMINANT_WEATHER,
    hs.SERVICE_TYPE,
    hs.AGENCY,
    hs.INTERACTION_CHANNEL,
    hs.INTERACTION_COUNT,
    hs.AVG_DURATION,
    hs.SUCCESS_COUNT,
    hs.AVG_SATISFACTION,
    hs.MOBILE_COUNT,
    hs.IN_PERSON_COUNT,
    CASE 
        WHEN hw.TOTAL_RAINFALL > 10 THEN 'Heavy Rain Impact'
        WHEN hw.TOTAL_RAINFALL > 2 THEN 'Light Rain Impact'
        WHEN hw.AVG_TEMP_C > 32 THEN 'High Temperature Impact'
        WHEN hw.WEATHER_ALERT_FLAG = 1 THEN 'Weather Alert Impact'
        ELSE 'Normal Weather'
    END as WEATHER_IMPACT_CATEGORY,
    CASE 
        WHEN hs.MOBILE_COUNT > 0 AND hs.INTERACTION_COUNT > 0 THEN 
            ROUND((hs.MOBILE_COUNT * 100.0) / hs.INTERACTION_COUNT, 2)
        ELSE 0 
    END as MOBILE_ADOPTION_PCT,
    CASE 
        WHEN hw.TOTAL_RAINFALL > 5 AND hs.SUCCESS_COUNT > 0 AND hs.INTERACTION_COUNT > 0 THEN
            ROUND((hs.SUCCESS_COUNT * 100.0) / hs.INTERACTION_COUNT, 2)
        ELSE NULL
    END as WEATHER_RESILIENCE_SCORE
FROM HOURLY_WEATHER hw
LEFT JOIN HOURLY_SERVICES hs 
    ON hw.HOUR_TIMESTAMP = hs.HOUR_TIMESTAMP 
    AND hw.REGION = hs.REGION
WHERE hs.INTERACTION_COUNT IS NOT NULL;

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

-- Note: Stage and file format already created in Section 6B (before advanced functions)
-- This ensures the stage exists when GET_FILE_PRESIGNED_URL function is created

-- Grant necessary privileges for Cortex Analyst (if not already granted)
GRANT USAGE ON SCHEMA SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

SELECT 'Phase 8: Semantic model infrastructure ready (stage created in Section 6B)' as SETUP_PHASE;

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
    '========== FINAL DEMO STATISTICS ==========' as METRIC,
    '' as VALUE
UNION ALL
SELECT * FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS
ORDER BY METRIC;

-- ============================================================================
-- SETUP COMPLETE - SINGAPORE SMART NATION INTELLIGENCE DEMO READY
-- ============================================================================

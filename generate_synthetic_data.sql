-- Generate Synthetic Data for Singapore Public Sector Demo
-- Privacy-compliant synthetic citizen data for demonstration purposes
-- All data is artificially generated and does not represent real citizens

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SG_PUBSEC_DEMO;
USE WAREHOUSE SG_DEMO_WH;

-- Generate synthetic citizen profiles (10,000 records)
INSERT INTO SG_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES (
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
        'SG' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as CITIZEN_ID,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 15 THEN '18-25'
            WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN '26-35'
            WHEN UNIFORM(1, 100, RANDOM()) <= 55 THEN '36-50'
            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN '51-65'
            ELSE '65+'
        END as AGE_GROUP,
        CASE 
            WHEN UNIFORM(1, 28, RANDOM()) <= 5 THEN 'District 01-05'  -- CBD/Marina
            WHEN UNIFORM(1, 28, RANDOM()) <= 10 THEN 'District 06-10' -- Orchard/River Valley
            WHEN UNIFORM(1, 28, RANDOM()) <= 15 THEN 'District 11-15' -- Newton/Novena
            WHEN UNIFORM(1, 28, RANDOM()) <= 20 THEN 'District 16-20' -- Upper East Coast
            ELSE 'District 21-28' -- Heartlands
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

-- Generate synthetic service interactions (50,000 records)
INSERT INTO SG_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS (
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
        'INT' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as INTERACTION_ID,
        'SG' || LPAD(UNIFORM(1, 10000, RANDOM()), 8, '0') as CITIZEN_ID,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 25 THEN 'SingPass Authentication'
            WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Healthcare Appointment'
            WHEN UNIFORM(1, 100, RANDOM()) <= 55 THEN 'Tax Filing'
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Housing Application'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Education Services'
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'Transport Services'
            ELSE 'Social Services'
        END as SERVICE_TYPE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'GovTech'
            WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 'MOH'
            WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'IRAS'
            WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'HDB'
            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 'MOE'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'LTA'
            ELSE 'MSF'
        END as AGENCY,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Mobile App'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Web Portal'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Service Center'
            ELSE 'Phone'
        END as INTERACTION_CHANNEL,
        UNIFORM(1, 120, RANDOM()) as DURATION_MINUTES,
        CASE WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN TRUE ELSE FALSE END as SUCCESS_FLAG,
        UNIFORM(1, 5, RANDOM()) as SATISFACTION_RATING,
        DATEADD(minute, -UNIFORM(1, 525600, RANDOM()), CURRENT_TIMESTAMP()) as INTERACTION_TIMESTAMP
    FROM TABLE(GENERATOR(ROWCOUNT => 50000))
)
SELECT * FROM SYNTHETIC_INTERACTIONS;

-- Generate service performance metrics
INSERT INTO SG_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE (
    METRIC_ID,
    SERVICE_NAME,
    AGENCY,
    METRIC_TYPE,
    METRIC_VALUE,
    MEASUREMENT_DATE,
    BENCHMARK_VALUE,
    PERFORMANCE_STATUS
)
WITH SYNTHETIC_METRICS AS (
    SELECT 
        'MET' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as METRIC_ID,
        service_name,
        agency,
        metric_type,
        CASE 
            WHEN metric_type = 'Response Time (minutes)' THEN UNIFORM(1, 30, RANDOM())
            WHEN metric_type = 'Success Rate (%)' THEN UNIFORM(75, 99, RANDOM())
            WHEN metric_type = 'User Satisfaction' THEN UNIFORM(3.0, 5.0, RANDOM())
            WHEN metric_type = 'Daily Transactions' THEN UNIFORM(100, 10000, RANDOM())
            ELSE UNIFORM(1, 100, RANDOM())
        END as METRIC_VALUE,
        DATEADD(day, -UNIFORM(1, 90, RANDOM()), CURRENT_DATE()) as MEASUREMENT_DATE,
        CASE 
            WHEN metric_type = 'Response Time (minutes)' THEN 15
            WHEN metric_type = 'Success Rate (%)' THEN 95
            WHEN metric_type = 'User Satisfaction' THEN 4.0
            WHEN metric_type = 'Daily Transactions' THEN 5000
            ELSE 80
        END as BENCHMARK_VALUE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Meeting'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Exceeding'
            ELSE 'Below'
        END as PERFORMANCE_STATUS
    FROM (
        SELECT 
            service_name,
            agency,
            metric_type
        FROM (
            VALUES 
                ('SingPass Digital ID', 'GovTech', 'Response Time (minutes)'),
                ('SingPass Digital ID', 'GovTech', 'Success Rate (%)'),
                ('SingPass Digital ID', 'GovTech', 'User Satisfaction'),
                ('HealthHub Portal', 'MOH', 'Response Time (minutes)'),
                ('HealthHub Portal', 'MOH', 'Success Rate (%)'),
                ('HealthHub Portal', 'MOH', 'Daily Transactions'),
                ('myTax Portal', 'IRAS', 'Response Time (minutes)'),
                ('myTax Portal', 'IRAS', 'Success Rate (%)'),
                ('myTax Portal', 'IRAS', 'User Satisfaction'),
                ('HDB InfoWEB', 'HDB', 'Response Time (minutes)'),
                ('HDB InfoWEB', 'HDB', 'Success Rate (%)'),
                ('HDB InfoWEB', 'HDB', 'Daily Transactions'),
                ('SchoolFinder', 'MOE', 'Response Time (minutes)'),
                ('SchoolFinder', 'MOE', 'User Satisfaction'),
                ('OneMotoring', 'LTA', 'Response Time (minutes)'),
                ('OneMotoring', 'LTA', 'Success Rate (%)'),
                ('ComCare Portal', 'MSF', 'Response Time (minutes)'),
                ('ComCare Portal', 'MSF', 'User Satisfaction')
        ) as services(service_name, agency, metric_type)
    ) services_metrics
    CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 30)) -- 30 days of metrics per service/metric combination
)
SELECT * FROM SYNTHETIC_METRICS;

-- Generate policy impact data
INSERT INTO SG_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT
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
INSERT INTO SG_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS (
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
WITH SYNTHETIC_WORKFLOWS AS (
    SELECT 
        'WF' || LPAD(ROW_NUMBER() OVER (ORDER BY SEQ4()), 8, '0') as WORKFLOW_ID,
        'REQ' || LPAD(UNIFORM(1, 10000, RANDOM()), 8, '0') as CITIZEN_REQUEST_ID,
        source_agency,
        target_agency,
        workflow_type,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'Completed'
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN 'In Progress'
            ELSE 'Pending'
        END as STATUS,
        UNIFORM(1, 72, RANDOM()) + (UNIFORM(1, 60, RANDOM()) / 60.0) as PROCESSING_TIME_HOURS,
        DATEADD(hour, -UNIFORM(1, 720, RANDOM()), CURRENT_TIMESTAMP()) as HANDOFF_TIMESTAMP,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 
                DATEADD(hour, UNIFORM(1, 48, RANDOM()), DATEADD(hour, -UNIFORM(1, 720, RANDOM()), CURRENT_TIMESTAMP()))
            ELSE NULL
        END as COMPLETION_TIMESTAMP
    FROM (
        VALUES 
            ('MOH', 'HDB', 'Healthcare-Housing Integration'),
            ('IRAS', 'HDB', 'Tax-Housing Verification'),
            ('MOE', 'HDB', 'School-Housing Coordination'),
            ('MSF', 'MOH', 'Social-Healthcare Services'),
            ('MSF', 'HDB', 'Social Housing Support'),
            ('GovTech', 'MOH', 'Digital Health Services'),
            ('GovTech', 'IRAS', 'Digital Tax Services'),
            ('GovTech', 'HDB', 'Digital Housing Services'),
            ('LTA', 'HDB', 'Transport-Housing Planning'),
            ('MOH', 'MOE', 'Health-Education Programs')
    ) as workflows(source_agency, target_agency, workflow_type)
    CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 500)) -- 500 workflows per type
)
SELECT * FROM SYNTHETIC_WORKFLOWS;

-- Create additional sample data for current events and trends
CREATE OR REPLACE TABLE SG_PUBSEC_DEMO.ANALYTICS.CURRENT_EVENTS_IMPACT (
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

INSERT INTO SG_PUBSEC_DEMO.ANALYTICS.CURRENT_EVENTS_IMPACT
VALUES 
    ('EVT001', 'Monsoon Season Service Adjustments', '2024-09-15', 
     ['Transport Services', 'Emergency Services', 'Healthcare'], 
     3.2, 45.6, 
     ['Extended Service Hours', 'Mobile Response Units', 'Proactive Alerts'], 
     'Active'),
    ('EVT002', 'Digital Services Upgrade Weekend', '2024-09-20', 
     ['SingPass', 'Government Portals', 'Mobile Apps'], 
     2.1, 23.4, 
     ['Advance Notifications', 'Alternative Channels', 'Extended Support'], 
     'Completed'),
    ('EVT003', 'Public Holiday Service Planning', '2024-09-30', 
     ['All Government Services'], 
     1.8, 15.2, 
     ['Adjusted Operating Hours', 'Emergency Contact Info', 'Self-Service Options'], 
     'Planned');

-- Create summary statistics for demo
CREATE OR REPLACE VIEW SG_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS AS
SELECT 
    'Total Citizens in System' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SG_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES
UNION ALL
SELECT 
    'Total Service Interactions (Last 30 Days)' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SG_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS
WHERE INTERACTION_TIMESTAMP >= DATEADD(day, -30, CURRENT_TIMESTAMP())
UNION ALL
SELECT 
    'Average Citizen Satisfaction Score' as METRIC,
    ROUND(AVG(SATISFACTION_SCORE), 2)::STRING as VALUE
FROM SG_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES
UNION ALL
SELECT 
    'Services Meeting Performance Benchmarks' as METRIC,
    ROUND((COUNT(CASE WHEN PERFORMANCE_STATUS IN ('Meeting', 'Exceeding') THEN 1 END) * 100.0 / COUNT(*)), 1)::STRING || '%' as VALUE
FROM SG_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE
WHERE MEASUREMENT_DATE >= DATEADD(day, -7, CURRENT_DATE())
UNION ALL
SELECT 
    'Inter-Agency Workflows Completed (This Month)' as METRIC,
    COUNT(*)::STRING as VALUE
FROM SG_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS
WHERE STATUS = 'Completed' 
AND COMPLETION_TIMESTAMP >= DATE_TRUNC('month', CURRENT_DATE());

-- Verify data generation
SELECT 'Synthetic data generation completed successfully!' as STATUS,
       'Ready for Snowflake Intelligence Agent setup' as NEXT_STEP;

-- Show summary of generated data
SELECT 
    'Citizen Profiles' as TABLE_NAME,
    COUNT(*) as RECORD_COUNT
FROM SG_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES
UNION ALL
SELECT 
    'Service Interactions' as TABLE_NAME,
    COUNT(*) as RECORD_COUNT
FROM SG_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS
UNION ALL
SELECT 
    'Service Performance Metrics' as TABLE_NAME,
    COUNT(*) as RECORD_COUNT
FROM SG_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE
UNION ALL
SELECT 
    'Policy Impact Records' as TABLE_NAME,
    COUNT(*) as RECORD_COUNT
FROM SG_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT
UNION ALL
SELECT 
    'Inter-Agency Workflows' as TABLE_NAME,
    COUNT(*) as RECORD_COUNT
FROM SG_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS
ORDER BY TABLE_NAME;

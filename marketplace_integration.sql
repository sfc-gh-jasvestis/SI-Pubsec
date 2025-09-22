-- Snowflake Marketplace Data Integration
-- Singapore Public Sector Demo - External Data Sources

-- Snowflake Marketplace Data Integration
-- Singapore Public Sector Demo - External Data Sources
-- Enhanced error handling and context management

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SNOWFLAKE_PUBSEC_DEMO;
USE WAREHOUSE SNOWFLAKE_DEMO_WH;



-- Mock weather data structure (replace with actual marketplace data)
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

-- Generate realistic Singapore weather data based on historical climate patterns
-- Singapore has a tropical rainforest climate with consistent temperature and high humidity
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
            WHEN UNIFORM(1, 10, RANDOM()) <= 2 THEN 'Central Singapore'     -- 20% CBD/Central
            WHEN UNIFORM(1, 10, RANDOM()) <= 4 THEN 'East Singapore'        -- 20% East (Changi, Tampines)
            WHEN UNIFORM(1, 10, RANDOM()) <= 6 THEN 'West Singapore'        -- 20% West (Jurong, Tuas)
            WHEN UNIFORM(1, 10, RANDOM()) <= 8 THEN 'North Singapore'       -- 20% North (Woodlands, Yishun)
            ELSE 'South Singapore'                                           -- 20% South (Sentosa, Marina)
        END as LOCATION,
        
        -- Singapore temperature: typically 24-34°C with seasonal variations
        -- Slightly cooler during monsoon season (Nov-Mar), warmer during dry season
        CASE 
            WHEN EXTRACT(MONTH FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) IN (11, 12, 1, 2, 3) THEN
                -- Monsoon season: slightly cooler and more variable
                ROUND(UNIFORM(23.5, 32.0, RANDOM()) + 
                      -- Add daily temperature cycle (cooler at night, warmer in afternoon)
                      CASE 
                          WHEN EXTRACT(HOUR FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) BETWEEN 6 AND 18 THEN UNIFORM(0, 3, RANDOM())
                          ELSE UNIFORM(-2, 1, RANDOM())
                      END, 1)
            ELSE
                -- Dry season: warmer and more consistent
                ROUND(UNIFORM(25.0, 34.5, RANDOM()) + 
                      -- Daily temperature cycle
                      CASE 
                          WHEN EXTRACT(HOUR FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) BETWEEN 6 AND 18 THEN UNIFORM(0, 2.5, RANDOM())
                          ELSE UNIFORM(-1.5, 0.5, RANDOM())
                      END, 1)
        END as TEMPERATURE_C,
        
        -- Singapore humidity: consistently high (65-95%), higher during rain
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 30 THEN UNIFORM(85, 95, RANDOM())  -- 30% very high humidity
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN UNIFORM(75, 90, RANDOM())  -- 40% high humidity  
            ELSE UNIFORM(65, 85, RANDOM())                                        -- 30% moderate-high humidity
        END as HUMIDITY_PCT,
        
        -- Singapore rainfall: frequent but brief showers, heavier during monsoon
        CASE 
            WHEN EXTRACT(MONTH FROM DATEADD(hour, -ROW_NUMBER() OVER (ORDER BY SEQ4()), CURRENT_TIMESTAMP())) IN (11, 12, 1, 2, 3) THEN
                -- Monsoon season: more frequent and heavier rain
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 0                           -- 40% no rain
                    WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN UNIFORM(0.1, 5, RANDOM())  -- 20% light rain
                    WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN UNIFORM(5, 25, RANDOM())   -- 25% moderate rain
                    ELSE UNIFORM(25, 80, RANDOM())                                        -- 15% heavy rain
                END
            ELSE
                -- Dry season: less frequent but still regular afternoon showers
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 0                           -- 60% no rain
                    WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN UNIFORM(0.1, 3, RANDOM())  -- 20% light rain
                    WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN UNIFORM(3, 15, RANDOM())   -- 15% moderate rain
                    ELSE UNIFORM(15, 50, RANDOM())                                        -- 5% heavy rain
                END
        END as RAINFALL_MM,
        
        -- Weather conditions based on rainfall and time patterns
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Sunny'                    -- 40% sunny (tropical sun)
            WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'Partly Cloudy'           -- 25% partly cloudy
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Cloudy'                  -- 15% cloudy
            WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN 'Light Rain'              -- 12% light rain
            WHEN UNIFORM(1, 100, RANDOM()) <= 98 THEN 'Heavy Rain'              -- 6% heavy rain
            ELSE 'Thunderstorm'                                                  -- 2% thunderstorm
        END as WEATHER_CONDITION,
        
        -- Alert levels based on Singapore's weather warning system
        CASE 
            WHEN UNIFORM(1, 1000, RANDOM()) <= 900 THEN 'Normal'                -- 90% normal conditions
            WHEN UNIFORM(1, 1000, RANDOM()) <= 970 THEN 'Advisory'              -- 7% weather advisory
            WHEN UNIFORM(1, 1000, RANDOM()) <= 995 THEN 'Warning'               -- 2.5% weather warning
            ELSE 'Red Alert'                                                     -- 0.5% red alert (rare)
        END as ALERT_LEVEL
    FROM TABLE(GENERATOR(ROWCOUNT => 2160)) -- 90 days of hourly data (more comprehensive)
),

-- Add realistic temporal patterns for Singapore weather
ENHANCED_WEATHER AS (
    SELECT 
        DATE_TIME,
        LOCATION,
        TEMPERATURE_C,
        HUMIDITY_PCT,
        -- Adjust rainfall based on time of day (afternoon showers are common in Singapore)
        CASE 
            WHEN EXTRACT(HOUR FROM DATE_TIME) BETWEEN 14 AND 18 THEN 
                -- Afternoon shower pattern - increase rainfall probability
                CASE 
                    WHEN RAINFALL_MM = 0 AND UNIFORM(1, 100, RANDOM()) <= 25 THEN UNIFORM(0.1, 8, RANDOM())
                    WHEN RAINFALL_MM > 0 THEN RAINFALL_MM * UNIFORM(1.2, 2.0, RANDOM())
                    ELSE RAINFALL_MM
                END
            WHEN EXTRACT(HOUR FROM DATE_TIME) BETWEEN 2 AND 6 THEN
                -- Early morning - less rain, more stable conditions
                CASE 
                    WHEN RAINFALL_MM > 10 THEN RAINFALL_MM * UNIFORM(0.3, 0.7, RANDOM())
                    ELSE RAINFALL_MM
                END
            ELSE RAINFALL_MM
        END as RAINFALL_MM,
        
        -- Update weather condition based on adjusted rainfall
        CASE 
            WHEN RAINFALL_MM = 0 THEN 
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 'Sunny'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Partly Cloudy'
                    ELSE 'Cloudy'
                END
            WHEN RAINFALL_MM <= 2 THEN 'Light Rain'
            WHEN RAINFALL_MM <= 10 THEN 'Moderate Rain'
            WHEN RAINFALL_MM <= 30 THEN 'Heavy Rain'
            ELSE 'Thunderstorm'
        END as WEATHER_CONDITION,
        
        -- Update alert level based on rainfall intensity
        CASE 
            WHEN RAINFALL_MM <= 5 THEN 'Normal'
            WHEN RAINFALL_MM <= 15 THEN 'Advisory'
            WHEN RAINFALL_MM <= 40 THEN 'Warning'
            ELSE 'Red Alert'
        END as ALERT_LEVEL
    FROM SINGAPORE_WEATHER
)
SELECT * FROM ENHANCED_WEATHER;

-- 2. ECONOMIC INDICATORS INTEGRATION
-- Search for "Economic Data" or "Federal Reserve Economic Data" in Marketplace

CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS (
    INDICATOR_DATE DATE,
    INDICATOR_NAME STRING,
    VALUE NUMBER(10,2),
    UNIT STRING,
    CATEGORY STRING,
    SOURCE STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Sample economic data
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

-- 3. TRANSPORTATION DATA INTEGRATION
-- Search for "Transportation" or "Mobility Data" in Marketplace

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

-- Sample transport data
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
            ELSE 'LRT'
        END as TRANSPORT_MODE,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 20 THEN 'CBD'
            WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'Orchard'
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN 'Jurong'
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'Tampines'
            ELSE 'Woodlands'
        END as ROUTE_AREA,
        UNIFORM(50, 2000, RANDOM()) as PASSENGER_COUNT,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 0
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN UNIFORM(1, 5, RANDOM())
            ELSE UNIFORM(5, 30, RANDOM())
        END as DELAY_MINUTES,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Normal'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Minor Delay'
            ELSE 'Major Disruption'
        END as SERVICE_STATUS,
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 'None'
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 'Weather'
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN 'Technical'
            ELSE 'Incident'
        END as DISRUPTION_TYPE
    FROM TABLE(GENERATOR(ROWCOUNT => 5000))
)
SELECT * FROM TRANSPORT_SAMPLE;

-- 4. PUBLIC HEALTH TRENDS INTEGRATION
-- Search for "Health Data" or "CDC Data" in Marketplace

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

-- Sample health trends data
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

-- Create integrated views for cross-data analysis

-- Weather impact on service usage
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
    AND wd.LOCATION = 'Central Singapore'
GROUP BY 1,2,3,4,5,6;

-- Economic impact on policy effectiveness
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.ECONOMIC_POLICY_IMPACT AS
SELECT 
    pi.POLICY_NAME,
    pi.IMPLEMENTATION_DATE,
    ei.INDICATOR_NAME,
    ei.VALUE as ECONOMIC_VALUE,
    pi.IMPACT_PERCENTAGE as POLICY_IMPACT,
    CASE 
        WHEN ei.INDICATOR_NAME = 'Digital Economy Contribution' AND pi.POLICY_NAME LIKE '%Digital%' 
        THEN 'Strong Correlation'
        WHEN ei.INDICATOR_NAME = 'Unemployment Rate' AND pi.POLICY_NAME LIKE '%Social%'
        THEN 'Moderate Correlation'
        ELSE 'Low Correlation'
    END as CORRELATION_STRENGTH
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT pi
CROSS JOIN SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS ei
WHERE ei.INDICATOR_DATE >= pi.IMPLEMENTATION_DATE;

-- Transport disruption impact on service delivery
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.TRANSPORT_SERVICE_IMPACT AS
SELECT 
    DATE(td.TIMESTAMP) as DISRUPTION_DATE,
    td.ROUTE_AREA,
    td.SERVICE_STATUS,
    td.DISRUPTION_TYPE,
    COUNT(DISTINCT si.CITIZEN_ID) as AFFECTED_CITIZENS,
    AVG(si.DURATION_MINUTES) as AVG_SERVICE_DURATION,
    COUNT(CASE WHEN si.SUCCESS_FLAG = FALSE THEN 1 END) as FAILED_INTERACTIONS,
    AVG(si.SATISFACTION_RATING) as AVG_SATISFACTION
FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.TRANSPORT_DATA td
LEFT JOIN SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS si
    ON DATE(td.TIMESTAMP) = DATE(si.INTERACTION_TIMESTAMP)
    AND si.INTERACTION_CHANNEL IN ('Mobile App', 'Web Portal') -- Digital channels affected by transport
WHERE td.SERVICE_STATUS != 'Normal'
GROUP BY 1,2,3,4;

-- Health trends correlation with digital service adoption
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.HEALTH_DIGITAL_ADOPTION AS
SELECT 
    ht.REPORT_DATE,
    ht.HEALTH_INDICATOR,
    ht.DEMOGRAPHIC_GROUP,
    ht.VALUE as HEALTH_METRIC,
    ht.TREND_DIRECTION,
    COUNT(DISTINCT si.CITIZEN_ID) as DIGITAL_SERVICE_USERS,
    AVG(cp.DIGITAL_LITERACY_SCORE) as AVG_DIGITAL_LITERACY,
    AVG(cp.SATISFACTION_SCORE) as AVG_SATISFACTION
FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.HEALTH_TRENDS ht
LEFT JOIN SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS si
    ON si.SERVICE_TYPE = 'Healthcare Appointment'
    AND DATE(si.INTERACTION_TIMESTAMP) = ht.REPORT_DATE
LEFT JOIN SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES cp
    ON si.CITIZEN_ID = cp.CITIZEN_ID
WHERE ht.HEALTH_INDICATOR = 'Digital Health App Usage'
GROUP BY 1,2,3,4,5;

-- Create comprehensive dashboard view
CREATE OR REPLACE VIEW SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.INTEGRATED_DASHBOARD AS
SELECT 
    'Service Performance' as METRIC_CATEGORY,
    'Total Interactions Today' as METRIC_NAME,
    COUNT(*)::STRING as METRIC_VALUE,
    'Transactions' as UNIT
FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS
WHERE DATE(INTERACTION_TIMESTAMP) = CURRENT_DATE()

UNION ALL

SELECT 
    'Weather Impact' as METRIC_CATEGORY,
    'Current Weather Alert Level' as METRIC_NAME,
    MAX(ALERT_LEVEL) as METRIC_VALUE,
    'Alert Status' as UNIT
FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA
WHERE DATE(DATE_TIME) = CURRENT_DATE()

UNION ALL

SELECT 
    'Economic Context' as METRIC_CATEGORY,
    'Latest GDP Growth Rate' as METRIC_NAME,
    MAX(VALUE)::STRING || '%' as METRIC_VALUE,
    'Percentage' as UNIT
FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS
WHERE INDICATOR_NAME = 'GDP Growth Rate'

UNION ALL

SELECT 
    'Transport Status' as METRIC_CATEGORY,
    'Active Transport Disruptions' as METRIC_NAME,
    COUNT(*)::STRING as METRIC_VALUE,
    'Incidents' as UNIT
FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.TRANSPORT_DATA
WHERE SERVICE_STATUS != 'Normal'
AND DATE(TIMESTAMP) = CURRENT_DATE()

UNION ALL

SELECT 
    'Health Trends' as METRIC_CATEGORY,
    'Digital Health App Usage' as METRIC_NAME,
    MAX(VALUE)::STRING || '%' as METRIC_VALUE,
    'Adoption Rate' as UNIT
FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.HEALTH_TRENDS
WHERE HEALTH_INDICATOR = 'Digital Health App Usage'
AND REPORT_DATE = (SELECT MAX(REPORT_DATE) FROM SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.HEALTH_TRENDS);

-- Grant permissions for the integrated views
GRANT SELECT ON ALL VIEWS IN SCHEMA SNOWFLAKE_PUBSEC_DEMO.ANALYTICS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

SELECT 'Marketplace data integration completed successfully!' as STATUS,
       'External data sources are now available for Snowflake Intelligence queries' as NEXT_STEP;

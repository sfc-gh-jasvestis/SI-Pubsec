-- Singapore Weather Data Generator
-- Creates realistic synthetic weather data based on Singapore's tropical climate patterns
-- Based on historical weather patterns from NEA (National Environment Agency)

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SG_PUBSEC_DEMO;
USE WAREHOUSE SG_DEMO_WH;

-- Create comprehensive Singapore weather data table
CREATE OR REPLACE TABLE SG_PUBSEC_DEMO.EXTERNAL_DATA.SINGAPORE_WEATHER_DETAILED (
    TIMESTAMP TIMESTAMP,
    LOCATION STRING,
    REGION STRING,
    TEMPERATURE_C NUMBER(4,1),
    FEELS_LIKE_C NUMBER(4,1),
    HUMIDITY_PCT NUMBER(3,0),
    RAINFALL_MM NUMBER(6,2),
    WIND_SPEED_KMH NUMBER(4,1),
    WIND_DIRECTION STRING,
    PRESSURE_HPA NUMBER(6,1),
    UV_INDEX NUMBER(2,0),
    VISIBILITY_KM NUMBER(4,1),
    WEATHER_CONDITION STRING,
    WEATHER_DESCRIPTION STRING,
    ALERT_LEVEL STRING,
    AIR_QUALITY_INDEX NUMBER(3,0),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Generate comprehensive Singapore weather data
INSERT INTO SG_PUBSEC_DEMO.EXTERNAL_DATA.SINGAPORE_WEATHER_DETAILED
WITH SINGAPORE_LOCATIONS AS (
    -- Major weather monitoring stations in Singapore
    SELECT location, region FROM VALUES
        ('Changi', 'East'),
        ('Jurong West', 'West'), 
        ('Woodlands', 'North'),
        ('Marina Barrage', 'Central'),
        ('Sentosa', 'South'),
        ('Paya Lebar', 'East'),
        ('Choa Chu Kang', 'West'),
        ('Ang Mo Kio', 'North'),
        ('Orchard', 'Central'),
        ('Tanjong Pagar', 'South')
    AS locations(location, region)
),

WEATHER_BASE AS (
    SELECT 
        -- Generate timestamps for last 90 days, hourly data
        DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP()) as TIMESTAMP,
        l.location,
        l.region,
        
        -- Singapore temperature patterns (24-34°C typical range)
        CASE 
            -- Monsoon season (Nov-Mar): slightly cooler, more variable
            WHEN EXTRACT(MONTH FROM DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP())) IN (11, 12, 1, 2, 3) THEN
                ROUND(
                    -- Base temperature range for monsoon
                    UNIFORM(23.0, 32.5, RANDOM()) +
                    -- Daily temperature cycle (peak around 2-4 PM)
                    CASE 
                        WHEN EXTRACT(HOUR FROM DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP())) BETWEEN 14 AND 16 THEN UNIFORM(1.5, 3.0, RANDOM())
                        WHEN EXTRACT(HOUR FROM DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP())) BETWEEN 6 AND 10 THEN UNIFORM(0.5, 1.5, RANDOM())
                        WHEN EXTRACT(HOUR FROM DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP())) BETWEEN 2 AND 6 THEN UNIFORM(-2.0, -0.5, RANDOM())
                        ELSE UNIFORM(-0.5, 1.0, RANDOM())
                    END +
                    -- Regional variations (urban heat island effect)
                    CASE 
                        WHEN l.region = 'Central' THEN UNIFORM(0.5, 1.5, RANDOM())  -- Urban heat island
                        WHEN l.region = 'South' THEN UNIFORM(-0.5, 0.5, RANDOM())  -- Coastal cooling
                        ELSE UNIFORM(-0.3, 0.8, RANDOM())
                    END, 1
                )
            ELSE
                -- Dry season (Apr-Oct): warmer, more stable
                ROUND(
                    UNIFORM(25.5, 34.0, RANDOM()) +
                    -- Daily temperature cycle
                    CASE 
                        WHEN EXTRACT(HOUR FROM DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP())) BETWEEN 14 AND 16 THEN UNIFORM(1.0, 2.5, RANDOM())
                        WHEN EXTRACT(HOUR FROM DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP())) BETWEEN 6 AND 10 THEN UNIFORM(0.2, 1.0, RANDOM())
                        WHEN EXTRACT(HOUR FROM DATEADD(hour, -((ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1) % 2160), CURRENT_TIMESTAMP())) BETWEEN 2 AND 6 THEN UNIFORM(-1.5, -0.2, RANDOM())
                        ELSE UNIFORM(-0.3, 0.8, RANDOM())
                    END +
                    -- Regional variations
                    CASE 
                        WHEN l.region = 'Central' THEN UNIFORM(0.8, 1.8, RANDOM())
                        WHEN l.region = 'South' THEN UNIFORM(-0.3, 0.7, RANDOM())
                        ELSE UNIFORM(-0.2, 1.0, RANDOM())
                    END, 1
                )
        END as TEMPERATURE_C
        
    FROM SINGAPORE_LOCATIONS l
    CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 2160)) -- 90 days * 24 hours
),

WEATHER_ENHANCED AS (
    SELECT 
        TIMESTAMP,
        LOCATION,
        REGION,
        TEMPERATURE_C,
        
        -- Feels like temperature (heat index based on humidity)
        ROUND(TEMPERATURE_C + 
              CASE 
                  WHEN TEMPERATURE_C > 30 THEN UNIFORM(2, 6, RANDOM())  -- High heat index
                  WHEN TEMPERATURE_C > 27 THEN UNIFORM(1, 4, RANDOM())  -- Moderate heat index
                  ELSE UNIFORM(0, 2, RANDOM())                          -- Low heat index
              END, 1) as FEELS_LIKE_C,
        
        -- Singapore humidity (consistently high: 65-95%)
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 25 THEN UNIFORM(88, 95, RANDOM())  -- Very high
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN UNIFORM(78, 90, RANDOM())  -- High
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN UNIFORM(70, 85, RANDOM())  -- Moderate-high
            ELSE UNIFORM(65, 78, RANDOM())                                        -- Lower range (rare)
        END as HUMIDITY_PCT,
        
        -- Rainfall patterns based on Singapore's climate
        CASE 
            -- Monsoon season: more frequent and heavier rain
            WHEN EXTRACT(MONTH FROM TIMESTAMP) IN (11, 12, 1, 2, 3) THEN
                CASE 
                    -- Afternoon thunderstorm pattern (2-6 PM)
                    WHEN EXTRACT(HOUR FROM TIMESTAMP) BETWEEN 14 AND 18 THEN
                        CASE 
                            WHEN UNIFORM(1, 100, RANDOM()) <= 35 THEN 0
                            WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN UNIFORM(0.1, 3, RANDOM())
                            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN UNIFORM(3, 15, RANDOM())
                            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN UNIFORM(15, 40, RANDOM())
                            ELSE UNIFORM(40, 100, RANDOM())  -- Heavy thunderstorms
                        END
                    -- Early morning showers (4-8 AM)
                    WHEN EXTRACT(HOUR FROM TIMESTAMP) BETWEEN 4 AND 8 THEN
                        CASE 
                            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN 0
                            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN UNIFORM(0.1, 5, RANDOM())
                            ELSE UNIFORM(5, 20, RANDOM())
                        END
                    -- Other times
                    ELSE
                        CASE 
                            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN 0
                            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN UNIFORM(0.1, 2, RANDOM())
                            ELSE UNIFORM(2, 12, RANDOM())
                        END
                END
            ELSE
                -- Dry season: less frequent but still regular showers
                CASE 
                    WHEN EXTRACT(HOUR FROM TIMESTAMP) BETWEEN 14 AND 18 THEN
                        CASE 
                            WHEN UNIFORM(1, 100, RANDOM()) <= 50 THEN 0
                            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN UNIFORM(0.1, 2, RANDOM())
                            WHEN UNIFORM(1, 100, RANDOM()) <= 92 THEN UNIFORM(2, 10, RANDOM())
                            ELSE UNIFORM(10, 35, RANDOM())
                        END
                    ELSE
                        CASE 
                            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN 0
                            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN UNIFORM(0.1, 1.5, RANDOM())
                            ELSE UNIFORM(1.5, 8, RANDOM())
                        END
                END
        END as RAINFALL_MM,
        
        -- Wind patterns (generally light winds, stronger during thunderstorms)
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 60 THEN UNIFORM(5, 15, RANDOM())   -- Light winds
            WHEN UNIFORM(1, 100, RANDOM()) <= 85 THEN UNIFORM(15, 25, RANDOM())  -- Moderate winds
            WHEN UNIFORM(1, 100, RANDOM()) <= 95 THEN UNIFORM(25, 40, RANDOM())  -- Strong winds
            ELSE UNIFORM(40, 65, RANDOM())                                        -- Very strong (thunderstorms)
        END as WIND_SPEED_KMH,
        
        -- Wind direction (influenced by monsoons)
        CASE 
            WHEN EXTRACT(MONTH FROM TIMESTAMP) IN (11, 12, 1, 2, 3) THEN
                -- Northeast monsoon
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'NE'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'N'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'E'
                    ELSE ARRAY_CONSTRUCT('NW', 'SE', 'S', 'SW', 'W')[UNIFORM(0, 4, RANDOM())]
                END
            WHEN EXTRACT(MONTH FROM TIMESTAMP) IN (6, 7, 8, 9) THEN
                -- Southwest monsoon
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 40 THEN 'SW'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 65 THEN 'S'
                    WHEN UNIFORM(1, 100, RANDOM()) <= 80 THEN 'W'
                    ELSE ARRAY_CONSTRUCT('NE', 'N', 'E', 'NW', 'SE')[UNIFORM(0, 4, RANDOM())]
                END
            ELSE
                -- Inter-monsoon periods - more variable
                ARRAY_CONSTRUCT('N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW')[UNIFORM(0, 7, RANDOM())]
        END as WIND_DIRECTION,
        
        -- Atmospheric pressure (typical tropical range)
        ROUND(UNIFORM(1008, 1018, RANDOM()) + 
              CASE 
                  WHEN EXTRACT(HOUR FROM TIMESTAMP) BETWEEN 10 AND 16 THEN UNIFORM(-2, 0, RANDOM())  -- Lower during day
                  ELSE UNIFORM(0, 2, RANDOM())                                                        -- Higher at night
              END, 1) as PRESSURE_HPA,
        
        -- UV Index (high in tropics, varies by cloud cover and time)
        CASE 
            WHEN EXTRACT(HOUR FROM TIMESTAMP) BETWEEN 10 AND 16 THEN
                CASE 
                    WHEN UNIFORM(1, 100, RANDOM()) <= 30 THEN UNIFORM(8, 11, RANDOM())   -- Very high
                    WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN UNIFORM(6, 9, RANDOM())    -- High
                    ELSE UNIFORM(3, 7, RANDOM())                                          -- Moderate (cloudy)
                END
            WHEN EXTRACT(HOUR FROM TIMESTAMP) BETWEEN 8 AND 18 THEN UNIFORM(2, 6, RANDOM())
            ELSE 0  -- No UV at night
        END as UV_INDEX,
        
        -- Visibility (reduced during rain and haze)
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 70 THEN UNIFORM(8, 15, RANDOM())   -- Good visibility
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN UNIFORM(5, 10, RANDOM())   -- Moderate (haze/light rain)
            ELSE UNIFORM(1, 6, RANDOM())                                          -- Poor (heavy rain/haze)
        END as VISIBILITY_KM,
        
        -- Air Quality Index (Singapore typically good, occasional haze)
        CASE 
            WHEN UNIFORM(1, 100, RANDOM()) <= 75 THEN UNIFORM(15, 50, RANDOM())   -- Good
            WHEN UNIFORM(1, 100, RANDOM()) <= 90 THEN UNIFORM(51, 100, RANDOM())  -- Moderate
            WHEN UNIFORM(1, 100, RANDOM()) <= 98 THEN UNIFORM(101, 200, RANDOM()) -- Unhealthy (haze)
            ELSE UNIFORM(201, 300, RANDOM())                                       -- Very unhealthy (severe haze)
        END as AIR_QUALITY_INDEX
        
    FROM WEATHER_BASE
),

FINAL_WEATHER AS (
    SELECT 
        TIMESTAMP,
        LOCATION,
        REGION,
        TEMPERATURE_C,
        FEELS_LIKE_C,
        HUMIDITY_PCT,
        RAINFALL_MM,
        WIND_SPEED_KMH,
        WIND_DIRECTION,
        PRESSURE_HPA,
        UV_INDEX,
        VISIBILITY_KM,
        
        -- Weather condition based on rainfall and other factors
        CASE 
            WHEN RAINFALL_MM = 0 AND UV_INDEX >= 6 THEN 'Sunny'
            WHEN RAINFALL_MM = 0 AND UV_INDEX BETWEEN 3 AND 5 THEN 'Partly Cloudy'
            WHEN RAINFALL_MM = 0 THEN 'Cloudy'
            WHEN RAINFALL_MM <= 2.5 THEN 'Light Rain'
            WHEN RAINFALL_MM <= 10 THEN 'Moderate Rain'
            WHEN RAINFALL_MM <= 35 THEN 'Heavy Rain'
            ELSE 'Thunderstorm'
        END as WEATHER_CONDITION,
        
        -- Detailed weather description
        CASE 
            WHEN RAINFALL_MM = 0 AND UV_INDEX >= 8 THEN 'Clear skies with intense tropical sun'
            WHEN RAINFALL_MM = 0 AND UV_INDEX >= 6 THEN 'Sunny with scattered clouds'
            WHEN RAINFALL_MM = 0 AND UV_INDEX >= 3 THEN 'Partly cloudy with filtered sunlight'
            WHEN RAINFALL_MM = 0 THEN 'Overcast with thick cloud cover'
            WHEN RAINFALL_MM <= 2.5 THEN 'Light drizzle with high humidity'
            WHEN RAINFALL_MM <= 10 THEN 'Steady rain with reduced visibility'
            WHEN RAINFALL_MM <= 35 AND WIND_SPEED_KMH > 30 THEN 'Heavy rain with strong winds'
            WHEN RAINFALL_MM <= 35 THEN 'Heavy downpour typical of tropical climate'
            ELSE 'Intense thunderstorm with lightning and strong winds'
        END as WEATHER_DESCRIPTION,
        
        -- Alert level based on Singapore's weather warning system
        CASE 
            WHEN RAINFALL_MM <= 8 AND WIND_SPEED_KMH <= 40 AND AIR_QUALITY_INDEX <= 100 THEN 'Normal'
            WHEN RAINFALL_MM <= 20 OR WIND_SPEED_KMH <= 50 OR AIR_QUALITY_INDEX <= 200 THEN 'Advisory'
            WHEN RAINFALL_MM <= 50 OR WIND_SPEED_KMH <= 65 OR AIR_QUALITY_INDEX <= 300 THEN 'Warning'
            ELSE 'Red Alert'
        END as ALERT_LEVEL,
        
        AIR_QUALITY_INDEX
        
    FROM WEATHER_ENHANCED
)
SELECT * FROM FINAL_WEATHER;

-- Create summary statistics for the generated weather data
CREATE OR REPLACE VIEW SG_PUBSEC_DEMO.ANALYTICS.SINGAPORE_WEATHER_SUMMARY AS
SELECT 
    'Weather Data Summary for Singapore Demo' as DESCRIPTION,
    COUNT(*) as TOTAL_RECORDS,
    COUNT(DISTINCT LOCATION) as WEATHER_STATIONS,
    MIN(TIMESTAMP) as DATA_START_DATE,
    MAX(TIMESTAMP) as DATA_END_DATE,
    ROUND(AVG(TEMPERATURE_C), 1) as AVG_TEMPERATURE_C,
    ROUND(AVG(HUMIDITY_PCT), 0) as AVG_HUMIDITY_PCT,
    ROUND(SUM(RAINFALL_MM), 1) as TOTAL_RAINFALL_MM,
    COUNT(CASE WHEN WEATHER_CONDITION = 'Thunderstorm' THEN 1 END) as THUNDERSTORM_HOURS,
    COUNT(CASE WHEN ALERT_LEVEL != 'Normal' THEN 1 END) as WEATHER_ALERTS
FROM SG_PUBSEC_DEMO.EXTERNAL_DATA.SINGAPORE_WEATHER_DETAILED;

-- Grant permissions
GRANT SELECT ON SG_PUBSEC_DEMO.EXTERNAL_DATA.SINGAPORE_WEATHER_DETAILED TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
GRANT SELECT ON SG_PUBSEC_DEMO.ANALYTICS.SINGAPORE_WEATHER_SUMMARY TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Verification queries
SELECT 'Singapore weather data generation completed!' as STATUS;

-- Show summary statistics
SELECT * FROM SG_PUBSEC_DEMO.ANALYTICS.SINGAPORE_WEATHER_SUMMARY;

-- Show sample of generated data
SELECT 
    LOCATION,
    TIMESTAMP,
    TEMPERATURE_C,
    HUMIDITY_PCT,
    RAINFALL_MM,
    WEATHER_CONDITION,
    ALERT_LEVEL
FROM SG_PUBSEC_DEMO.EXTERNAL_DATA.SINGAPORE_WEATHER_DETAILED 
WHERE TIMESTAMP >= DATEADD(day, -7, CURRENT_TIMESTAMP())
ORDER BY TIMESTAMP DESC, LOCATION
LIMIT 20;

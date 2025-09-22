-- Cortex Search Service Setup for Singapore Government Knowledge
-- Creates search service for government documents and policies

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SNOWFLAKE_PUBSEC_DEMO;
USE WAREHOUSE SNOWFLAKE_DEMO_WH;

-- Create Cortex Search service for government knowledge
CREATE OR REPLACE CORTEX SEARCH SERVICE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE
ON CONTENT
WAREHOUSE = SNOWFLAKE_DEMO_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        DOCUMENT_ID,
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
            'keywords', KEYWORDS
        ) as METADATA
    FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
);

-- Grant permissions for the search service
GRANT USAGE ON CORTEX SEARCH SERVICE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE 
TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Test the search service
SELECT 'Cortex Search service created successfully!' as STATUS;

-- Wait for the search service to be ready (may take a few minutes)
SELECT 'Cortex Search service created. Waiting for indexing to complete...' as STATUS;

-- Example search queries to test the service (run these after a few minutes)
-- Use the correct syntax for Cortex Search queries

-- Search for SingPass information
SELECT *
FROM TABLE(
    SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE(
        QUERY => 'How do I set up SingPass account?',
        LIMIT => 5
    )
) as SINGPASS_SEARCH;

-- Search for housing information  
SELECT *
FROM TABLE(
    SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE(
        QUERY => 'HDB housing application process',
        LIMIT => 3
    )
) as HOUSING_SEARCH;

-- Search for healthcare information
SELECT *
FROM TABLE(
    SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE(
        QUERY => 'healthcare subsidies and Medisave',
        LIMIT => 3
    )
) as HEALTHCARE_SEARCH;

-- Search for business registration
SELECT *
FROM TABLE(
    SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE(
        QUERY => 'how to register a business in Singapore',
        LIMIT => 3
    )
) as BUSINESS_SEARCH;

-- Search for digital government services
SELECT *
FROM TABLE(
    SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE(
        QUERY => 'digital government transformation strategy',
        LIMIT => 3
    )
) as DIGITAL_GOV_SEARCH;

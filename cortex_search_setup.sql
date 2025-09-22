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
-- Use the correct SNOWFLAKE.CORTEX.SEARCH_PREVIEW function

-- Search for SingPass information
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
        '{
            "query": "How do I set up SingPass account?",
            "columns": ["CONTENT", "DOCUMENT_TITLE", "AGENCY"],
            "limit": 3
        }'
    )
)['results'] as SINGPASS_SEARCH_RESULTS;

-- Search for housing information  
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
        '{
            "query": "HDB housing application process",
            "columns": ["CONTENT", "DOCUMENT_TITLE", "AGENCY"],
            "limit": 3
        }'
    )
)['results'] as HOUSING_SEARCH_RESULTS;

-- Search for healthcare information
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
        '{
            "query": "healthcare subsidies and Medisave",
            "columns": ["CONTENT", "DOCUMENT_TITLE", "AGENCY"],
            "limit": 3
        }'
    )
)['results'] as HEALTHCARE_SEARCH_RESULTS;

-- Search for business registration
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
        '{
            "query": "how to register a business in Singapore",
            "columns": ["CONTENT", "DOCUMENT_TITLE", "AGENCY"],
            "limit": 3
        }'
    )
)['results'] as BUSINESS_SEARCH_RESULTS;

-- Search for digital government services
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
        '{
            "query": "digital government transformation strategy",
            "columns": ["CONTENT", "DOCUMENT_TITLE", "AGENCY"],
            "limit": 3
        }'
    )
)['results'] as DIGITAL_GOV_SEARCH_RESULTS;

-- Inspect the service contents to verify it's populated
SELECT *
FROM TABLE(
    CORTEX_SEARCH_DATA_SCAN(
        SERVICE_NAME => 'SNOWFLAKE_GOV_KNOWLEDGE_SERVICE'
    )
)
LIMIT 5;

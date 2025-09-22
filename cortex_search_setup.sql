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

-- Example search queries to test the service
SELECT 'Testing search functionality...' as STATUS;

-- Search for SingPass information
SELECT CORTEX_SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'How do I set up SingPass account?'
) as SINGPASS_SEARCH_RESULTS;

-- Search for housing information  
SELECT CORTEX_SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'HDB housing application process'
) as HOUSING_SEARCH_RESULTS;

-- Search for healthcare information
SELECT CORTEX_SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'healthcare subsidies and Medisave'
) as HEALTHCARE_SEARCH_RESULTS;

-- Search for business registration
SELECT CORTEX_SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'how to register a business in Singapore'
) as BUSINESS_SEARCH_RESULTS;

-- Search for digital government services
SELECT CORTEX_SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'digital government transformation strategy'
) as DIGITAL_GOV_SEARCH_RESULTS;

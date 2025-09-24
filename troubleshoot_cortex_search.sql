-- TROUBLESHOOT CORTEX SEARCH SERVICE
-- This script helps diagnose and fix Cortex Search issues

-- Step 1: Check if Cortex Search is available in your account
SELECT 'Checking Cortex Search availability...' as STATUS;

-- Try to list existing Cortex Search services
SHOW CORTEX SEARCH SERVICES;

-- Step 2: Check if the knowledge base table exists and has data
SELECT 'Checking knowledge base table...' as STATUS;

SELECT 
    'Knowledge Base Status' as CHECK_TYPE,
    COUNT(*) as DOCUMENT_COUNT,
    'Documents available for Cortex Search' as STATUS
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE;

-- Step 3: Check account capabilities
SELECT 'Checking account capabilities...' as STATUS;

-- Check if you have the necessary privileges
SHOW GRANTS TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

-- Step 4: Alternative approach - Create a simple search function using SQL
-- If Cortex Search isn't available, we can create a basic text search

CREATE OR REPLACE FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SIMPLE_DOCUMENT_SEARCH(
    SEARCH_TERM STRING
)
RETURNS TABLE (
    DOCUMENT_ID STRING,
    TITLE STRING,
    CONTENT TEXT,
    AGENCY STRING,
    RELEVANCE_SCORE NUMBER
)
LANGUAGE SQL
AS
$$
    SELECT 
        DOCUMENT_ID,
        TITLE,
        CONTENT,
        AGENCY,
        -- Simple relevance scoring based on keyword matches
        (
            CASE WHEN UPPER(TITLE) LIKE UPPER('%' || SEARCH_TERM || '%') THEN 10 ELSE 0 END +
            CASE WHEN UPPER(CONTENT) LIKE UPPER('%' || SEARCH_TERM || '%') THEN 5 ELSE 0 END +
            CASE WHEN UPPER(AGENCY) LIKE UPPER('%' || SEARCH_TERM || '%') THEN 3 ELSE 0 END
        ) as RELEVANCE_SCORE
    FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
    WHERE 
        UPPER(TITLE) LIKE UPPER('%' || SEARCH_TERM || '%') OR
        UPPER(CONTENT) LIKE UPPER('%' || SEARCH_TERM || '%') OR
        UPPER(AGENCY) LIKE UPPER('%' || SEARCH_TERM || '%')
    ORDER BY RELEVANCE_SCORE DESC
$$;

-- Test the alternative search function
SELECT 'Testing alternative search function...' as STATUS;

SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SIMPLE_DOCUMENT_SEARCH('Smart Nation'));

-- Step 5: Check if Cortex functions are available at all
SELECT 'Checking general Cortex availability...' as STATUS;

-- Try a simple Cortex function to see if any Cortex features work
-- SELECT SNOWFLAKE.CORTEX.COMPLETE('llama2-7b-chat', 'Hello, how are you?') as CORTEX_TEST;

SELECT 'Troubleshooting complete. Check results above.' as FINAL_STATUS;

-- CREATE SEARCH FUNCTIONS
-- Run this script to create the SQL-based search alternatives
-- Use when Cortex Search is not available in your Snowflake account

-- First, verify the knowledge base table exists
SELECT 'Checking knowledge base table...' as STATUS;
SELECT COUNT(*) as DOCUMENT_COUNT FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE;

-- Create the advanced document search function
CREATE OR REPLACE FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH(
    SEARCH_QUERY STRING
)
RETURNS TABLE (
    DOCUMENT_ID STRING,
    TITLE STRING,
    CONTENT_SNIPPET TEXT,
    AGENCY STRING,
    DOCUMENT_TYPE STRING,
    CLASSIFICATION STRING,
    RELEVANCE_SCORE NUMBER,
    MATCH_DETAILS STRING
)
LANGUAGE SQL
AS
$$
    WITH SEARCH_RESULTS AS (
        SELECT 
            DOCUMENT_ID,
            TITLE,
            CASE 
                WHEN UPPER(CONTENT) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN
                    SUBSTR(CONTENT, 
                           GREATEST(1, POSITION(UPPER(SEARCH_QUERY) IN UPPER(CONTENT)) - 100), 
                           300) || '...'
                ELSE LEFT(CONTENT, 200) || '...'
            END as CONTENT_SNIPPET,
            AGENCY,
            DOCUMENT_TYPE,
            CLASSIFICATION,
            (
                CASE WHEN UPPER(TITLE) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 20 ELSE 0 END +
                CASE WHEN UPPER(CONTENT) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 15 ELSE 0 END +
                CASE WHEN UPPER(AGENCY) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 10 ELSE 0 END +
                CASE WHEN UPPER(DOCUMENT_TYPE) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 8 ELSE 0 END
            ) as RELEVANCE_SCORE,
            CONCAT(
                CASE WHEN UPPER(TITLE) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 'Title Match; ' ELSE '' END,
                CASE WHEN UPPER(CONTENT) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 'Content Match; ' ELSE '' END,
                CASE WHEN UPPER(AGENCY) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 'Agency Match; ' ELSE '' END
            ) as MATCH_DETAILS
        FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
        WHERE 
            UPPER(TITLE) LIKE UPPER('%' || SEARCH_QUERY || '%') OR
            UPPER(CONTENT) LIKE UPPER('%' || SEARCH_QUERY || '%') OR
            UPPER(AGENCY) LIKE UPPER('%' || SEARCH_QUERY || '%') OR
            UPPER(DOCUMENT_TYPE) LIKE UPPER('%' || SEARCH_QUERY || '%')
    )
    SELECT * FROM SEARCH_RESULTS
    WHERE RELEVANCE_SCORE > 0
    ORDER BY RELEVANCE_SCORE DESC, TITLE
$$;

-- Create multi-keyword search function
CREATE OR REPLACE FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH(
    KEYWORDS STRING
)
RETURNS TABLE (
    DOCUMENT_ID STRING,
    TITLE STRING,
    CONTENT_SNIPPET TEXT,
    AGENCY STRING,
    DOCUMENT_TYPE STRING,
    CLASSIFICATION STRING,
    KEYWORD_MATCHES NUMBER,
    MATCHED_KEYWORDS STRING
)
LANGUAGE SQL
AS
$$
    WITH KEYWORD_SPLIT AS (
        SELECT 
            TRIM(VALUE) as KEYWORD
        FROM TABLE(SPLIT_TO_TABLE(KEYWORDS, ','))
        WHERE TRIM(VALUE) != ''
    ),
    DOCUMENT_MATCHES AS (
        SELECT 
            d.DOCUMENT_ID,
            d.TITLE,
            LEFT(d.CONTENT, 300) || '...' as CONTENT_SNIPPET,
            d.AGENCY,
            d.DOCUMENT_TYPE,
            d.CLASSIFICATION,
            COUNT(DISTINCT k.KEYWORD) as KEYWORD_MATCHES,
            LISTAGG(DISTINCT k.KEYWORD, ', ') as MATCHED_KEYWORDS
        FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE d
        CROSS JOIN KEYWORD_SPLIT k
        WHERE 
            UPPER(d.TITLE) LIKE UPPER('%' || k.KEYWORD || '%') OR
            UPPER(d.CONTENT) LIKE UPPER('%' || k.KEYWORD || '%') OR
            UPPER(d.AGENCY) LIKE UPPER('%' || k.KEYWORD || '%')
        GROUP BY d.DOCUMENT_ID, d.TITLE, d.CONTENT, d.AGENCY, d.DOCUMENT_TYPE, d.CLASSIFICATION
    )
    SELECT * FROM DOCUMENT_MATCHES
    WHERE KEYWORD_MATCHES > 0
    ORDER BY KEYWORD_MATCHES DESC, TITLE
$$;

-- Test the search functions
SELECT 'Testing search functions...' as STATUS;

-- Test 1: Search for accessibility
SELECT 'Test 1: Accessibility search' as TEST_NAME;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('accessibility'));

-- Test 2: Search for data protection
SELECT 'Test 2: Data protection search' as TEST_NAME;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('data protection'));

-- Test 3: Multi-keyword search
SELECT 'Test 3: Multi-keyword search' as TEST_NAME;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('digital, services, citizen'));

SELECT 'Search functions created and tested successfully!' as COMPLETION_STATUS;

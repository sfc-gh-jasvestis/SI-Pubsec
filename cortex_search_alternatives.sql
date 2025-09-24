-- CORTEX SEARCH ALTERNATIVES
-- If Cortex Search isn't available, here are working alternatives for the demo

-- Option 1: Enhanced SQL-based document search with full-text capabilities
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
            -- Create content snippet around matches
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
            -- Advanced relevance scoring
            (
                CASE WHEN UPPER(TITLE) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 20 ELSE 0 END +
                CASE WHEN UPPER(CONTENT) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 15 ELSE 0 END +
                CASE WHEN UPPER(AGENCY) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 10 ELSE 0 END +
                CASE WHEN UPPER(DOCUMENT_TYPE) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 8 ELSE 0 END +
                -- Bonus for exact phrase matches
                CASE WHEN UPPER(CONTENT) LIKE UPPER('%' || SEARCH_QUERY || '%') THEN 5 ELSE 0 END
            ) as RELEVANCE_SCORE,
            -- Match details for transparency
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

-- Option 2: Multi-keyword search function
CREATE OR REPLACE FUNCTION SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH(
    KEYWORDS STRING  -- Space-separated keywords
)
RETURNS TABLE (
    DOCUMENT_ID STRING,
    TITLE STRING,
    CONTENT_PREVIEW TEXT,
    AGENCY STRING,
    TOTAL_MATCHES NUMBER,
    KEYWORD_MATCHES STRING
)
LANGUAGE SQL
AS
$$
    WITH KEYWORD_SPLIT AS (
        -- Split keywords (simplified - assumes max 5 keywords)
        SELECT 
            TRIM(SPLIT_PART(KEYWORDS, ' ', 1)) as KEYWORD1,
            TRIM(SPLIT_PART(KEYWORDS, ' ', 2)) as KEYWORD2,
            TRIM(SPLIT_PART(KEYWORDS, ' ', 3)) as KEYWORD3,
            TRIM(SPLIT_PART(KEYWORDS, ' ', 4)) as KEYWORD4,
            TRIM(SPLIT_PART(KEYWORDS, ' ', 5)) as KEYWORD5
    ),
    DOCUMENT_MATCHES AS (
        SELECT 
            kb.DOCUMENT_ID,
            kb.TITLE,
            LEFT(kb.CONTENT, 250) || '...' as CONTENT_PREVIEW,
            kb.AGENCY,
            -- Count matches for each keyword
            (
                CASE WHEN ks.KEYWORD1 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD1 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD1 || '%')) THEN 1 ELSE 0 END +
                CASE WHEN ks.KEYWORD2 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD2 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD2 || '%')) THEN 1 ELSE 0 END +
                CASE WHEN ks.KEYWORD3 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD3 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD3 || '%')) THEN 1 ELSE 0 END +
                CASE WHEN ks.KEYWORD4 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD4 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD4 || '%')) THEN 1 ELSE 0 END +
                CASE WHEN ks.KEYWORD5 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD5 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD5 || '%')) THEN 1 ELSE 0 END
            ) as TOTAL_MATCHES,
            -- Show which keywords matched
            CONCAT(
                CASE WHEN ks.KEYWORD1 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD1 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD1 || '%')) THEN ks.KEYWORD1 || '; ' ELSE '' END,
                CASE WHEN ks.KEYWORD2 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD2 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD2 || '%')) THEN ks.KEYWORD2 || '; ' ELSE '' END,
                CASE WHEN ks.KEYWORD3 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD3 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD3 || '%')) THEN ks.KEYWORD3 || '; ' ELSE '' END,
                CASE WHEN ks.KEYWORD4 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD4 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD4 || '%')) THEN ks.KEYWORD4 || '; ' ELSE '' END,
                CASE WHEN ks.KEYWORD5 != '' AND (UPPER(kb.TITLE) LIKE UPPER('%' || ks.KEYWORD5 || '%') OR UPPER(kb.CONTENT) LIKE UPPER('%' || ks.KEYWORD5 || '%')) THEN ks.KEYWORD5 || '; ' ELSE '' END
            ) as KEYWORD_MATCHES
        FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE kb
        CROSS JOIN KEYWORD_SPLIT ks
    )
    SELECT * FROM DOCUMENT_MATCHES
    WHERE TOTAL_MATCHES > 0
    ORDER BY TOTAL_MATCHES DESC, TITLE
$$;

-- Test queries for the alternative search functions
SELECT '=== TESTING ALTERNATIVE SEARCH FUNCTIONS ===' as TEST_HEADER;

-- Test 1: Search for "Smart Nation"
SELECT 'Test 1: Searching for "Smart Nation"' as TEST_NAME;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('Smart Nation'));

-- Test 2: Search for "digital services"
SELECT 'Test 2: Searching for "digital services"' as TEST_NAME;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('digital services'));

-- Test 3: Multi-keyword search
SELECT 'Test 3: Multi-keyword search for "API security standards"' as TEST_NAME;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('API security standards'));

-- Test 4: Search by agency
SELECT 'Test 4: Searching for "GovTech"' as TEST_NAME;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('GovTech'));

SELECT '=== SEARCH FUNCTIONS READY FOR DEMO ===' as COMPLETION_STATUS;

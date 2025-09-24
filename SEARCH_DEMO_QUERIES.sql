-- ============================================================================
-- INTELLIGENT SEARCH SERVICE - DEMO QUERIES
-- Singapore Smart Nation Intelligence Demo
-- ============================================================================

-- This file contains example queries to demonstrate intelligent search capabilities
-- Includes both Cortex Search (if available) and SQL-based alternatives

-- ============================================================================
-- SETUP VERIFICATION AND TROUBLESHOOTING
-- ============================================================================

-- Check that documents are loaded in the knowledge base
SELECT 
    'Knowledge Base Status' as CHECK_TYPE,
    COUNT(*) as DOCUMENT_COUNT,
    'Documents loaded for search' as STATUS
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE;

-- Check if Cortex Search is available
SELECT 'Checking Cortex Search availability...' as STATUS;
SHOW CORTEX SEARCH SERVICES;

-- Test if Cortex Search functions work
-- Uncomment the following line to test Cortex availability:
-- SELECT SNOWFLAKE.CORTEX.COMPLETE('llama2-7b-chat', 'Test') as CORTEX_TEST;

-- View all documents with metadata
SELECT 
    DOCUMENT_ID,
    DOCUMENT_TYPE,
    TITLE,
    AGENCY,
    CLASSIFICATION,
    LAST_UPDATED,
    LEFT(CONTENT, 100) || '...' as CONTENT_PREVIEW
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
ORDER BY DOCUMENT_ID;

-- ============================================================================
-- OPTION A: CORTEX SEARCH QUERIES (if available)
-- ============================================================================

-- Query 1: Smart Nation Overview (Cortex Search)
SELECT 'Cortex Query 1: Smart Nation Overview' as QUERY_TYPE;

-- Uncomment if Cortex Search is available:
/*
SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'Smart Nation initiative key pillars digital government'
) as SEARCH_RESULTS;
*/

-- Query 2: Data Protection Guidelines (Cortex Search)
SELECT 'Cortex Query 2: Data Protection Guidelines' as QUERY_TYPE;

-- Uncomment if Cortex Search is available:
/*
SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'personal data protection privacy citizen rights'
) as SEARCH_RESULTS;
*/

-- ============================================================================
-- OPTION B: SQL-BASED SEARCH ALTERNATIVES (always available)
-- ============================================================================

-- Alternative Query 1: Smart Nation Overview (SQL Search)
SELECT 'SQL Query 1: Smart Nation Overview' as QUERY_TYPE;

SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('Smart Nation'));

-- Alternative Query 2: Data Protection Guidelines (SQL Search)
SELECT 'SQL Query 2: Data Protection Guidelines' as QUERY_TYPE;

SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('data protection'));

-- Alternative Query 3: Digital Service Design (SQL Search)
SELECT 'SQL Query 3: Digital Service Design Standards' as QUERY_TYPE;

SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('digital service'));

-- Alternative Query 4: API Integration Standards (SQL Search)
SELECT 'SQL Query 4: API Integration Standards' as QUERY_TYPE;

SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('API'));

-- Alternative Query 5: Citizen Engagement (SQL Search)
SELECT 'SQL Query 5: Citizen Engagement Strategy' as QUERY_TYPE;

SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('citizen engagement'));

-- ============================================================================
-- MULTI-KEYWORD SEARCH DEMONSTRATIONS
-- ============================================================================

-- Multi-keyword search examples
SELECT 'Multi-Keyword Search 1: API Security Standards' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('API security standards'));

SELECT 'Multi-Keyword Search 2: Digital Government Services' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('digital government services'));

SELECT 'Multi-Keyword Search 3: Privacy Data Protection' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('privacy data protection'));

-- ============================================================================
-- AGENCY-SPECIFIC SEARCHES
-- ============================================================================

-- Search by specific agencies
SELECT 'Agency Search 1: GovTech Documents' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('GovTech'));

SELECT 'Agency Search 2: Prime Ministers Office' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('Prime Ministers Office'));

SELECT 'Agency Search 3: Smart Nation Office' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('Smart Nation Office'));

-- ============================================================================
-- CLASSIFICATION-BASED SEARCHES
-- ============================================================================

-- Search within specific classification levels
SELECT 'Classification Search: Public Documents' as QUERY_TYPE;
SELECT 
    DOCUMENT_ID,
    TITLE,
    AGENCY,
    CLASSIFICATION,
    LEFT(CONTENT, 200) || '...' as CONTENT_PREVIEW
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
WHERE CLASSIFICATION = 'Public'
ORDER BY TITLE;

SELECT 'Classification Search: Internal Documents' as QUERY_TYPE;
SELECT 
    DOCUMENT_ID,
    TITLE,
    AGENCY,
    CLASSIFICATION,
    LEFT(CONTENT, 200) || '...' as CONTENT_PREVIEW
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
WHERE CLASSIFICATION = 'Internal'
ORDER BY TITLE;

-- ============================================================================
-- INTEGRATION WITH ANALYTICS
-- ============================================================================

-- Combine search results with service performance data
SELECT 'Integration Example: Policy Impact Analysis' as INTEGRATION_TYPE;

-- Correlate policy documents with actual service performance metrics
SELECT 
    sp.SERVICE_NAME,
    sp.AGENCY,
    AVG(sp.METRIC_VALUE) as AVG_PERFORMANCE,
    COUNT(*) as PERFORMANCE_RECORDS,
    'Related policies available via search' as POLICY_CONTEXT
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE sp
WHERE sp.AGENCY IN ('GovTech', 'Smart Nation Office', 'Prime Ministers Office')
GROUP BY sp.SERVICE_NAME, sp.AGENCY
ORDER BY AVG_PERFORMANCE DESC;

-- Show agencies with both policies and performance data
SELECT 
    'Cross-Reference Analysis' as ANALYSIS_TYPE,
    kb.AGENCY,
    COUNT(DISTINCT kb.DOCUMENT_ID) as POLICY_DOCUMENTS,
    COUNT(DISTINCT sp.METRIC_ID) as PERFORMANCE_METRICS,
    'Complete data coverage' as STATUS
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE kb
LEFT JOIN SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE sp ON kb.AGENCY = sp.AGENCY
GROUP BY kb.AGENCY
ORDER BY POLICY_DOCUMENTS DESC;

-- ============================================================================
-- DEMO PRESENTATION QUERIES
-- ============================================================================

-- For live demo: Show document diversity
SELECT 
    'Document Summary for Demo' as SUMMARY_TYPE,
    DOCUMENT_TYPE,
    COUNT(*) as DOC_COUNT,
    LISTAGG(AGENCY, ', ') as AGENCIES
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
GROUP BY DOCUMENT_TYPE;

-- For live demo: Show classification levels
SELECT 
    'Security Classification Summary' as SUMMARY_TYPE,
    CLASSIFICATION,
    COUNT(*) as DOC_COUNT,
    LISTAGG(TITLE, '; ') as DOCUMENT_TITLES
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
GROUP BY CLASSIFICATION;

-- ============================================================================
-- FINAL STATUS
-- ============================================================================

SELECT 
    'SEARCH DEMO STATUS' as STATUS_TYPE,
    CASE 
        WHEN (SELECT COUNT(*) FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE) >= 5
        THEN '✅ Knowledge Base Ready - ' || (SELECT COUNT(*) FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE) || ' documents loaded'
        ELSE '❌ Knowledge Base Not Ready'
    END as KNOWLEDGE_BASE_STATUS,
    'SQL-based search functions available as Cortex Search alternative' as SEARCH_STATUS;

SELECT 'Intelligent Search Demo Queries Ready!' as FINAL_STATUS;

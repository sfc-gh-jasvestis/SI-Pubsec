-- ============================================================================
-- CORTEX SEARCH SERVICE - DEMO QUERIES
-- Singapore Smart Nation Intelligence Demo
-- ============================================================================

-- This file contains example queries to demonstrate the Cortex Search service
-- using the government knowledge base documents

-- ============================================================================
-- SETUP VERIFICATION
-- ============================================================================

-- Check that documents are loaded in the knowledge base
SELECT 
    'Knowledge Base Status' as CHECK_TYPE,
    COUNT(*) as DOCUMENT_COUNT,
    'Documents loaded for Cortex Search' as STATUS
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE;

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
-- CORTEX SEARCH DEMO QUERIES
-- ============================================================================

-- Query 1: Smart Nation Overview
SELECT 'Demo Query 1: Smart Nation Overview' as QUERY_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'Smart Nation initiative key pillars digital government'
) as SEARCH_RESULTS;

-- Query 2: Data Protection Guidelines
SELECT 'Demo Query 2: Data Protection Guidelines' as QUERY_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'personal data protection privacy citizen rights'
) as SEARCH_RESULTS;

-- Query 3: Digital Service Design
SELECT 'Demo Query 3: Digital Service Design Standards' as QUERY_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'digital service design accessibility mobile user experience'
) as SEARCH_RESULTS;

-- Query 4: API Integration Standards
SELECT 'Demo Query 4: API Integration Standards' as QUERY_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'API integration OAuth authentication RESTful standards'
) as SEARCH_RESULTS;

-- Query 5: Citizen Engagement
SELECT 'Demo Query 5: Citizen Engagement Strategy' as QUERY_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'citizen engagement multi-channel feedback participation'
) as SEARCH_RESULTS;

-- ============================================================================
-- ADVANCED SEARCH SCENARIOS
-- ============================================================================

-- Scenario 1: Cross-agency Policy Search
SELECT 'Advanced Scenario 1: GovTech Policies' as SCENARIO_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'GovTech guidelines standards technical requirements'
) as SEARCH_RESULTS;

-- Scenario 2: Public vs Internal Documents
SELECT 'Advanced Scenario 2: Public Documents Only' as SCENARIO_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'public policy framework citizen services'
) as SEARCH_RESULTS;

-- Scenario 3: Security and Compliance
SELECT 'Advanced Scenario 3: Security and Compliance' as SCENARIO_TYPE;

SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'security cybersecurity authentication data governance compliance'
) as SEARCH_RESULTS;

-- ============================================================================
-- INTEGRATION WITH ANALYTICS
-- ============================================================================

-- Combine search results with service performance data
SELECT 'Integration Example: Policy Impact Analysis' as INTEGRATION_TYPE;

-- This would be used in a real scenario to correlate policy documents
-- with actual service performance metrics
SELECT 
    sp.SERVICE_NAME,
    sp.AGENCY,
    AVG(sp.METRIC_VALUE) as AVG_PERFORMANCE,
    'Related policies available via Cortex Search' as POLICY_CONTEXT
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE sp
WHERE sp.AGENCY IN ('GovTech', 'Smart Nation Office', 'Prime Ministers Office')
GROUP BY sp.SERVICE_NAME, sp.AGENCY
ORDER BY AVG_PERFORMANCE DESC;

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

SELECT 'Cortex Search Demo Queries Ready!' as STATUS;

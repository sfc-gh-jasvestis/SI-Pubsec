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
    'Personal Data Protection Commission guidelines data minimization'
) as SEARCH_RESULTS;
*/

-- Query 3: API Standards (Cortex Search)
SELECT 'Cortex Query 3: API Standards' as QUERY_TYPE;

-- Uncomment if Cortex Search is available:
/*
SELECT SNOWFLAKE.CORTEX.SEARCH(
    'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
    'API integration standards OAuth authentication'
) as SEARCH_RESULTS;
*/

-- ============================================================================
-- OPTION B: SQL-BASED SEARCH QUERIES (Alternative)
-- ============================================================================

-- Query 1: Accessibility Guidelines Search
SELECT 'SQL Query 1: Accessibility Guidelines' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('accessibility inclusive design'));

-- Query 2: Data Protection Compliance Search
SELECT 'SQL Query 2: Data Protection Compliance' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('data protection PDPC'));

-- Query 3: API Integration Standards Search
SELECT 'SQL Query 3: API Integration Standards' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('API OAuth authentication'));

-- Query 4: Citizen Engagement Strategies Search
SELECT 'SQL Query 4: Citizen Engagement Strategies' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('citizen engagement multi-channel'));

-- Query 5: Smart Nation Digital Services Search
SELECT 'SQL Query 5: Smart Nation Digital Services' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('Smart Nation digital services'));

-- ============================================================================
-- MULTI-KEYWORD SEARCH EXAMPLES
-- ============================================================================

-- Multi-keyword Search 1: Digital Government Services
SELECT 'Multi-Keyword Query 1: Digital Government Services' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('digital, government, services, citizen'));

-- Multi-keyword Search 2: Privacy and Security
SELECT 'Multi-Keyword Query 2: Privacy and Security' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('privacy, security, data, protection'));

-- Multi-keyword Search 3: Innovation and Technology
SELECT 'Multi-Keyword Query 3: Innovation and Technology' as QUERY_TYPE;
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.MULTI_KEYWORD_SEARCH('innovation, technology, AI, digital'));

-- ============================================================================
-- DEMO SCENARIO SPECIFIC QUERIES
-- ============================================================================

-- Scenario 1: Policy-Driven Performance Analysis Queries
SELECT 'Demo Scenario 1 Queries' as SCENARIO_TYPE;

-- Query 1A: Accessibility Compliance
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('inclusive design accessibility mobile'));

-- Query 1B: Service Performance Standards  
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('service performance standards uptime'));

-- Query 1C: Citizen-Centric Design
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('citizen-centric design user testing'));

-- Scenario 2: Compliance Intelligence Queries
SELECT 'Demo Scenario 2 Queries' as SCENARIO_TYPE;

-- Query 2A: Data Protection Compliance
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('data minimization purpose limitation'));

-- Query 2B: Cross-Agency Data Sharing
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('data sharing inter-agency protocols'));

-- Query 2C: Consent Management
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('consent management privacy by design'));

-- Scenario 3: Crisis Response Intelligence Queries
SELECT 'Demo Scenario 3 Queries' as SCENARIO_TYPE;

-- Query 3A: Crisis Communication
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('crisis communication multi-channel alerts'));

-- Query 3B: Emergency Response
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('emergency response resource allocation'));

-- Query 3C: Multi-Agency Coordination
SELECT * FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('inter-agency coordination protocols'));

-- ============================================================================
-- PERFORMANCE AND RELEVANCE TESTING
-- ============================================================================

-- Test search performance and relevance scoring
SELECT 'Performance Test: Search Response Times' as TEST_TYPE;

-- Time a complex search
SELECT 
    CURRENT_TIMESTAMP() as START_TIME,
    COUNT(*) as RESULTS_COUNT
FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('government digital transformation Smart Nation'));

-- Test relevance scoring accuracy
SELECT 'Relevance Test: Score Distribution' as TEST_TYPE;
SELECT 
    RELEVANCE_SCORE,
    COUNT(*) as RESULT_COUNT,
    AVG(LENGTH(CONTENT_SNIPPET)) as AVG_SNIPPET_LENGTH
FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('digital services'))
GROUP BY RELEVANCE_SCORE
ORDER BY RELEVANCE_SCORE DESC;

-- ============================================================================
-- COMPREHENSIVE SEARCH VALIDATION
-- ============================================================================

-- Validate all document types are searchable
SELECT 'Validation: Document Type Coverage' as VALIDATION_TYPE;
SELECT 
    DOCUMENT_TYPE,
    COUNT(*) as SEARCH_RESULTS
FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('government'))
GROUP BY DOCUMENT_TYPE
ORDER BY SEARCH_RESULTS DESC;

-- Validate all agencies are represented in search results
SELECT 'Validation: Agency Coverage' as VALIDATION_TYPE;
SELECT 
    AGENCY,
    COUNT(*) as SEARCH_RESULTS
FROM TABLE(SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.ADVANCED_DOCUMENT_SEARCH('digital'))
GROUP BY AGENCY
ORDER BY SEARCH_RESULTS DESC;

SELECT 'All search demo queries completed successfully!' as COMPLETION_STATUS;

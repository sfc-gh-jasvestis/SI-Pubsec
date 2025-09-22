-- Update Government Knowledge URLs - Fix for Source Link Issue
-- This script updates existing records in the government knowledge table with corrected URLs

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SNOWFLAKE_PUBSEC_DEMO;
USE WAREHOUSE SNOWFLAKE_DEMO_WH;

-- Update all the URLs to use main agency websites instead of specific sub-pages
UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.smartnation.gov.sg'
WHERE DOCUMENT_ID = 'DOC001';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.smartnation.gov.sg'
WHERE DOCUMENT_ID = 'DOC002';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.singpass.gov.sg'
WHERE DOCUMENT_ID = 'DOC003';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.moh.gov.sg'
WHERE DOCUMENT_ID = 'DOC004';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.moe.gov.sg/education-in-sg/educational-technology-journey/edtech-masterplan',
    DOCUMENT_TITLE = 'EdTech Masterplan 2030',
    CONTENT = 'Ministry of Education EdTech Masterplan 2030 outlines technology-transformed learning to prepare students for a technology-transformed world. Key initiatives include AI-enabled personalized learning, digital literacy integration, 21st century competencies development, and enhanced collaborative culture. The plan emphasizes teacher professional development, learning analytics, and intelligent responsive learning environments.',
    KEYWORDS = 'EdTech Masterplan, digital literacy, AI-enabled learning, 21st century competencies'
WHERE DOCUMENT_ID = 'DOC005';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.ura.gov.sg'
WHERE DOCUMENT_ID = 'DOC006';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.csa.gov.sg'
WHERE DOCUMENT_ID = 'DOC007';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.pdpc.gov.sg'
WHERE DOCUMENT_ID = 'DOC008';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.pmo.gov.sg'
WHERE DOCUMENT_ID = 'DOC009';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.reach.gov.sg'
WHERE DOCUMENT_ID = 'DOC010';

-- Update FAQ URLs
UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.hdb.gov.sg'
WHERE DOCUMENT_ID = 'FAQ001';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.singpass.gov.sg'
WHERE DOCUMENT_ID = 'FAQ002';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.moh.gov.sg'
WHERE DOCUMENT_ID = 'FAQ003';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.acra.gov.sg'
WHERE DOCUMENT_ID = 'FAQ004';

UPDATE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
SET DOCUMENT_URL = 'https://www.mom.gov.sg'
WHERE DOCUMENT_ID = 'FAQ005';

-- Verify the updates
SELECT DOCUMENT_ID, DOCUMENT_TITLE, DOCUMENT_URL 
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
ORDER BY DOCUMENT_ID;

-- Now recreate the Cortex Search service with the updated data
DROP CORTEX SEARCH SERVICE IF EXISTS SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE;

CREATE OR REPLACE CORTEX SEARCH SERVICE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE
ON CONTENT
WAREHOUSE = SNOWFLAKE_DEMO_WH
TARGET_LAG = '1 hour'
AS (
    SELECT 
        DOCUMENT_URL as DOCUMENT_ID,  -- Use URL as the primary ID for proper linking
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
            'keywords', KEYWORDS,
            'source_link', DOCUMENT_URL  -- Explicit source link field
        ) as METADATA
    FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE
);

-- Grant permissions for the search service
GRANT USAGE ON CORTEX SEARCH SERVICE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE 
TO ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;

SELECT 'Government knowledge URLs updated and Cortex Search service recreated!' as STATUS;
SELECT 'Wait 2-5 minutes for the search service to reindex before testing' as NEXT_STEP;

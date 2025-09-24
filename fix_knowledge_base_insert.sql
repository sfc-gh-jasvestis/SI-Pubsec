-- Fixed INSERT statement for Government Knowledge Base
-- This specifies the column names explicitly to avoid the column count mismatch

-- Insert government knowledge base documents (specifying columns explicitly)
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE (
    DOCUMENT_ID,
    DOCUMENT_TYPE,
    TITLE,
    CONTENT,
    AGENCY,
    CLASSIFICATION,
    LAST_UPDATED
) VALUES
('DOC001', 'Policy Framework', 'Smart Nation Initiative Overview', 
 'The Smart Nation initiative aims to harness technology and data to improve living, create economic opportunities, and build stronger communities. Key pillars include digital government services, urban sensing platforms, digital identity infrastructure, and national AI strategy. Implementation focuses on citizen-centric design, data-driven decision making, and cross-agency collaboration to deliver seamless government services.', 
 'Prime Ministers Office', 'Public', '2024-01-15'),
 
('DOC002', 'Service Standard', 'Digital Service Design Guidelines', 
 'Government digital services must prioritize user experience, accessibility, and security. Design principles include mobile-first approach, plain language communication, inclusive design for all abilities, and robust cybersecurity measures. Services should integrate across agencies, provide real-time status updates, and offer multiple interaction channels while maintaining consistent branding and user experience standards.', 
 'GovTech', 'Internal', '2024-01-10'),
 
('DOC003', 'Data Governance', 'Personal Data Protection Guidelines', 
 'Personal Data Protection Commission guidelines establish data governance standards for government agencies. Key principles include data minimization, purpose limitation, consent management, and privacy by design. The guidelines cover data sharing protocols, citizen rights, breach notification procedures, and compliance monitoring frameworks to ensure responsible data stewardship.', 
 'PDPC', 'Restricted', '2024-01-08'),

('DOC004', 'Technical Standard', 'API Integration Standards', 
 'Government APIs must follow RESTful design principles, implement OAuth 2.0 authentication, and provide comprehensive documentation. Rate limiting, versioning, and error handling standards ensure reliable inter-agency data exchange. All APIs must support JSON format, implement proper logging, and maintain 99.9% uptime SLA for critical services.', 
 'GovTech', 'Internal', '2024-01-12'),

('DOC005', 'Policy Framework', 'Citizen Engagement Strategy', 
 'Digital citizen engagement requires multi-channel approach including mobile apps, web portals, social media, and physical touchpoints. Feedback mechanisms, user testing, and accessibility compliance ensure inclusive participation. Regular surveys, focus groups, and analytics drive continuous improvement in service delivery and citizen satisfaction.', 
 'Smart Nation Office', 'Public', '2024-01-20');

-- Verify the insert worked
SELECT 'Knowledge base documents inserted successfully!' as STATUS;

SELECT 
    DOCUMENT_ID,
    DOCUMENT_TYPE,
    TITLE,
    AGENCY,
    CLASSIFICATION,
    LAST_UPDATED,
    CREATED_AT
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE_BASE
ORDER BY DOCUMENT_ID;

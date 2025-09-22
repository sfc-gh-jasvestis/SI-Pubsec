-- Singapore Government Knowledge Base Setup
-- Creates mock government documents for Cortex Search service

USE ROLE SNOWFLAKE_INTELLIGENCE_ADMIN;
USE DATABASE SNOWFLAKE_PUBSEC_DEMO;
USE WAREHOUSE SNOWFLAKE_DEMO_WH;

-- Create table for government knowledge documents
CREATE OR REPLACE TABLE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE (
    DOCUMENT_ID STRING,
    DOCUMENT_TITLE STRING,
    DOCUMENT_TYPE STRING,
    AGENCY STRING,
    CONTENT TEXT,
    CATEGORY STRING,
    LAST_UPDATED DATE,
    DOCUMENT_URL STRING,
    KEYWORDS STRING,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

-- Insert comprehensive Singapore government knowledge content
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE (
    DOCUMENT_ID,
    DOCUMENT_TITLE,
    DOCUMENT_TYPE,
    AGENCY,
    CONTENT,
    CATEGORY,
    LAST_UPDATED,
    DOCUMENT_URL,
    KEYWORDS
)
VALUES 
    ('DOC001', 'Digital Government Blueprint 2025', 'Policy Document', 'Smart Nation Office', 
     'Singapore Digital Government Blueprint outlines the strategic direction for digital transformation of government services. Key initiatives include SingPass digital identity, GovTech digital services platform, and AI-powered citizen services. The blueprint emphasizes citizen-centric design, data-driven decision making, and seamless inter-agency collaboration. Priority areas include healthcare digitization, education technology integration, and smart urban planning systems.', 
     'Digital Transformation', '2024-09-01', 'https://www.smartnation.gov.sg/digital-blueprint', 'digital government, SingPass, GovTech, AI services'),

    ('DOC002', 'Smart Nation Initiative Overview', 'Strategic Plan', 'Smart Nation Office', 
     'Smart Nation Singapore is a national initiative to harness technology and data to improve living, create economic opportunities, and build stronger communities. Key pillars include Digital Economy, Digital Government, and Digital Society. Major projects encompass autonomous vehicles, cashless payments, smart healthcare systems, and urban sensing platforms. The initiative promotes innovation through public-private partnerships and citizen engagement.', 
     'Smart Nation', '2024-08-15', 'https://www.smartnation.gov.sg/about', 'smart nation, digital economy, autonomous vehicles, cashless payments'),

    ('DOC003', 'SingPass Digital Identity Services', 'Service Guide', 'GovTech', 
     'SingPass is Singapore national digital identity platform providing secure access to government and private sector services. Features include biometric authentication, digital wallet, document storage, and API integration. Citizens can access over 1,400 government services through SingPass. The platform supports multi-factor authentication, facial recognition, and blockchain-based document verification for enhanced security.', 
     'Digital Identity', '2024-09-10', 'https://www.singpass.gov.sg/main', 'SingPass, digital identity, biometric, authentication, government services'),

    ('DOC004', 'Healthcare Digital Transformation Strategy', 'Policy Document', 'MOH', 
     'Ministry of Health digital transformation strategy focuses on integrated healthcare delivery, predictive analytics, and personalized medicine. Key components include HealthHub digital platform, telemedicine services, AI-powered diagnostics, and electronic health records integration. The strategy emphasizes preventive care, chronic disease management, and health data interoperability across healthcare providers.', 
     'Healthcare', '2024-08-20', 'https://www.moh.gov.sg/digital-health', 'healthcare, HealthHub, telemedicine, AI diagnostics, electronic health records'),

    ('DOC005', 'Education Technology Roadmap', 'Strategic Plan', 'MOE', 
     'Ministry of Education technology roadmap outlines digital learning transformation for Singapore schools. Initiatives include personalized learning platforms, AI-powered tutoring systems, virtual reality classrooms, and digital assessment tools. The roadmap emphasizes teacher training, infrastructure development, and equitable access to technology across all educational institutions.', 
     'Education', '2024-07-30', 'https://www.moe.gov.sg/education-technology', 'education technology, personalized learning, AI tutoring, virtual reality, digital assessment'),

    ('DOC006', 'Urban Planning and Smart City Infrastructure', 'Technical Guide', 'URA', 
     'Urban Redevelopment Authority smart city infrastructure guide covers intelligent transportation systems, smart building standards, environmental monitoring networks, and integrated urban planning platforms. Key technologies include IoT sensors, 5G connectivity, digital twins, and predictive analytics for urban management. The guide emphasizes sustainable development and citizen quality of life improvements.', 
     'Urban Planning', '2024-08-05', 'https://www.ura.gov.sg/smart-city', 'urban planning, smart city, IoT sensors, 5G, digital twins, sustainable development'),

    ('DOC007', 'Cybersecurity Framework for Government Agencies', 'Security Policy', 'CSA', 
     'Cyber Security Agency framework provides comprehensive cybersecurity guidelines for government agencies. Components include threat assessment protocols, incident response procedures, security architecture standards, and staff training requirements. The framework emphasizes zero-trust security models, continuous monitoring, and inter-agency threat intelligence sharing for robust cyber defense.', 
     'Cybersecurity', '2024-09-05', 'https://www.csa.gov.sg/government-framework', 'cybersecurity, threat assessment, incident response, zero-trust, threat intelligence'),

    ('DOC008', 'Data Governance and Privacy Protection Guidelines', 'Policy Document', 'PDPC', 
     'Personal Data Protection Commission guidelines establish data governance standards for government agencies. Key principles include data minimization, purpose limitation, consent management, and privacy by design. The guidelines cover data sharing protocols, citizen rights, breach notification procedures, and compliance monitoring frameworks to ensure responsible data stewardship.', 
     'Data Governance', '2024-08-25', 'https://www.pdpc.gov.sg/government-guidelines', 'data governance, privacy protection, data minimization, consent management, compliance'),

    ('DOC009', 'Inter-Agency Collaboration Framework', 'Operational Guide', 'PMO', 
     'Prime Minister Office inter-agency collaboration framework facilitates seamless coordination across government agencies. Components include shared service platforms, standardized APIs, common data formats, and collaborative workflow systems. The framework promotes efficiency, reduces duplication, and enables holistic policy implementation through integrated government operations.', 
     'Inter-Agency Collaboration', '2024-07-15', 'https://www.pmo.gov.sg/collaboration-framework', 'inter-agency, collaboration, shared services, APIs, workflow systems'),

    ('DOC010', 'Citizen Engagement and Feedback Systems', 'Service Guide', 'REACH', 
     'REACH citizen engagement platform enables government-citizen communication through multiple channels including online portals, mobile apps, community forums, and feedback systems. The platform supports policy consultation, service feedback, and community participation in government decision-making processes. Features include sentiment analysis, trend identification, and responsive communication protocols.', 
     'Citizen Engagement', '2024-09-12', 'https://www.reach.gov.sg/engagement', 'citizen engagement, feedback systems, policy consultation, community participation, sentiment analysis');

-- Create additional FAQ-style content for common government service questions
INSERT INTO SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE (
    DOCUMENT_ID,
    DOCUMENT_TITLE,
    DOCUMENT_TYPE,
    AGENCY,
    CONTENT,
    CATEGORY,
    LAST_UPDATED,
    DOCUMENT_URL,
    KEYWORDS
)
VALUES 
    ('FAQ001', 'How to Apply for HDB Housing', 'FAQ', 'HDB', 
     'Housing Development Board (HDB) housing application process: 1) Register for HDB Flat Eligibility (HFE) letter online, 2) Submit application during sales launch, 3) Complete required documents including income assessment, 4) Attend appointment for verification, 5) Sign lease agreement upon successful allocation. Eligibility criteria include citizenship, age, income ceiling, and first-time applicant status. Various housing schemes available including BTO, SBF, and resale options.', 
     'Housing', '2024-09-01', 'https://www.hdb.gov.sg/residential/buying-a-flat', 'HDB, housing application, BTO, eligibility, lease agreement'),

    ('FAQ002', 'SingPass Account Setup and Troubleshooting', 'FAQ', 'GovTech', 
     'SingPass account setup: 1) Visit SingPass website or download mobile app, 2) Register using NRIC and personal details, 3) Verify identity through SMS or physical verification, 4) Set up 2FA authentication, 5) Complete profile setup. Troubleshooting common issues: password reset through SMS verification, account lockout resolution through customer service, biometric setup for mobile app, and API integration for developers.', 
     'Digital Services', '2024-09-15', 'https://www.singpass.gov.sg/setup', 'SingPass, account setup, 2FA, biometric, troubleshooting'),

    ('FAQ003', 'Healthcare Subsidies and Medisave Usage', 'FAQ', 'MOH', 
     'Healthcare subsidies in Singapore: Medisave for hospitalization and approved medical procedures, Medishield Life for catastrophic medical expenses, Community Health Assist Scheme (CHAS) for primary care, and Pioneer Generation Package for seniors. Medisave usage guidelines include withdrawal limits, approved procedures, and family member coverage. Subsidy eligibility based on income assessment and citizenship status.', 
     'Healthcare', '2024-08-30', 'https://www.moh.gov.sg/healthcare-subsidies', 'healthcare subsidies, Medisave, Medishield, CHAS, Pioneer Generation'),

    ('FAQ004', 'Business Registration and Licensing', 'FAQ', 'ACRA', 
     'Business registration process: 1) Reserve company name through BizFile+, 2) Prepare incorporation documents, 3) Submit application with required fees, 4) Obtain business registration certificate, 5) Apply for relevant business licenses. Required documents include memorandum and articles of association, director and shareholder details, registered office address. Various business structures available including private limited company, sole proprietorship, and partnership.', 
     'Business Services', '2024-08-10', 'https://www.acra.gov.sg/how-to-guides/before-you-start/how-to-register-a-company', 'business registration, ACRA, BizFile+, incorporation, licensing'),

    ('FAQ005', 'Work Pass and Employment Guidelines', 'FAQ', 'MOM', 
     'Work pass applications for foreign workers: Employment Pass for professionals, S Pass for mid-skilled workers, Work Permit for semi-skilled workers. Application process includes employer sponsorship, salary requirements, educational qualifications, and quota limitations. Renewal procedures, dependent pass applications, and permanent residence pathways. Compliance requirements for employers including levy payments and worker welfare standards.', 
     'Employment', '2024-09-08', 'https://www.mom.gov.sg/passes-and-permits', 'work pass, Employment Pass, S Pass, Work Permit, MOM');

-- Enable change tracking (required for Cortex Search)
ALTER TABLE SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE SET
  CHANGE_TRACKING = TRUE;

-- Create summary statistics
SELECT 'Government knowledge base created successfully!' as STATUS,
       COUNT(*) as TOTAL_DOCUMENTS,
       COUNT(DISTINCT AGENCY) as AGENCIES_COVERED,
       COUNT(DISTINCT CATEGORY) as CATEGORIES_COVERED
FROM SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.GOVERNMENT_KNOWLEDGE;

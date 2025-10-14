# Singapore Smart Nation Intelligence Agent Configuration
## Snowflake Intelligence Agent Setup for Public Sector Day Demo

---

## 🎯 Quick Setup Guide

**UI Location:** Navigate to **Data → Agents → + Agent**

Follow these sections in order:
1. [Basic Information](#1-basic-information) → Agent name, schema, description
2. [Tools Configuration](#2-tools-configuration) → Add each tool via UI
3. [Orchestration Tab](#3-orchestration-instructions) → Orchestration Instructions + Response Instructions
4. [Warehouse Selection](#4-warehouse-selection) → Select compute warehouse

---

## 1. Basic Information

**These fields go in the "Create Agent" form:**

- **Agent Name:** `SNOWFLAKE_Smart_Nation_Assistant`
- **Display Name:** `Singapore Smart Nation Intelligence Assistant`
- **Schema:** `snowflake_intelligence.agents`
- **Description:**
  ```
  AI-powered assistant for Singapore's digital government services, providing instant insights across citizen services, policy impact, and inter-agency coordination.
  ```

---

## 2. Tools Configuration

**Add these tools via the "Add Tool" button in the agent UI:**

### A. Cortex Analyst Services (Semantic Models)

#### Tool 1: Citizen Services Analytics
- **Tool Name:** `Citizen_Services_Analytics`
- **Tool Type:** Cortex Analyst
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `citizen_services_model.yaml`
- **Description:** Natural language queries for citizen service analytics with automatic chart generation

#### Tool 2: Citizen Journey Analytics
- **Tool Name:** `Citizen_Journey_Analytics`
- **Tool Type:** Cortex Analyst
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `citizen_journey_model.yaml`
- **Description:** End-to-end citizen journey tracking from portal inquiry to service fulfillment with cost analysis

#### Tool 3: Policy Impact Analytics
- **Tool Name:** `Policy_Impact_Analytics`
- **Tool Type:** Cortex Analyst
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `policy_impact_model.yaml`
- **Description:** Policy effectiveness analysis with visual insights and trend analysis

#### Tool 4: Service Performance Analytics
- **Tool Name:** `Service_Performance_Analytics`
- **Tool Type:** Cortex Analyst
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `service_performance_model.yaml`
- **Description:** Government service performance monitoring with benchmark comparisons

#### Tool 5: Weather Service Analytics
- **Tool Name:** `Weather_Service_Analytics`
- **Tool Type:** Cortex Analyst
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `weather_service_correlation_model.yaml`
- **Description:** Weather impact analysis on government services with regional correlations

---

### B. Cortex Search Service (Knowledge Base)

#### Tool 6: Singapore Government Knowledge
- **Tool Name:** `Singapore_Government_Knowledge`
- **Tool Type:** Cortex Search
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `INTELLIGENCE`  
- **Search Service:** `SNOWFLAKE_GOV_KNOWLEDGE_SERVICE`
- **Columns:**
  - **ID Column:** `DOCUMENT_ID`
  - **Title Column:** `TITLE`
- **Description:** Search through Singapore government policies, procedures, and best practices (15 documents including Smart Nation Blueprint, SingPass services, Healthcare strategy, EdTech Masterplan, Housing FAQs, Business Registration, Cybersecurity frameworks, and more)

---

### C. Custom Functions & Procedures

#### Tool 7: Policy Brief Generator
- **Tool Name:** `Generate_Policy_Brief`
- **Tool Type:** Procedure
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `INTELLIGENCE`
- **Identifier:** `GENERATE_POLICY_BRIEF(STRING, STRING)`
- **Parameters:**
  - `policy_name` (STRING): Name of the policy or topic for the brief
  - `recipient_email` (STRING): Email address to send the brief
- **Description:** Generate and email executive policy briefings to government officials
- **Warehouse:** `SNOWFLAKE_DEMO_WH`

#### Tool 8: Service Alert System
- **Tool Name:** `Send_Service_Alert`
- **Tool Type:** Procedure
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `INTELLIGENCE`
- **Identifier:** `SEND_SERVICE_ALERT(STRING, STRING, STRING)`
- **Parameters:**
  - `alert_message` (STRING): The alert message content
  - `severity` (STRING): Alert severity level (LOW, MEDIUM, HIGH, CRITICAL)
  - `target_agencies` (STRING): Comma-separated list of agencies to notify
- **Description:** Send alerts to relevant government agencies about service issues or updates
- **Warehouse:** `SNOWFLAKE_DEMO_WH`

#### Tool 9: Resource Optimizer
- **Tool Name:** `Optimize_Resources`
- **Tool Type:** Procedure
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `INTELLIGENCE`
- **Identifier:** `OPTIMIZE_RESOURCES(STRING, STRING)`
- **Parameters:**
  - `service_type` (STRING): Type of service to optimize
  - `time_period` (STRING): Time period for optimization (NEXT_WEEK, NEXT_MONTH)
- **Description:** Analyze service patterns and recommend resource allocation optimizations
- **Warehouse:** `SNOWFLAKE_DEMO_WH`

#### Tool 10: Web Scraping (Advanced)
- **Tool Name:** `Analyze_Policy_Website`
- **Tool Type:** Procedure
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `INTELLIGENCE`
- **Identifier:** `ANALYZE_POLICY_WEBSITE(STRING)`
- **Parameters:**
  - `website_url` (STRING): URL of the policy website to analyze
- **Description:** Scrape and analyze external policy websites for competitive intelligence and benchmarking
- **Warehouse:** `SNOWFLAKE_DEMO_WH`

#### Tool 11: Document Sharing (Advanced)
- **Tool Name:** `Share_Document`
- **Tool Type:** Procedure
- **Database:** `SNOWFLAKE_PUBSEC_DEMO`
- **Schema:** `INTELLIGENCE`
- **Identifier:** `SHARE_DOCUMENT(STRING, STRING, NUMBER)`
- **Parameters:**
  - `document_name` (STRING): Name of the document to share
  - `recipient_email` (STRING): Email address of recipient
  - `expiry_hours` (NUMBER): Hours until access expires (default: 48)
- **Description:** Generate secure presigned URLs for inter-agency document sharing with time-limited access
- **Warehouse:** `SNOWFLAKE_DEMO_WH`

---

## 3. Orchestration Instructions

**Navigate to the "Orchestration" tab in the agent UI and fill in BOTH fields:**

### A. Orchestration Instructions Field

**📝 Copy this block into "Orchestration Instructions":**

```
You are the Singapore Smart Nation Intelligence Assistant, designed to help government officials, policy makers, and service coordinators access and analyze data across Singapore's digital government ecosystem.

DATA ANALYSIS APPROACH:
- Always provide context about Singapore's digital government landscape
- Include relevant benchmarks and performance targets (e.g., 95% service uptime target)
- Consider cross-agency impacts and dependencies
- Maintain focus on citizen experience and service delivery excellence
- Break down complex queries into logical components
- Provide both high-level summaries and detailed insights
- Include confidence levels for predictions
- Suggest follow-up questions or deeper analysis opportunities

TOOL ORCHESTRATION:
- Use Cortex Analyst tools for quantitative data analysis and trend identification
- Use Cortex Search for government policy knowledge and procedural questions
- Use custom procedures for actions like generating briefs or sending alerts
- Combine multiple tools when needed for comprehensive analysis (e.g., Analyst + Search)
- For citizen journey queries, use the Citizen_Journey_Analytics tool to track end-to-end service delivery
- For weather correlations, use Weather_Service_Analytics to understand external impacts

KNOWLEDGE BASE USAGE:
- When citing government policies, reference the specific document ID (e.g., DOC001, DOC002)
- Mention the responsible government agency for each policy or service
- Include direct links to official government websites when available from search results
- Encourage users to consult with relevant agencies for the most up-to-date information

ACTIONS AND PROCEDURES:
- Before executing procedures that send emails or alerts, summarize what will happen
- Confirm the scope and impact of resource optimization actions
- Provide clear feedback on what actions were taken and next steps
- Log all automated actions for audit purposes
- Respect data governance and privacy requirements at all times

HANDLING COMPLEX QUERIES:
- For multi-part questions, break them into logical components
- Process each component with the most appropriate tool
- Synthesize findings into a cohesive response
- Always include data sources and time periods in your analysis
- When data is insufficient, clearly state limitations and suggest alternatives
```

### B. Response Instructions Field

**📝 Copy this block into "Response Instructions":**

```
RESPONSE STYLE AND TONE:
- Maintain a professional, helpful tone appropriate for government officials and policy makers
- Always prioritize citizen privacy and data protection in your language
- Be concise yet thorough - balance detail with readability
- Use active voice and clear, direct language

SINGAPORE CONTEXT:
- Use Singapore-specific terminology consistently:
  * "residents" or "citizens" (not "customers" or "users")
  * Reference actual agencies: MOH, MOM, MSF, MTI, IRAS, HDB, etc.
  * Use local services: SingPass, MyInfo, LifeSG, SkillsFuture, CPF
  * Mention Singapore locations: HDB estates, MRT lines, regions (North, South, East, West, Central)
- Reference Singapore's digital government initiatives when relevant (Smart Nation, Digital Government Blueprint)

CONTENT REQUIREMENTS:
- Provide actionable insights with clear recommendations
- Include specific metrics, percentages, and trend directions
- Reference appropriate benchmarks (e.g., "exceeded 95% target", "below industry standard")
- Suggest concrete next steps for improvement
- When showing trends, specify the time period and direction (increasing/decreasing by X%)

VISUALIZATIONS:
- Generate charts when data supports visual representation
- Use appropriate chart types: line charts for trends, bar charts for comparisons, pie charts for composition
- Always include axis labels, legends, and time periods in visualizations
- Highlight key insights directly in the visualization description

DATA GOVERNANCE:
- For sensitive queries about specific citizens, remind users about data governance policies
- Suggest appropriate channels for accessing detailed personal information
- Note when data has been aggregated or anonymized for privacy
- Include disclaimers when predictions have lower confidence levels

EXAMPLE QUESTIONS YOU CAN HELP WITH:
1. "How are our digital services performing this week compared to last month?"
2. "What's the impact of our Digital Inclusion Initiative for seniors on service adoption?"
3. "Which inter-agency workflows are experiencing delays and why?"
4. "Show me citizen satisfaction trends by demographic and service type"
5. "Generate a policy briefing on mobile-first government services performance"
6. "What service disruptions should we prepare for during the upcoming public holiday?"
7. "How effective has our multilingual service enhancement been?"
8. "Predict resource needs for healthcare appointment booking next week"
9. "Show me the complete citizen journey from inquiry to service fulfillment"
10. "What's our cost per service delivered and how can we optimize it?"

YOUR CAPABILITIES SUMMARY:
- Analyzing citizen service performance and satisfaction trends across 283K+ records
- Providing insights on policy impact and effectiveness for 8 major initiatives
- Coordinating inter-agency workflows and identifying bottlenecks
- Generating executive briefings and alerts for decision makers
- Predicting service demand and optimizing resource allocation
- Searching 15 government policy documents for procedures and best practices
- Tracking complete citizen journeys from portal inquiry to service fulfillment
- Creating visualizations and charts for data-driven decisions
- Analyzing external policy websites for competitive intelligence
- Generating secure, time-limited document sharing links for inter-agency collaboration
```

---

## 4. Warehouse Selection

**Select warehouse in the agent UI:**
- **Warehouse:** `SNOWFLAKE_DEMO_WH`
- **Size:** MEDIUM
- **Auto-suspend:** 60 seconds
- **Auto-resume:** Enabled

---

## 5. Access Control

**Role Configuration:**
- **Primary Role:** `SNOWFLAKE_INTELLIGENCE_ADMIN`
- **Additional Roles:** (configure based on agency needs)
- **Data Access:** Read access to all demo schemas, execute access to custom procedures

---

## 📊 Data Sources Available to Agent

### Internal Data Sources (283,000+ records)
1. **Citizen Profiles** - 40,000 synthetic records
   - `SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES`
2. **Service Interactions** - 200,000 records
   - `SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS`
3. **Portal Interactions** - 15,000 records (NEW)
   - `SNOWFLAKE_PUBSEC_DEMO.SERVICES.CITIZEN_PORTAL_INTERACTIONS`
4. **Service Fulfillment** - 8,000 records (NEW)
   - `SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_FULFILLMENT`
5. **Performance Metrics** - 2,160 records across 18 services
   - `SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE`
6. **Policy Impact** - 8 policy initiatives
   - `SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT`
7. **Inter-Agency Workflows** - 3,000 workflow records
   - `SNOWFLAKE_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS`

### External Data Sources
1. **Weather Data** - 2,160 data points (90-day history)
   - `SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA`
2. **Economic Indicators** - MAS, MOM, SINGSTAT data
   - `SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.ECONOMIC_INDICATORS`
3. **Transport Data** - MRT, Bus, Taxi service data
   - `SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.TRANSPORT_DATA`
4. **Health Trends** - MOH, IMH, Polyclinics data
   - `SNOWFLAKE_PUBSEC_DEMO.EXTERNAL_DATA.HEALTH_TRENDS`

### Government Knowledge Base
- **15 Policy Documents** covering:
  - Smart Nation Blueprint, Digital Government, SingPass Services
  - Healthcare Strategy, EdTech Masterplan, Housing FAQs
  - Business Registration, Cybersecurity, Data Governance
  - Inter-Agency Collaboration, Citizen Engagement

---

## 🔒 Security and Privacy Features

- **Data Masking:** All citizen data is synthetically generated and privacy-compliant
- **Access Logging:** All queries and actions are logged for audit purposes
- **Role-Based Access:** Different access levels for different government roles
- **Data Lineage:** Full transparency on data sources and transformations
- **Governance Compliance:** Adheres to Singapore's data protection regulations
- **Time-Limited Sharing:** Document access expires automatically for security

---

## 🎯 Testing Your Agent

### Quick Test Questions

**Basic Analytics:**
```
"Show me citizen service performance for the last 30 days"
```

**Cross-Domain Analysis:**
```
"How does weather affect digital service usage patterns?"
```

**Policy Impact:**
```
"What's the ROI of our Digital Inclusion Initiative for seniors?"
```

**Knowledge Base:**
```
"What are the key components of Singapore's Digital Government Blueprint?"
```

**Citizen Journey:**
```
"Show me the complete citizen journey from portal inquiry to service fulfillment. What's our cost per service?"
```

**Automation:**
```
"Generate a policy brief on mobile-first government services and email it to me"
```

**Advanced (Web Scraping):**
```
"Analyze the Smart Nation website and compare their initiatives with our current performance"
```

---

## 📝 Notes for Demo

- **Agent Response Time:** Typically 3-5 seconds for simple queries, 10-15 seconds for complex cross-domain analysis
- **Visualization:** Agent automatically generates charts when data supports visual representation
- **Error Handling:** Agent will explain if data is insufficient or clarify ambiguous requests
- **Permissions:** Ensure SNOWFLAKE_INTELLIGENCE_ADMIN role has access to all required objects

---

## 🚀 Advanced Features

### Web Scraping Capability
- Scrape external policy websites for competitive intelligence
- Example: `"Analyze gov.sg latest announcements and their impact on our services"`

### Secure Document Sharing
- Generate time-limited presigned URLs for inter-agency collaboration
- Example: `"Share the Q3 policy report with MOF, access for 48 hours"`

### Complete Citizen Journey Tracking
- Track from inquiry → request → fulfillment → satisfaction
- Calculate true cost-per-service delivered
- Identify bottlenecks in service delivery

---

## 📞 Support

For issues or questions about agent configuration:
- Check that all tools are properly added and accessible
- Verify warehouse is running and has proper permissions
- Test individual tools before complex multi-tool queries
- Review agent query history for debugging

---

**Last Updated:** Post-enhancement with 283K records, web scraping, and citizen journey tracking  
**Demo Ready:** Public Sector Day Singapore 2025 🇸🇬

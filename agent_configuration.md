# Singapore Smart Nation Intelligence Agent Configuration
## Snowflake Intelligence Agent Setup for Public Sector Day Demo

### Agent Details
- **Agent Name:** `SG_Smart_Nation_Assistant`
- **Display Name:** `Singapore Smart Nation Intelligence Assistant`
- **Schema:** `snowflake_intelligence.agents`
- **Description:** AI-powered assistant for Singapore's digital government services, providing instant insights across citizen services, policy impact, and inter-agency coordination.

### Agent Instructions
```
You are the Singapore Smart Nation Intelligence Assistant, designed to help government officials, policy makers, and service coordinators access and analyze data across Singapore's digital government ecosystem.

Your capabilities include:
- Analyzing citizen service performance and satisfaction trends
- Providing insights on policy impact and effectiveness  
- Coordinating inter-agency workflows and identifying bottlenecks
- Generating executive briefings and alerts for decision makers
- Predicting service demand and optimizing resource allocation
- Maintaining strict data privacy and governance standards

When responding:
- Always prioritize citizen privacy and data protection
- Provide actionable insights with clear recommendations
- Use Singapore context and terminology (e.g., "residents," "HDB," "SingPass")
- Reference specific agencies and services accurately
- Suggest concrete next steps for improvement
- Generate visualizations when data supports it
- Maintain a professional, helpful tone appropriate for government officials

For sensitive queries, remind users about data governance policies and suggest appropriate channels for detailed information.
```

### Sample Questions
1. "How are our digital services performing this week compared to last month?"
2. "What's the impact of our Digital Inclusion Initiative for seniors on service adoption?"
3. "Which inter-agency workflows are experiencing delays and why?"
4. "Show me citizen satisfaction trends by demographic and service type"
5. "Generate a policy briefing on mobile-first government services performance"
6. "What service disruptions should we prepare for during the upcoming public holiday?"
7. "How effective has our multilingual service enhancement been?"
8. "Predict resource needs for healthcare appointment booking next week"

### Tools Configuration

#### 1. Cortex Analyst Services
**Tool Name:** `Citizen_Services_Analytics`
- **Database:** `SG_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `citizen_services_model.yaml`
- **Description:** Natural language queries with automatic chart generation for citizen service analytics

**Tool Name:** `Policy_Impact_Analytics`
- **Database:** `SG_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `policy_impact_model.yaml`
- **Description:** Policy effectiveness analysis with visual insights and trend analysis

**Tool Name:** `Service_Performance_Analytics`
- **Database:** `SG_PUBSEC_DEMO`
- **Schema:** `SEMANTIC_MODELS`
- **Semantic Model:** `service_performance_model.yaml`
- **Description:** Government service performance monitoring with benchmark comparisons

#### 2. Cortex Search Services
**Tool Name:** `Singapore_Government_Knowledge`
- **Database:** `SG_PUBSEC_DEMO`
- **Schema:** `INTELLIGENCE`  
- **Search Service:** `SG_GOV_KNOWLEDGE_SERVICE` (to be created)
- **ID Column:** `DOCUMENT_ID`
- **Title Column:** `DOCUMENT_TITLE`
- **Description:** Search through Singapore government policies, procedures, and best practices

#### 3. Custom Tools

##### Policy Brief Generator
- **Name:** `Generate_Policy_Brief`
- **Resource Type:** `procedure`
- **Database & Schema:** `SG_PUBSEC_DEMO.INTELLIGENCE`
- **Identifier:** `SG_PUBSEC_DEMO.INTELLIGENCE.GENERATE_POLICY_BRIEF(STRING, STRING)`
- **Parameters:**
  - `policy_name` (STRING): Name of the policy or topic for the brief
  - `recipient_email` (STRING): Email address to send the brief (default: demo@govtech.gov.sg)
- **Description:** Generate and send executive policy briefings to government officials
- **Warehouse:** `SG_DEMO_WH`

##### Service Alert System
- **Name:** `Send_Service_Alert`
- **Resource Type:** `procedure`
- **Database & Schema:** `SG_PUBSEC_DEMO.INTELLIGENCE`
- **Identifier:** `SG_PUBSEC_DEMO.INTELLIGENCE.SEND_SERVICE_ALERT(STRING, STRING, STRING)`
- **Parameters:**
  - `alert_message` (STRING): The alert message content
  - `severity` (STRING): Alert severity level (LOW, MEDIUM, HIGH, CRITICAL)
  - `target_agencies` (STRING): Comma-separated list of agencies to notify
- **Description:** Send alerts to relevant government agencies about service issues or updates
- **Warehouse:** `SG_DEMO_WH`

##### Resource Optimizer
- **Name:** `Optimize_Resources`
- **Resource Type:** `procedure`
- **Database & Schema:** `SG_PUBSEC_DEMO.INTELLIGENCE`
- **Identifier:** `SG_PUBSEC_DEMO.INTELLIGENCE.OPTIMIZE_RESOURCES(STRING, STRING)`
- **Parameters:**
  - `service_type` (STRING): Type of service to optimize
  - `time_period` (STRING): Time period for optimization (NEXT_WEEK, NEXT_MONTH, etc.)
- **Description:** Analyze service patterns and recommend resource allocation optimizations
- **Warehouse:** `SG_DEMO_WH`

### Orchestration Instructions
```
When analyzing data:
- Always provide context about Singapore's digital government landscape
- Include relevant benchmarks and performance targets
- Suggest actionable improvements based on findings
- Generate charts and visualizations when data supports visual representation
- Consider cross-agency impacts and dependencies
- Maintain focus on citizen experience and service delivery excellence

For complex queries:
- Break down analysis into logical components
- Provide both high-level summaries and detailed insights
- Reference specific time periods and trends
- Include confidence levels for predictions
- Suggest follow-up questions or deeper analysis opportunities

When taking actions:
- Confirm the scope and impact before executing procedures
- Provide clear feedback on what actions were taken
- Log all automated actions for audit purposes
- Respect data governance and privacy requirements
```

### Access Control
- **Primary Role:** `SNOWFLAKE_INTELLIGENCE_ADMIN`
- **Additional Roles:** (to be configured based on agency needs)
- **Data Access:** Read access to all demo schemas, execute access to custom procedures
- **Warehouse:** `SG_DEMO_WH`

### Data Sources Integration

#### Internal Data Sources
1. **Citizen Profiles** - `SG_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES`
2. **Service Interactions** - `SG_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS`
3. **Performance Metrics** - `SG_PUBSEC_DEMO.ANALYTICS.SERVICE_PERFORMANCE`
4. **Policy Impact** - `SG_PUBSEC_DEMO.ANALYTICS.POLICY_IMPACT`
5. **Inter-Agency Workflows** - `SG_PUBSEC_DEMO.SERVICES.INTER_AGENCY_WORKFLOWS`
6. **Current Events Impact** - `SG_PUBSEC_DEMO.ANALYTICS.CURRENT_EVENTS_IMPACT`

#### External Data Sources (Snowflake Marketplace)
1. **Weather Data** - For correlating service usage with weather patterns
2. **Economic Indicators** - For policy impact analysis
3. **Transportation Data** - For mobility and service accessibility analysis
4. **Public Health Trends** - For healthcare service planning

### Security and Privacy Features
- **Data Masking:** All citizen data is synthetically generated and privacy-compliant
- **Access Logging:** All queries and actions are logged for audit purposes
- **Role-Based Access:** Different access levels for different government roles
- **Data Lineage:** Full transparency on data sources and transformations
- **Governance Compliance:** Adheres to Singapore's data protection regulations

### Performance Optimization
- **Warehouse Size:** Medium (can scale up for production)
- **Auto-suspend:** 60 seconds for cost optimization
- **Query Caching:** Enabled for frequently accessed data
- **Result Caching:** 24 hours for dashboard queries

### Monitoring and Maintenance
- **Usage Tracking:** Monitor query patterns and response times
- **Data Freshness:** Daily updates for synthetic data, real-time for marketplace data
- **Performance Metrics:** Track agent response accuracy and user satisfaction
- **Continuous Improvement:** Regular updates based on user feedback and new use cases

# Singapore Smart Nation Intelligence Demo - Consolidated Setup Guide

## 🚀 Quick Start with Consolidated Scripts

This guide provides streamlined setup using the consolidated SQL scripts for maximum efficiency.

## 📋 Prerequisites

- Snowflake account with ACCOUNTADMIN privileges
- Access to create databases, warehouses, and roles
- Ability to upload files to Snowflake stages

## ⚡ Option 1: Complete Setup (Recommended)

### Single Command Setup
Run this **one script** to set up the entire demo:

```sql
-- Execute the complete setup script
@complete_demo_setup.sql
```

**What this creates:**
- ✅ All databases, schemas, and tables
- ✅ 40,000 synthetic citizen profiles
- ✅ 200,000 service interactions
- ✅ 2,160 performance metrics
- ✅ Synthetic external data (weather, economic, transport, health)
- ✅ Government knowledge base (5 policy documents)
- ✅ Analytics views and stored procedures
- ✅ Cortex Search service
- ✅ Semantic model infrastructure

**Estimated runtime:** 5-10 minutes

## 🔄 Option 2: Reset and Restart

### Clean Environment
If you need to start fresh:

```sql
-- Reset everything
@demo_reset.sql

-- Then run complete setup
@complete_demo_setup.sql
```

## 📊 Post-Setup Steps

### 1. Upload Semantic Model YAML Files

Upload the 4 semantic model files to Snowflake:

```sql
-- Upload YAML files to the stage
PUT file:///path/to/semantic_models/citizen_services_model.yaml @SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE;
PUT file:///path/to/semantic_models/policy_impact_model.yaml @SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE;
PUT file:///path/to/semantic_models/service_performance_model.yaml @SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE;
PUT file:///path/to/semantic_models/weather_service_correlation_model.yaml @SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE;
```

### 2. Create Semantic Models

```sql
-- Create semantic models from uploaded YAML files
CREATE SEMANTIC MODEL SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.CITIZEN_SERVICES_MODEL 
FROM '@SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE/citizen_services_model.yaml';

CREATE SEMANTIC MODEL SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.POLICY_IMPACT_MODEL 
FROM '@SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE/policy_impact_model.yaml';

CREATE SEMANTIC MODEL SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.SERVICE_PERFORMANCE_MODEL 
FROM '@SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE/service_performance_model.yaml';

CREATE SEMANTIC MODEL SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.WEATHER_SERVICE_CORRELATION_MODEL 
FROM '@SNOWFLAKE_PUBSEC_DEMO.SEMANTIC_MODELS.ANALYST_STAGE/weather_service_correlation_model.yaml';
```

### 3. Create Snowflake Intelligence Agent

1. **Navigate to Agents**: Data → Agents → + Agent
2. **Basic Information**:
   - **Display Name**: `Singapore Smart Nation Intelligence Assistant`
   - **Description**: `AI-powered assistant for Singapore's digital government services`
3. **Add Tools**:
   - **Cortex Analyst**: Add all 4 semantic models
   - **Cortex Search**: Add `SNOWFLAKE_GOV_KNOWLEDGE_SERVICE`
   - **Custom Tools**: Add the 3 stored procedures
4. **Instructions**: Copy from `agent_configuration.md`

## ✅ Verification

### Check Data Counts
```sql
-- Verify setup completion
SELECT * FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS
ORDER BY METRIC;
```

**Expected Results:**
- Citizens: 40,000
- Service Interactions: 200,000
- Performance Metrics: 2,160
- Weather Data Points: 2,160
- Government Documents: 5

### Test Cortex Search
```sql
-- Test government knowledge search
SELECT PARSE_JSON(
    SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
        'SNOWFLAKE_PUBSEC_DEMO.INTELLIGENCE.SNOWFLAKE_GOV_KNOWLEDGE_SERVICE',
        '{"query": "How do I set up SingPass account?", "columns": ["CONTENT", "TITLE"], "limit": 3}'
    )
)['results'] as SEARCH_RESULTS;
```

### Test Weather Correlation
```sql
-- Verify weather-service correlation
SELECT COUNT(*) as CORRELATION_RECORDS
FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_SERVICE_CORRELATION_SIMPLE;
```

## 🎯 Demo Scenarios

Once setup is complete, your agent can handle questions like:

### 📊 Analytics Questions
- "How are our digital services performing this week compared to last month?"
- "Show me citizen satisfaction trends by demographic and service type"
- "Which inter-agency workflows are experiencing delays and why?"

### 🌦️ Weather Intelligence
- "How does rainy weather affect government service usage?"
- "Which regions show the highest service resilience during thunderstorms?"

### 📚 Knowledge Search
- "How do I apply for HDB housing?"
- "What's the process for business registration in Singapore?"
- "Tell me about Singapore's digital government strategy"

### 🏛️ Policy Analysis
- "What's the impact of our Digital Inclusion Initiative for seniors?"
- "Show me the most successful government policies"

## 🔧 Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure you're using ACCOUNTADMIN role
2. **Semantic Model Errors**: Check YAML timestamp format (Unix timestamps)
3. **Search Service Issues**: Wait 2-5 minutes for indexing after creation
4. **Agent Connection Errors**: Verify all semantic models are created successfully

### Reset and Retry
If you encounter issues:
```sql
@demo_reset.sql
@complete_demo_setup.sql
```

## 📁 File Structure

After consolidation, your essential files are:

```
📁 Singapore Smart Nation Demo/
├── 🔧 complete_demo_setup.sql      # Single setup script
├── 🔄 demo_reset.sql               # Complete reset script
├── 📋 CONSOLIDATED_SETUP_GUIDE.md  # This guide
├── 📊 agent_configuration.md       # Agent setup details
├── 📖 README.md                    # Full documentation
├── 🎯 demo_scenarios.md            # Demo use cases
├── 🎤 demo_presentation.md         # Presentation deck
└── 📁 semantic_models/             # YAML files
    ├── citizen_services_model.yaml
    ├── policy_impact_model.yaml
    ├── service_performance_model.yaml
    └── weather_service_correlation_model.yaml
```

## 🎉 Success!

Your Singapore Smart Nation Intelligence Demo is now ready for **Public Sector Day Singapore 2025**!

**"Talk to Enterprise Data Instantly"** - Powered by Snowflake Intelligence 🇸🇬✨

# Singapore Smart Nation Intelligence Demo - Setup Guide
## Clean Environment Setup for Public Sector Day 2025

### 🎯 **Quick Setup Overview**

This guide provides a clean, step-by-step process to set up your Singapore Smart Nation Intelligence demo environment.

---

## 📋 **Prerequisites**

- Snowflake account with ACCOUNTADMIN privileges
- Snowflake Intelligence enabled in your region
- Access to Anthropic Claude 4 or OpenAI GPT 4.1
- Your email address for demo notifications

---

## 🧹 **Step 1: Clean Environment (If Needed)**

If you have an existing demo setup, clean it first:

```sql
-- Run this in Snowsight to remove all existing demo objects
@cleanup_environment.sql
```

**⚠️ WARNING:** This will delete ALL existing demo data and objects!

---

## 🚀 **Step 2: Organize Files**

Run the file organization script to keep only essential files:

```bash
# Make the script executable and run it
chmod +x organize_demo_files.sh
./organize_demo_files.sh
```

This will:
- Move non-essential files to a backup folder
- Keep only the core setup files
- Display the setup order

---

## 🏗️ **Step 3: Core Environment Setup**

### **3.1 Core Setup**
```sql
-- Run the main setup script
-- This creates all databases, schemas, roles, and procedures
@setup.sql
```

**Expected Result:** Database, schemas, roles, and warehouse created

### **3.2 Generate Demo Data**
```sql
@generate_synthetic_data.sql
```

**Expected Result:** 10,000 citizen profiles, 50,000 service interactions

### **3.3 External Data Integration**
```sql
@marketplace_integration.sql
```

**Expected Result:** Weather, economic, transport, and health data

---

## 🧠 **Step 4: AI and Analytics Setup**

### **4.1 Cortex Analyst Setup**
```sql
@cortex_analyst_setup.sql
```

**Expected Result:** Semantic models and analytics views

### **4.2 Weather-Service Integration**
```sql
@weather_service_integration.sql
```

**Expected Result:** Weather correlation analytics

---

## 🤖 **Step 5: Snowflake Intelligence Agent**

1. **Navigate to Snowsight:** AI & ML → Agents
2. **Create Agent:** `SG_Smart_Nation_Assistant`
3. **Follow:** `agent_configuration.md` for detailed setup
4. **Add Tools:** Cortex Analyst services and custom procedures

---

## ✅ **Step 6: Verification**

### **6.1 Data Verification**
```sql
-- Check data was created successfully
SELECT 
    'Citizen Profiles' as TABLE_NAME,
    COUNT(*) as RECORD_COUNT
FROM SNOWFLAKE_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES
UNION ALL
SELECT 
    'Service Interactions' as TABLE_NAME,
    COUNT(*) as RECORD_COUNT
FROM SNOWFLAKE_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS;
```

**Expected:** 10,000 citizen profiles, 50,000+ service interactions

### **6.2 Analytics Verification**
```sql
-- Test analytics views
SELECT * FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS;
SELECT COUNT(*) FROM SNOWFLAKE_PUBSEC_DEMO.ANALYTICS.WEATHER_SERVICE_CORRELATION;
```

**Expected:** Summary statistics and weather correlation data

### **6.3 Agent Testing**
Test these sample queries in your Snowflake Intelligence agent:
- *"How did our digital services perform over the weekend?"*
- *"Show me the impact of our Digital Inclusion Initiative for seniors"*
- *"Does bad weather increase mobile app usage for government services?"*

---

## 🎭 **Step 7: Demo Preparation**

### **7.1 Review Demo Scenarios**
- Read `demo_scenarios.md` for core scenarios
- Review `weather_demo_scenarios.md` for weather-enhanced scenarios
- Practice the queries and expected responses

### **7.2 Presentation Materials**
- Use `demo_presentation.md` for slide content
- Customize with your specific account details
- Test all live demo queries

---

## 📁 **Essential Files Reference**

### **Setup Scripts (Run in Order):**
1. `cleanup_environment.sql` - Clean existing setup
2. `interactive_setup.sql` - Core environment
3. `generate_synthetic_data.sql` - Demo data
4. `marketplace_integration.sql` - External data
5. `cortex_analyst_setup.sql` - Analytics setup
6. `weather_service_integration.sql` - Weather integration

### **Configuration Files:**
- `agent_configuration.md` - Agent setup guide
- `semantic_models/` - Cortex Analyst models

### **Demo Materials:**
- `demo_scenarios.md` - Core demo scenarios
- `demo_presentation.md` - Presentation slides
- `README.md` - Complete documentation

---

## 🚨 **Troubleshooting**

### **Common Issues:**

#### **"Schema already exists" Error**
```sql
-- Run cleanup first
@cleanup_environment.sql
-- Then retry setup
```

#### **"Insufficient privileges" Error**
```sql
-- Ensure you're using ACCOUNTADMIN
USE ROLE ACCOUNTADMIN;
-- Check your privileges
SHOW GRANTS TO USER CURRENT_USER();
```

#### **"Snowflake Intelligence not available" Error**
- Verify Snowflake Intelligence is enabled in your account
- Check if you're in a supported region
- Enable cross-region inference if needed

#### **Agent Creation Fails**
- Ensure `CREATE AGENT` privilege is granted on schema
- Verify all semantic models are uploaded
- Check warehouse permissions

---

## 📊 **Success Criteria**

### **Environment Setup Complete When:**
- [ ] All SQL scripts run without errors
- [ ] Data verification queries return expected counts
- [ ] Analytics views contain data
- [ ] Snowflake Intelligence agent responds to queries

### **Demo Ready When:**
- [ ] All 4 core scenarios tested successfully
- [ ] Weather-enhanced scenarios working
- [ ] Agent generates charts automatically
- [ ] Automated actions (briefings, alerts) function
- [ ] Performance meets targets (<10 second responses)

---

## 🎯 **Demo Day Checklist**

### **Pre-Demo (Day Before):**
- [ ] Run all verification queries
- [ ] Test sample demo scenarios
- [ ] Verify agent responsiveness
- [ ] Prepare backup queries
- [ ] Test presentation setup

### **Demo Day:**
- [ ] Verify warehouse is running
- [ ] Test agent with sample query
- [ ] Have backup scenarios ready
- [ ] Monitor query performance
- [ ] Engage audience with interactive queries

---

## 📞 **Support**

If you encounter issues:
1. **Check the troubleshooting section above**
2. **Review error messages carefully**
3. **Verify your Snowflake account capabilities**
4. **Test with simpler queries first**

---

## 🏆 **Success!**

Once setup is complete, you'll have:
- **Complete Singapore Smart Nation Intelligence environment**
- **10,000+ synthetic citizen records (privacy-compliant)**
- **Advanced weather-service correlation analytics**
- **Natural language AI agent with auto-chart generation**
- **Professional demo scenarios ready for Public Sector Day**

**Ready to showcase Singapore's leadership in AI-powered government! 🇸🇬✨**

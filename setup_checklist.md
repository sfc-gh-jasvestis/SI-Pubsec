# Singapore Smart Nation Intelligence Demo - Setup Checklist
## Public Sector Day Singapore 2025

## 📋 **Pre-Setup Requirements**

### **Snowflake Account Information Needed:**
- [ ] **Account Identifier** (e.g., `abc12345.us-east-1`)
- [ ] **Region** where your account is located
- [ ] **Username** with ACCOUNTADMIN privileges
- [ ] **Password** or authentication method

### **Snowflake Intelligence Prerequisites:**
- [ ] **Snowflake Intelligence enabled** in your account
- [ ] **Access to AI models** (Anthropic Claude 4 or OpenAI GPT 4.1)
- [ ] **Cross-region inference** enabled (if models not in your region)

### **Demo Configuration:**
- [ ] **Email address** for automated notifications and briefings
- [ ] **Warehouse size preference** (MEDIUM recommended for demo)

---

## 🚀 **Step-by-Step Setup Process**

### **Step 1: Account Verification**
```sql
-- Run in Snowsight to verify your setup
SELECT CURRENT_ROLE(), CURRENT_ACCOUNT(), CURRENT_REGION();
SHOW PARAMETERS LIKE 'CORTEX_ENABLED_CROSS_REGION' IN ACCOUNT;
```

### **Step 2: Update Configuration Script**
1. Open `interactive_setup.sql`
2. Replace these placeholders with your actual values:
   ```sql
   SET ACCOUNT_IDENTIFIER = 'YOUR_ACTUAL_ACCOUNT_ID';
   SET DEMO_EMAIL = 'your.email@company.com';
   SET CURRENT_USERNAME = 'YOUR_USERNAME';
   ```

### **Step 3: Run Setup Scripts in Order**
- [ ] **1. interactive_setup.sql** - Basic environment setup
- [ ] **2. generate_synthetic_data.sql** - Create demo data
- [ ] **3. marketplace_integration.sql** - External data sources

### **Step 4: Configure Snowflake Intelligence Agent**
1. Navigate to **AI & ML** → **Agents** in Snowsight
2. Click **Create agent**
3. Use configuration from `agent_configuration.md`

---

## 🔧 **Configuration Details**

### **Database Structure:**
```
SG_PUBSEC_DEMO/
├── INTELLIGENCE/          # Agent configurations
├── CITIZEN_DATA/          # Synthetic citizen profiles
├── SERVICES/              # Service interactions
├── ANALYTICS/             # Performance metrics
└── EXTERNAL_DATA/         # Marketplace data
```

### **Key Components Created:**
- **Database:** `SG_PUBSEC_DEMO`
- **Role:** `SG_INTELLIGENCE_ADMIN`
- **Warehouse:** `SG_DEMO_WH` (MEDIUM, auto-suspend 60s)
- **Service User:** `SG_INTELLIGENCE_SERVICE`

### **Data Volume:**
- **10,000** synthetic citizen profiles
- **50,000** service interaction records
- **500+** performance metrics
- **5,000** inter-agency workflow records

---

## 🛡️ **Security Configuration**

### **Role Privileges:**
- `CREATE AGENT` - For Snowflake Intelligence
- `CREATE CORTEX SEARCH SERVICE` - For search capabilities
- `EXECUTE MANAGED TASK` - For automation
- Full access to demo schemas

### **Data Privacy:**
- **100% synthetic data** - No real citizen information
- **Privacy-compliant** - Meets PDPA standards
- **Audit trail** - All queries logged
- **Role-based access** - Granular permissions

---

## ✅ **Verification Steps**

### **After Setup Completion:**
- [ ] All schemas created successfully
- [ ] Sample data loaded (verify row counts)
- [ ] Warehouse accessible and auto-suspending
- [ ] Role permissions working correctly
- [ ] Agent can be created in Snowsight

### **Test Queries:**
```sql
-- Verify data loading
SELECT COUNT(*) FROM SG_PUBSEC_DEMO.CITIZEN_DATA.CITIZEN_PROFILES;
SELECT COUNT(*) FROM SG_PUBSEC_DEMO.SERVICES.SERVICE_INTERACTIONS;

-- Test analytics views
SELECT * FROM SG_PUBSEC_DEMO.ANALYTICS.DEMO_SUMMARY_STATS;

-- Verify external data integration
SELECT COUNT(*) FROM SG_PUBSEC_DEMO.EXTERNAL_DATA.WEATHER_DATA;
```

---

## 🚨 **Common Issues & Solutions**

### **Issue: "Snowflake Intelligence not available"**
**Solution:** 
- Check if your account has Snowflake Intelligence enabled
- Verify you're in a supported region
- Enable cross-region inference if needed

### **Issue: "Insufficient privileges"**
**Solution:**
- Ensure you're using ACCOUNTADMIN role
- Check role grants with `SHOW GRANTS TO ROLE SG_INTELLIGENCE_ADMIN`

### **Issue: "Agent creation fails"**
**Solution:**
- Verify `CREATE AGENT` privilege is granted
- Check that required AI models are accessible
- Ensure proper schema permissions

### **Issue: "Data loading errors"**
**Solution:**
- Check warehouse is running
- Verify schema permissions
- Review error messages in query history

---

## 📞 **Need Help?**

### **What Information to Provide:**
1. **Account identifier** and region
2. **Error messages** (exact text)
3. **Current role** and permissions
4. **Snowflake Intelligence availability** status

### **Diagnostic Queries:**
```sql
-- Account information
SELECT CURRENT_ACCOUNT(), CURRENT_REGION(), CURRENT_ROLE();

-- Check Snowflake Intelligence
SHOW PARAMETERS LIKE '%CORTEX%' IN ACCOUNT;

-- Role privileges
SHOW GRANTS TO ROLE SG_INTELLIGENCE_ADMIN;

-- Warehouse status
SHOW WAREHOUSES LIKE 'SG_DEMO_WH';
```

---

## 🎯 **Success Criteria**

### **Setup Complete When:**
- [ ] All SQL scripts run without errors
- [ ] Data verification queries return expected counts
- [ ] Snowflake Intelligence agent can be created
- [ ] Demo scenarios can be tested successfully
- [ ] All automated procedures work correctly

### **Ready for Demo When:**
- [ ] Agent responds to sample questions
- [ ] Visualizations generate correctly
- [ ] Automated actions (briefings, alerts) function
- [ ] Performance meets targets (<10 second responses)
- [ ] All 4 demo scenarios tested and working

**Once complete, you'll be ready to showcase "Talk to Enterprise Data Instantly" at Public Sector Day Singapore 2025! 🇸🇬✨**

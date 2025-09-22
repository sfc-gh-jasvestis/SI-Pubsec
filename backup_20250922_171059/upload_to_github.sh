#!/bin/bash

# Script to upload Singapore Smart Nation Intelligence Demo to GitHub
# Repository: https://github.com/sfc-gh-jasvestis/SI-Pubsec

echo "🚀 Uploading Singapore Smart Nation Intelligence Demo to GitHub..."

# Navigate to the project directory
cd "/Users/jasvestis/SI Pubsec"

# Initialize git repository if not already done
if [ ! -d ".git" ]; then
    echo "📁 Initializing Git repository..."
    git init
    git branch -M main
fi

# Add remote origin if not already added
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "🔗 Adding GitHub remote..."
    git remote add origin https://github.com/sfc-gh-jasvestis/SI-Pubsec.git
fi

# Add all files
echo "📄 Adding all demo files..."
git add .

# Commit with descriptive message
echo "💾 Committing files..."
git commit -m "🎯 Add Singapore Smart Nation Intelligence Demo for Public Sector Day 2025

✨ Complete demo package including:
- 🏛️ Singapore Smart Nation Intelligence Agent concept
- 🗄️ Privacy-compliant synthetic data (10K citizens, 50K interactions)
- 🔗 Snowflake Marketplace data integration
- 🤖 Snowflake Intelligence agent configuration
- 🎭 4 compelling demo scenarios with live script
- 📊 Complete 17-slide presentation deck
- 📚 Comprehensive setup and deployment guide

🎯 Demo Theme: 'Talk to Enterprise Data Instantly'
🏆 Target ROI: 433% over 3 years
🛡️ 100% privacy-compliant with synthetic data
🇸🇬 Tailored for Singapore public sector audience"

# Push to GitHub
echo "⬆️ Pushing to GitHub..."
git push -u origin main

echo "✅ Upload complete! Your demo is now available at:"
echo "🔗 https://github.com/sfc-gh-jasvestis/SI-Pubsec"
echo ""
echo "📋 Files uploaded:"
echo "   • README.md - Complete setup guide"
echo "   • demo_concept.md - Strategic overview"
echo "   • setup.sql - Database setup script"
echo "   • generate_synthetic_data.sql - Privacy-compliant data"
echo "   • marketplace_integration.sql - External data sources"
echo "   • agent_configuration.md - AI agent setup"
echo "   • demo_scenarios.md - Live demo script"
echo "   • demo_presentation.md - 17-slide presentation"
echo "   • upload_to_github.sh - This upload script"
echo ""
echo "🎉 Ready for Public Sector Day Singapore 2025!"

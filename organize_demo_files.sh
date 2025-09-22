#!/bin/bash

# Organize Singapore Smart Nation Intelligence Demo Files
# This script cleans up the folder and keeps only essential files

echo "🧹 Organizing Singapore Smart Nation Intelligence Demo Files..."

# Create backup directory
mkdir -p backup_$(date +%Y%m%d_%H%M%S)
echo "📁 Created backup directory for removed files"

# Define essential files to keep
ESSENTIAL_FILES=(
    "README.md"
    "setup.sql"
    "generate_synthetic_data.sql"
    "marketplace_integration.sql"
    "cortex_analyst_setup.sql"
    "weather_service_integration.sql"
    "agent_configuration.md"
    "demo_scenarios.md"
    "demo_presentation.md"
    "cleanup_environment.sql"
    "organize_demo_files.sh"
)

# Define essential directories to keep
ESSENTIAL_DIRS=(
    "semantic_models"
)

echo "📋 Essential files to keep:"
for file in "${ESSENTIAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
    fi
done

echo ""
echo "📂 Essential directories to keep:"
for dir in "${ESSENTIAL_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir/"
    else
        echo "  ❌ $dir/ (missing)"
    fi
done

echo ""
echo "🗑️  Files to be moved to backup:"

# Move non-essential files to backup
for file in *; do
    # Skip if it's a directory we want to keep
    if [[ " ${ESSENTIAL_DIRS[@]} " =~ " ${file} " ]]; then
        continue
    fi
    
    # Skip if it's an essential file
    if [[ " ${ESSENTIAL_FILES[@]} " =~ " ${file} " ]]; then
        continue
    fi
    
    # Skip if it's the backup directory
    if [[ "$file" == backup_* ]]; then
        continue
    fi
    
    # Move to backup
    echo "  📦 Moving $file to backup"
    mv "$file" backup_*/
done

echo ""
echo "✅ File organization completed!"
echo ""
echo "📁 Current directory structure:"
ls -la

echo ""
echo "🎯 Demo Setup Order:"
echo "1. Run: cleanup_environment.sql (if needed to clean existing setup)"
echo "2. Run: setup.sql (basic environment setup)"
echo "3. Run: generate_synthetic_data.sql (create demo data)"
echo "4. Run: marketplace_integration.sql (external data sources)"
echo "5. Run: cortex_analyst_setup.sql (semantic models)"
echo "6. Run: weather_service_integration.sql (weather correlations)"
echo "7. Configure: agent_configuration.md (Snowflake Intelligence agent)"
echo "8. Test: demo_scenarios.md (verify all scenarios work)"

echo ""
echo "📚 Documentation:"
echo "• README.md - Complete setup guide"
echo "• demo_presentation.md - Presentation slides"
echo "• agent_configuration.md - Agent setup instructions"

echo ""
echo "🎉 Ready for Singapore Smart Nation Intelligence Demo setup!"

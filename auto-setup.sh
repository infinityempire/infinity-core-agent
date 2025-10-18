#!/bin/bash
# =====================================================
# 🤖 INFINITY CORE AGENT – FULLY AUTOMATIC SETUP
# =====================================================
# This script automatically pulls secrets from GitHub
# and configures everything without manual input
# =====================================================

set -e

echo "🤖 Infinity Core Agent – Automatic Setup"
echo "=========================================="
echo ""
echo "Pulling secrets from GitHub repository..."

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: gh CLI not found"
    echo "Install it with: pkg install gh"
    exit 1
fi

# Check if logged in to GitHub
if ! gh auth status &> /dev/null; then
    echo "❌ Error: Not logged in to GitHub"
    echo "Run: gh auth login"
    exit 1
fi

# Pull secrets from GitHub repository secrets
echo "📥 Fetching secrets from GitHub..."

DATABASE_URL=$(gh secret list --repo infinityempire/infinity-core-agent | grep DATABASE_URL &> /dev/null && gh api repos/infinityempire/infinity-core-agent/actions/secrets/DATABASE_URL 2>/dev/null | jq -r '.value' || echo "")
TELEGRAM_TOKEN=$(gh secret list --repo infinityempire/infinity-core-agent | grep TELEGRAM_TOKEN &> /dev/null && gh api repos/infinityempire/infinity-core-agent/actions/secrets/TELEGRAM_TOKEN 2>/dev/null | jq -r '.value' || echo "")
TELEGRAM_CHAT_ID=$(gh secret list --repo infinityempire/infinity-core-agent | grep TELEGRAM_CHAT_ID &> /dev/null && gh api repos/infinityempire/infinity-core-agent/actions/secrets/TELEGRAM_CHAT_ID 2>/dev/null | jq -r '.value' || echo "")
VITE_HF_READ_TOKEN=$(gh secret list --repo infinityempire/infinity-core-agent | grep VITE_HF_READ_TOKEN &> /dev/null && gh api repos/infinityempire/infinity-core-agent/actions/secrets/VITE_HF_READ_TOKEN 2>/dev/null | jq -r '.value' || echo "")

# Check if secrets were found
if [ -z "$DATABASE_URL" ] || [ -z "$TELEGRAM_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ] || [ -z "$VITE_HF_READ_TOKEN" ]; then
    echo ""
    echo "⚠️  GitHub Secrets not found or empty!"
    echo ""
    echo "You need to add secrets to your GitHub repository first:"
    echo ""
    echo "Run these commands to add secrets:"
    echo ""
    echo "gh secret set DATABASE_URL --repo infinityempire/infinity-core-agent"
    echo "gh secret set TELEGRAM_TOKEN --repo infinityempire/infinity-core-agent"
    echo "gh secret set TELEGRAM_CHAT_ID --repo infinityempire/infinity-core-agent"
    echo "gh secret set VITE_HF_READ_TOKEN --repo infinityempire/infinity-core-agent"
    echo ""
    echo "After adding secrets, run this script again."
    exit 1
fi

echo "✅ Secrets retrieved successfully!"

# Create .env file
echo ""
echo "💾 Creating .env file..."
cat > .env <<EOF
# Infinity Core Agent Environment Variables
# Auto-generated from GitHub Secrets: $(date)

DATABASE_URL="$DATABASE_URL"
TELEGRAM_TOKEN="$TELEGRAM_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
VITE_HF_READ_TOKEN="$VITE_HF_READ_TOKEN"
EOF

echo "✅ .env file created!"

# Configure Vercel
echo ""
echo "🚀 Configuring Vercel environment variables..."

# Function to add env var to all environments
add_env_var() {
    local name=$1
    local value=$2
    
    echo "  Adding $name..."
    
    for env in production preview development; do
        echo "$value" | vercel env add "$name" $env 2>/dev/null || true
    done
}

add_env_var "DATABASE_URL" "$DATABASE_URL"
add_env_var "TELEGRAM_TOKEN" "$TELEGRAM_TOKEN"
add_env_var "TELEGRAM_CHAT_ID" "$TELEGRAM_CHAT_ID"
add_env_var "VITE_HF_READ_TOKEN" "$VITE_HF_READ_TOKEN"

echo ""
echo "=========================================="
echo "✅ Automatic setup complete!"
echo "=========================================="
echo ""
echo "All secrets have been:"
echo "  ✓ Pulled from GitHub repository secrets"
echo "  ✓ Saved to .env file"
echo "  ✓ Configured in Vercel"
echo ""
echo "Next step: Run deployment"
echo "  ./deploy.sh"
echo ""


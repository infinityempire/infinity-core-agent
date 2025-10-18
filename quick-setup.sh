#!/bin/bash
# =====================================================
# 🚀 INFINITY CORE AGENT – QUICK SETUP (ONE COMMAND)
# =====================================================
# Usage:
# ./quick-setup.sh "DATABASE_URL" "TELEGRAM_TOKEN" "TELEGRAM_CHAT_ID" "VITE_HF_READ_TOKEN"
# =====================================================

set -e

# Check if all arguments are provided
if [ $# -ne 4 ]; then
    echo "❌ Error: Missing arguments"
    echo ""
    echo "Usage:"
    echo "  ./quick-setup.sh \"DATABASE_URL\" \"TELEGRAM_TOKEN\" \"TELEGRAM_CHAT_ID\" \"VITE_HF_READ_TOKEN\""
    echo ""
    echo "Example:"
    echo "  ./quick-setup.sh \\"
    echo "    \"mysql://user:pass@host/db\" \\"
    echo "    \"123456:ABC-DEF\" \\"
    echo "    \"123456789\" \\"
    echo "    \"hf_xxxxx\""
    echo ""
    exit 1
fi

DATABASE_URL="$1"
TELEGRAM_TOKEN="$2"
TELEGRAM_CHAT_ID="$3"
VITE_HF_READ_TOKEN="$4"

echo "♾️ Infinity Core Agent – Quick Setup"
echo "=========================================="

# Create .env file
echo "💾 Creating .env file..."
cat > .env <<EOF
# Infinity Core Agent Environment Variables
# Generated: $(date)

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
    
    # Production
    echo "$value" | vercel env add "$name" production 2>/dev/null || echo "    (production already exists, skipping)"
    
    # Preview
    echo "$value" | vercel env add "$name" preview 2>/dev/null || echo "    (preview already exists, skipping)"
    
    # Development
    echo "$value" | vercel env add "$name" development 2>/dev/null || echo "    (development already exists, skipping)"
}

add_env_var "DATABASE_URL" "$DATABASE_URL"
add_env_var "TELEGRAM_TOKEN" "$TELEGRAM_TOKEN"
add_env_var "TELEGRAM_CHAT_ID" "$TELEGRAM_CHAT_ID"
add_env_var "VITE_HF_READ_TOKEN" "$VITE_HF_READ_TOKEN"

echo ""
echo "=========================================="
echo "✅ Setup complete!"
echo "=========================================="
echo ""
echo "Next step: Run deployment"
echo "  ./deploy.sh"
echo ""


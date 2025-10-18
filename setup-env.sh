#!/bin/bash
# =====================================================
# 🔐 INFINITY CORE AGENT – ENVIRONMENT SETUP SCRIPT
# =====================================================
# This script will collect all required credentials
# and automatically configure them in Vercel
# =====================================================

set -e

echo "♾️ Infinity Core Agent – Environment Setup"
echo "=========================================="
echo ""
echo "This script will help you configure all required environment variables."
echo "Please have your credentials ready:"
echo "  - Neon PostgreSQL connection URL"
echo "  - Telegram Bot Token"
echo "  - Telegram Chat ID"
echo "  - Hugging Face API Token"
echo ""
read -p "Press Enter to continue..."

# Collect credentials
echo ""
echo "📋 Step 1: Database Configuration"
echo "Get your Neon connection URL from: https://console.neon.tech"
echo "Format: mysql://user:password@host/database"
read -p "Enter DATABASE_URL: " DATABASE_URL

echo ""
echo "📋 Step 2: Telegram Bot Configuration"
echo "Get your bot token from @BotFather in Telegram"
echo "Format: 123456789:ABCdefGHIjklMNOpqrsTUVwxyz"
read -p "Enter TELEGRAM_TOKEN: " TELEGRAM_TOKEN

echo ""
echo "Get your chat ID from @userinfobot in Telegram"
echo "Format: 123456789"
read -p "Enter TELEGRAM_CHAT_ID: " TELEGRAM_CHAT_ID

echo ""
echo "📋 Step 3: Hugging Face Configuration"
echo "Get your token from: https://huggingface.co/settings/tokens"
echo "Format: hf_xxxxxxxxxxxxxxxxxx"
read -p "Enter VITE_HF_READ_TOKEN: " VITE_HF_READ_TOKEN

# Confirm
echo ""
echo "=========================================="
echo "📝 Summary of your configuration:"
echo "=========================================="
echo "DATABASE_URL: ${DATABASE_URL:0:30}..."
echo "TELEGRAM_TOKEN: ${TELEGRAM_TOKEN:0:20}..."
echo "TELEGRAM_CHAT_ID: $TELEGRAM_CHAT_ID"
echo "VITE_HF_READ_TOKEN: ${VITE_HF_READ_TOKEN:0:20}..."
echo ""
read -p "Is this correct? (y/n): " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled. Run the script again to retry."
    exit 1
fi

# Create .env file
echo ""
echo "💾 Creating .env file..."
cat > .env <<EOF
# Infinity Core Agent Environment Variables
# Generated: $(date)

DATABASE_URL="$DATABASE_URL"
TELEGRAM_TOKEN="$TELEGRAM_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
VITE_HF_READ_TOKEN="$VITE_HF_READ_TOKEN"
EOF

echo "✅ .env file created successfully!"

# Configure Vercel environment variables
echo ""
echo "🚀 Configuring Vercel environment variables..."
echo ""

# Check if vercel is installed
if ! command -v vercel &> /dev/null; then
    echo "⚠️  Vercel CLI not found. Installing..."
    npm install -g vercel
fi

# Login to Vercel if not already logged in
if ! vercel whoami &> /dev/null; then
    echo "🔐 Please login to Vercel:"
    vercel login
fi

# Add environment variables to Vercel
echo "Adding variables to production environment..."
echo "$DATABASE_URL" | vercel env add DATABASE_URL production
echo "$TELEGRAM_TOKEN" | vercel env add TELEGRAM_TOKEN production
echo "$TELEGRAM_CHAT_ID" | vercel env add TELEGRAM_CHAT_ID production
echo "$VITE_HF_READ_TOKEN" | vercel env add VITE_HF_READ_TOKEN production

echo ""
echo "Adding variables to preview environment..."
echo "$DATABASE_URL" | vercel env add DATABASE_URL preview
echo "$TELEGRAM_TOKEN" | vercel env add TELEGRAM_TOKEN preview
echo "$TELEGRAM_CHAT_ID" | vercel env add TELEGRAM_CHAT_ID preview
echo "$VITE_HF_READ_TOKEN" | vercel env add VITE_HF_READ_TOKEN preview

echo ""
echo "Adding variables to development environment..."
echo "$DATABASE_URL" | vercel env add DATABASE_URL development
echo "$TELEGRAM_TOKEN" | vercel env add TELEGRAM_TOKEN development
echo "$TELEGRAM_CHAT_ID" | vercel env add TELEGRAM_CHAT_ID development
echo "$VITE_HF_READ_TOKEN" | vercel env add VITE_HF_READ_TOKEN development

echo ""
echo "=========================================="
echo "✅ Environment setup complete!"
echo "=========================================="
echo ""
echo "Your credentials have been:"
echo "  ✓ Saved to .env file (for local development)"
echo "  ✓ Added to Vercel (for production deployment)"
echo ""
echo "Next steps:"
echo "  1. Run: ./deploy.sh"
echo "  2. Your app will be deployed to Vercel"
echo ""
echo "⚠️  SECURITY NOTE:"
echo "The .env file contains sensitive data."
echo "Make sure it's in .gitignore (already configured)"
echo ""


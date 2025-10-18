#!/bin/bash
# =====================================================
# 🔐 ADD SECRETS TO GITHUB
# =====================================================
# Run this ONCE to add your secrets to GitHub
# Then auto-setup.sh will pull them automatically
# =====================================================

echo "🔐 Adding secrets to GitHub repository"
echo "=========================================="
echo ""
echo "This will prompt you for each secret and add it to GitHub."
echo "After this, you can use auto-setup.sh to pull them automatically."
echo ""

# Add DATABASE_URL
echo "📋 Enter DATABASE_URL (from Neon):"
gh secret set DATABASE_URL --repo infinityempire/infinity-core-agent

# Add TELEGRAM_TOKEN
echo ""
echo "📋 Enter TELEGRAM_TOKEN (from @BotFather):"
gh secret set TELEGRAM_TOKEN --repo infinityempire/infinity-core-agent

# Add TELEGRAM_CHAT_ID
echo ""
echo "📋 Enter TELEGRAM_CHAT_ID (from @userinfobot):"
gh secret set TELEGRAM_CHAT_ID --repo infinityempire/infinity-core-agent

# Add VITE_HF_READ_TOKEN
echo ""
echo "📋 Enter VITE_HF_READ_TOKEN (from Hugging Face):"
gh secret set VITE_HF_READ_TOKEN --repo infinityempire/infinity-core-agent

echo ""
echo "=========================================="
echo "✅ All secrets added to GitHub!"
echo "=========================================="
echo ""
echo "Now you can run:"
echo "  ./auto-setup.sh"
echo ""
echo "It will automatically pull these secrets and configure everything!"
echo ""


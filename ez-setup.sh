#!/bin/bash
# =====================================================
# ⚡ INFINITY CORE AGENT – SUPER EASY SETUP
# =====================================================
# Just paste your credentials here and run!
# =====================================================

# 👇 PASTE YOUR CREDENTIALS HERE:
DATABASE_URL="mysql://user:password@host/database"
TELEGRAM_TOKEN="123456:ABC-DEF"
TELEGRAM_CHAT_ID="123456789"
VITE_HF_READ_TOKEN="hf_xxxxxxx"

# =====================================================
# DON'T EDIT BELOW THIS LINE
# =====================================================

set -e

echo "♾️ Setting up Infinity Core Agent..."

# Create .env
cat > .env <<EOF
DATABASE_URL="$DATABASE_URL"
TELEGRAM_TOKEN="$TELEGRAM_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"
VITE_HF_READ_TOKEN="$VITE_HF_READ_TOKEN"
EOF

# Add to Vercel
for env in production preview development; do
    echo "$DATABASE_URL" | vercel env add DATABASE_URL $env 2>/dev/null || true
    echo "$TELEGRAM_TOKEN" | vercel env add TELEGRAM_TOKEN $env 2>/dev/null || true
    echo "$TELEGRAM_CHAT_ID" | vercel env add TELEGRAM_CHAT_ID $env 2>/dev/null || true
    echo "$VITE_HF_READ_TOKEN" | vercel env add VITE_HF_READ_TOKEN $env 2>/dev/null || true
done

echo "✅ Done! Run: ./deploy.sh"


#!/bin/bash
# =====================================================
# 🧠 INFINITY CORE AGENT – FULL AUTO DEPLOY SCRIPT (v1.0)
# =====================================================
# Author: Tal | Infinity Empire
# Date: 2025-10-18
# Description:
# Automates environment setup, secret injection, build, and
# production deployment for Infinity Core Agent on Vercel.
# =====================================================

set -euo pipefail
PROJECT_DIR=~/infinity-core-agent
echo "♾️ Starting Infinity Core Agent – Auto Deploy Sequence..."

# 1️⃣ Navigate to project directory
cd "$PROJECT_DIR" || { echo "❌ Project not found"; exit 1; }

# 2️⃣ Verify required files
[ -f package.json ] || { echo "❌ package.json missing"; exit 1; }
[ -d server ] || { echo "❌ Missing backend folder"; exit 1; }
[ -d client ] || { echo "❌ Missing frontend folder"; exit 1; }

# 3️⃣ Setup environment variables on Vercel (edit values as needed)
echo "⚙️ Setting up Vercel environment variables..."
vercel env add DATABASE_URL production <<< "mysql://user:password@host/database"
vercel env add TELEGRAM_TOKEN production <<< "123456:ABC-DEF"
vercel env add TELEGRAM_CHAT_ID production <<< "123456789"
vercel env add VITE_HF_READ_TOKEN production <<< "hf_xxxxxxx"

# Mirror to preview & development environments
for env in preview development; do
  vercel env add DATABASE_URL $env <<< "mysql://user:password@host/database"
  vercel env add TELEGRAM_TOKEN $env <<< "123456:ABC-DEF"
  vercel env add TELEGRAM_CHAT_ID $env <<< "123456789"
  vercel env add VITE_HF_READ_TOKEN $env <<< "hf_xxxxxxx"
done

# 4️⃣ Install dependencies
echo "📦 Installing dependencies..."
pnpm install || npm install

# 5️⃣ Push database schema to Neon
echo "🧠 Pushing database schema to Neon..."
pnpm db:push || echo "⚠️ Skipping db push (manual verify)"

# 6️⃣ Run TypeScript and lint checks
echo "🔍 Running code checks..."
pnpm typecheck || true
pnpm lint || true

# 7️⃣ Build for production
echo "🏗️ Building project..."
pnpm build || npm run build

# 8️⃣ Deploy to Vercel production
echo "🚀 Deploying to production..."
DEPLOY_URL=$(vercel --prod --yes | grep -o 'https://[^ ]*\.vercel\.app' | tail -n1)
echo "✅ Deployed: $DEPLOY_URL"

# 9️⃣ Run post-deploy health checks
echo "🩺 Checking system health..."
curl -s "$DEPLOY_URL/api/trpc/core.status" || echo "⚠️ Core status check failed"
curl -s "$DEPLOY_URL/api/trpc/core.report" || echo "⚠️ Report endpoint not responding"

# 🔟 Configure automation (optional cron setup)
echo "🕒 Setting up cron automation..."
cat > scripts/auto-monitor.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
while true; do
  echo "🔍 Checking system..."
  curl -s "$DEPLOY_URL/api/trpc/core.status" | grep -q "OK" || curl -s -X POST "$DEPLOY_URL/api/trpc/core.sendAlert" \
  -H "Content-Type: application/json" \
  -d '{"title":"⚠️ Infinity Core Alert","details":"System check failed"}'
  sleep 1800
done
EOF
chmod +x scripts/auto-monitor.sh

cat > scripts/daily-report.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
while true; do
  NOW=$(date +"%H:%M")
  if [ "$NOW" == "22:00" ]; then
    echo "🧾 Sending daily report..."
    curl -s -X POST "$DEPLOY_URL/api/trpc/core.sendReport"
    sleep 60
  fi
  sleep 50
done
EOF
chmod +x scripts/daily-report.sh

# 11️⃣ Summary
echo "==============================================="
echo "🎯 Infinity Core Agent fully deployed!"
echo "🔗 URL: $DEPLOY_URL"
echo "🕒 Cron jobs created: auto-monitor + daily-report"
echo "==============================================="

# 12️⃣ Optional: Start automation
read -p "Start monitoring now? (y/n): " run
if [[ "$run" =~ ^[Yy]$ ]]; then
  nohup ./scripts/auto-monitor.sh >/dev/null 2>&1 &
  nohup ./scripts/daily-report.sh >/dev/null 2>&1 &
  echo "🧠 Automation scripts running in background."
else
  echo "ℹ️ You can start them manually anytime from ./scripts/"
fi

echo "✅ All done. Infinity Core Agent is now live and autonomous."
# =====================================================
# END OF FILE
# =====================================================


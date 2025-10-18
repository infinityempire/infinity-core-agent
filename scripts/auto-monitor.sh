#!/bin/bash

# Infinity Core Agent - Auto Monitor Script
# Runs every 30 minutes to check system health

API_BASE_URL="${API_BASE_URL:-http://localhost:3000}"
FAILURE_COUNT_FILE="/tmp/infinity-core-failures.txt"

# Initialize failure counter
if [ ! -f "$FAILURE_COUNT_FILE" ]; then
    echo "0" > "$FAILURE_COUNT_FILE"
fi

FAILURES=$(cat "$FAILURE_COUNT_FILE")

echo "=== Infinity Core Agent Monitor ==="
echo "Time: $(date)"
echo "Checking system health..."

# Check Infinity Agent health
echo "1. Checking Infinity Agent..."
INFINITY_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${INFINITY_AGENT_URL:-https://infinity-agent.vercel.app}/api/healthz" || echo "000")

# Check Argus Cloud status
echo "2. Checking Argus Cloud..."
ARGUS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "${ARGUS_CLOUD_URL:-https://argus-cloud.vercel.app}/api/ping" || echo "000")

# Check Neon DB connection
echo "3. Checking Neon DB..."
DB_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$API_BASE_URL/api/trpc/core.status" || echo "000")

# Determine if any check failed
FAILED=0
if [ "$INFINITY_STATUS" != "200" ]; then
    echo "❌ Infinity Agent check failed (HTTP $INFINITY_STATUS)"
    FAILED=1
fi

if [ "$ARGUS_STATUS" != "200" ]; then
    echo "❌ Argus Cloud check failed (HTTP $ARGUS_STATUS)"
    FAILED=1
fi

if [ "$DB_STATUS" != "200" ]; then
    echo "❌ Neon DB check failed (HTTP $DB_STATUS)"
    FAILED=1
fi

# Handle failures
if [ $FAILED -eq 1 ]; then
    FAILURES=$((FAILURES + 1))
    echo "$FAILURES" > "$FAILURE_COUNT_FILE"
    echo "⚠️  Failure count: $FAILURES"
    
    # Send Telegram alert
    curl -s -X POST "$API_BASE_URL/api/trpc/core.sendAlert" \
        -H "Content-Type: application/json" \
        -d "{\"title\":\"System Health Check Failed\",\"details\":\"Infinity Agent: $INFINITY_STATUS, Argus Cloud: $ARGUS_STATUS, Neon DB: $DB_STATUS\"}"
    
    # If failures repeat twice, trigger rebuild
    if [ $FAILURES -ge 2 ]; then
        echo "🔄 Triggering rebuild/deploy due to repeated failures..."
        # Add rebuild logic here if needed
    fi
else
    echo "✅ All systems operational"
    # Reset failure counter
    echo "0" > "$FAILURE_COUNT_FILE"
fi

echo "=== Monitor check complete ==="


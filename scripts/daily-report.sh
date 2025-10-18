#!/bin/bash

# Infinity Core Agent - Daily Report Sender
# Sends daily report to Telegram at 22:00

API_BASE_URL="${API_BASE_URL:-http://localhost:3000}"

echo "=== Infinity Core Agent - Daily Report ==="
echo "Time: $(date)"
echo "Sending daily report to Telegram..."

# Send report via API
RESPONSE=$(curl -s -X POST "$API_BASE_URL/api/trpc/core.sendReport" \
    -H "Content-Type: application/json")

echo "Response: $RESPONSE"
echo "=== Report sent ==="


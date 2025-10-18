# 🧠 Infinity Core Agent

Central control unit for all Infinity systems - managing memory, status, automation, and orchestration across all agents.

## 🎯 Overview

Infinity Core Agent serves as the **main brain** of the Infinity Empire, coordinating:
- **Infinity Agent** (React + Hugging Face)
- **Argus Cloud** (FastAPI + Groq)
- **Neon PostgreSQL** (Long-term memory)
- **Telegram Bot** (Notifications & reports)

## 🚀 Features

### 1. Memory Layer (Neon PostgreSQL)
- Stores all agent interaction logs
- Endpoints: `/api/trpc/memory.store`, `/api/trpc/memory.history`

### 2. Agent Management
- Command & control for all sub-agents
- Endpoints: `/api/trpc/core.command`, `/api/trpc/core.status`

### 3. Integrations
- Hugging Face API (via `VITE_HF_READ_TOKEN`)
- Telegram Bot (via `TELEGRAM_TOKEN`)
- Neon PostgreSQL (via `DATABASE_URL`)

### 4. Automation Loop
- Auto-monitor script (`scripts/auto-monitor.sh`) runs every 30 minutes
- Checks health of all systems
- Sends Telegram alerts on failures
- Auto-triggers rebuild after 2 consecutive failures

### 5. Daily Reports
- Automated daily report at 22:00
- Sent to Telegram with system status and uptime
- Endpoint: `/api/trpc/core.report`

## 📋 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/trpc/memory.store` | POST | Store interaction logs |
| `/api/trpc/memory.history` | GET | Retrieve memory by agent |
| `/api/trpc/core.command` | POST | Send commands to agents |
| `/api/trpc/core.status` | GET | Get system status |
| `/api/trpc/core.report` | GET | Get daily report |
| `/api/trpc/core.sendReport` | POST | Send report to Telegram |
| `/api/trpc/core.sendAlert` | POST | Send alert to Telegram |

## 🔧 Environment Variables

Required secrets (configure in Vercel):
- `DATABASE_URL` - Neon PostgreSQL connection string
- `TELEGRAM_TOKEN` - Telegram Bot API token
- `TELEGRAM_CHAT_ID` - Telegram chat ID for notifications
- `VITE_HF_READ_TOKEN` - Hugging Face API token

## 🛠️ Development

```bash
# Install dependencies
pnpm install

# Push database schema
pnpm db:push

# Start dev server
pnpm dev
```

## 📦 Deployment

Deploy to Vercel with the included configuration:

```bash
# Deploy
vercel --prod
```

## 🤖 Automation Scripts

### Auto-Monitor (Every 30 minutes)
```bash
./scripts/auto-monitor.sh
```

### Daily Report (22:00)
```bash
./scripts/daily-report.sh
```

## 🔒 Security

- No hardcoded secrets or tokens
- All sensitive data via environment variables
- CORS restricted to Infinity systems
- Encrypted logs in Neon DB

## 📊 System Architecture

```
Infinity Core Agent (Brain)
    ├── Memory Layer (Neon DB)
    ├── Agent Manager
    │   ├── Infinity Agent
    │   ├── Argus Cloud
    │   └── Future Agents
    ├── Integrations
    │   ├── Telegram Bot
    │   └── Hugging Face
    └── Automation
        ├── Health Monitoring
        └── Daily Reports
```

## 🎯 Final Goal

- **Master orchestrator** for all Infinity systems
- **Seamless API communication** between agents
- **Long-term memory** via Neon PostgreSQL
- **Real-time notifications** via Telegram
- **Full auto-repair** with QA loops

---

**Infinity Empire | Tal | 2025**


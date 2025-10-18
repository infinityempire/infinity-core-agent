# 📱 TERMUX DEPLOYMENT INSTRUCTIONS

## 🎯 How to Run the Deploy Script in Termux

### Step 1: Install Required Tools in Termux
```bash
# Update packages
pkg update && pkg upgrade -y

# Install Node.js and pnpm
pkg install nodejs -y
npm install -g pnpm

# Install Vercel CLI
npm install -g vercel

# Install git (if needed)
pkg install git -y
```

### Step 2: Clone/Download the Project
```bash
# Go to home directory
cd ~

# If you have the project locally, navigate to it
# OR clone from repository:
# git clone <your-repo-url> infinity-core-agent

# Navigate to project
cd ~/infinity-core-agent
```

### Step 3: Edit Environment Variables
**IMPORTANT:** Before running the script, edit `deploy.sh` and replace the placeholder values:

```bash
# Use nano or vi to edit
nano deploy.sh
```

Replace these lines (around line 25-28):
```bash
# FROM:
vercel env add DATABASE_URL production <<< "mysql://user:password@host/database"
vercel env add TELEGRAM_TOKEN production <<< "123456:ABC-DEF"
vercel env add TELEGRAM_CHAT_ID production <<< "123456789"
vercel env add VITE_HF_READ_TOKEN production <<< "hf_xxxxxxx"

# TO (with your real values):
vercel env add DATABASE_URL production <<< "mysql://YOUR_REAL_NEON_URL"
vercel env add TELEGRAM_TOKEN production <<< "YOUR_REAL_TELEGRAM_TOKEN"
vercel env add TELEGRAM_CHAT_ID production <<< "YOUR_REAL_CHAT_ID"
vercel env add VITE_HF_READ_TOKEN production <<< "YOUR_REAL_HF_TOKEN"
```

Do the same for the `for env in preview development` loop (lines 31-36).

### Step 4: Login to Vercel
```bash
# Login to Vercel account
vercel login
```
Follow the prompts to authenticate.

### Step 5: Run the Deploy Script
```bash
# Make sure you're in the project directory
cd ~/infinity-core-agent

# Run the deployment script
./deploy.sh
```

### Step 6: Monitor the Deployment
The script will:
1. ✅ Verify project files
2. ⚙️ Set up environment variables
3. 📦 Install dependencies
4. 🧠 Push database schema
5. 🔍 Run code checks
6. 🏗️ Build the project
7. 🚀 Deploy to Vercel
8. 🩺 Run health checks
9. 🕒 Set up automation scripts

---

## 🔑 Where to Get Your Credentials

### DATABASE_URL (Neon PostgreSQL)
1. Go to https://console.neon.tech
2. Select your project
3. Click "Connection Details"
4. Copy the MySQL-compatible connection string
5. Format: `mysql://user:password@host/database`

### TELEGRAM_TOKEN
1. Open Telegram
2. Search for `@BotFather`
3. Send `/newbot`
4. Follow instructions
5. Copy the token (format: `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### TELEGRAM_CHAT_ID
1. Add your bot to a chat
2. Search for `@userinfobot` in Telegram
3. Start the bot
4. It will show your chat ID (format: `123456789`)

### VITE_HF_READ_TOKEN (Hugging Face)
1. Go to https://huggingface.co/settings/tokens
2. Click "New token"
3. Select "Read" permissions
4. Copy the token (format: `hf_xxxxxxxxxxxxxxxxxx`)

---

## 🚨 Important Notes

1. **Internet Connection:** Make sure you have stable internet in Termux
2. **Storage Permissions:** Grant Termux storage access if needed
3. **Battery:** Keep your device charged during deployment
4. **Background Execution:** Use `termux-wake-lock` to prevent sleep

---

## 🛠️ Troubleshooting

### Error: "vercel: command not found"
```bash
npm install -g vercel
```

### Error: "pnpm: command not found"
```bash
npm install -g pnpm
```

### Error: "Permission denied"
```bash
chmod +x deploy.sh
```

### Error: "Project not found"
```bash
# Make sure you're in the right directory
cd ~/infinity-core-agent
pwd  # Should show: /data/data/com.termux/files/home/infinity-core-agent
```

---

## 📂 Project Structure in Termux

```
/data/data/com.termux/files/home/
└── infinity-core-agent/
    ├── deploy.sh              ← The deployment script
    ├── package.json
    ├── server/
    ├── client/
    ├── drizzle/
    └── scripts/
        ├── auto-monitor.sh    ← Created by deploy script
        └── daily-report.sh    ← Created by deploy script
```

---

## ✅ After Successful Deployment

You'll see:
```
🎯 Infinity Core Agent fully deployed!
🔗 URL: https://your-app.vercel.app
🕒 Cron jobs created: auto-monitor + daily-report
```

The script will ask if you want to start monitoring. Type `y` to start automation in background.

---

## 🔄 Manual Automation Start (if you chose 'n')

```bash
# Start monitoring in background
nohup ./scripts/auto-monitor.sh > /dev/null 2>&1 &

# Start daily reports in background
nohup ./scripts/daily-report.sh > /dev/null 2>&1 &

# Check if they're running
ps aux | grep monitor
```

---

## 🛑 Stop Background Scripts

```bash
# Find process IDs
ps aux | grep monitor
ps aux | grep daily-report

# Kill them
kill <PID>
```

---

**Ready to deploy? Follow the steps above!** 🚀


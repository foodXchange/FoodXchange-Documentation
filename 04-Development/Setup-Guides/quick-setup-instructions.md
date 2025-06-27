# FoodXchange Documentation - Quick Setup Instructions

## 🚀 Initial Setup (One-Time Only)

### Step 1: Run Documentation Structure Script
1. Open PowerShell as Administrator
2. Navigate to: \C:\Users\foodz\Documents\GitHub\Development\
3. Run the structure creation script

### Step 2: Run This Script
After structure is created, run this script to create all documentation files.

### Step 3: Copy Existing Scripts
\\\powershell
# Copy your existing scripts to the Scripts folder
Copy-Item ".\FoodXchange-Diagnostic.ps1" ".\FoodXchange-Docs\03-Scripts\PowerShell\"
Copy-Item ".\FoodXchange-Manager.ps1" ".\FoodXchange-Docs\03-Scripts\PowerShell\"
\\\

## 📅 Daily Workflow

### Morning Routine (2 minutes)
\\\powershell
# 1. Navigate to docs
cd "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs"

# 2. Create today's log
\ = Get-Date -Format "yyyy-MM-dd"
Copy-Item ".\01-Progress\Templates\daily-log-template.md" ".\01-Progress\Daily-Logs\\.md"

# 3. Open it
code ".\01-Progress\Daily-Logs\\.md"
\\\

### Before AI Chat Session (1 minute)
\\\powershell
# Update and copy current status
code ".\01-Progress\current-status.md"

# Create new session file
\ = "\2025-06-27-0824-session.md"
New-Item ".\01-Progress\Chat-Sessions\\"
\\\

### After Work Session (2 minutes)
\\\powershell
# Quick commit
git add .
git commit -m "Progress: [what you worked on today]"

# Optional: Run backup
.\03-Scripts\Utilities\backup-project.ps1 -BackupType Code -Message "After implementing X feature"
\\\

## 🔄 Version Control Basics

### First Time Git Setup
\\\powershell
# If you haven't set up Git yet
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

# In your docs folder
cd "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs"
git init
git add .
git commit -m "Initial documentation setup"
\\\

## 📝 What to Document

### In Daily Logs
- What you planned to do
- What you actually did
- Any blockers or issues
- Time spent

### In Chat Sessions
- The context/state you provided to AI
- Main tasks discussed
- Code/scripts created
- Decisions made
- Next steps

---
**Remember**: This system is here to help you, not create extra work. Keep it simple and consistent!

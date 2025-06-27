# FoodXchange Chat Continuation Template

## Quick Start Message for New Chat

Copy and paste this at the beginning of your new chat:

---

I'm continuing work on my FoodXchange B2B platform. Here's my current state:

**Project**: FoodXchange - B2B Food Trading Platform
**Developer**: Udi Stryk (foodz)
**Previous Session**: [DATE]

## Current Setup
- **Frontend**: React 18 app at `C:\Users\foodz\Documents\GitHub\Development\FoodXchange`
- **Backend**: Node.js/Express at `C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend`
- **Documentation**: `C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation`

## Last Working On
[Describe what you were working on]

## Current Issue/Goal
[What you want to accomplish in this session]

## Key Context
- Using MongoDB for database
- Implementing Azure AI services for supplier matching
- Multi-language support (Hebrew, English, German, French)
- Role-based access: Buyer, Seller, Admin, Contractor, Agent

Please help me continue from where I left off.

---

## Detailed State Document Template

### 📊 Repository Status
- **Frontend Branch**: [branch name]
- **Backend Branch**: [branch name]
- **Last Frontend Commit**: [commit message]
- **Last Backend Commit**: [commit message]

### ✅ Completed Features
- Basic authentication system (JWT)
- Role-based access control
- Product catalog CRUD
- RFQ management system
- Company profiles

### 🔄 In Progress
- [ ] AI supplier matching integration
- [ ] Multi-language support
- [ ] Payment integration
- [ ] Advanced analytics

### 🐛 Current Issues
1. [Issue description]
2. [Issue description]

### 📝 Session Goals
1. [Goal 1]
2. [Goal 2]
3. [Goal 3]

### 🔧 Environment Status
- MongoDB: Port 27017
- Backend API: Port 5000
- Frontend: Port 3000
- Node version: [version]
- NPM version: [version]

### 💡 Important Notes
[Any specific notes or reminders]

---

## Quick Commands Reference

### Start Everything
```powershell
# Run the continuation script
.\FoodXchange-State\continue_session.ps1
```

### Generate New State
```powershell
# From your docs directory
.\03-Scripts\Utilities\FoodXchange-State-Generator.ps1
```

### Manual Start
```bash
# Terminal 1
mongod

# Terminal 2
cd Foodxchange-backend
npm start

# Terminal 3
cd FoodXchange
npm start
```

### Git Sync All
```bash
# Frontend
cd FoodXchange && git add . && git commit -m "Update" && git push

# Backend
cd Foodxchange-backend && git add . && git commit -m "Update" && git push

# Docs
cd FoodXchange-Documentation && git add . && git commit -m "Update" && git push
```

---

## Attachments Checklist
When starting a new session, consider attaching:
- [ ] Latest state document (from FoodXchange-State/sessions/)
- [ ] Any error logs or screenshots
- [ ] Specific code files you're working on
- [ ] Design mockups or requirements

---

*Remember: The more context you provide, the better I can help you continue your work!*

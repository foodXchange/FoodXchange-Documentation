# FoodXchange - Create All Documentation Files
# This script creates all documentation files, templates, and guides in their proper folders

param(
    [string]$BasePath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs"
)

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║       FoodXchange - Creating All Documentation Files          ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Ensure base path exists
if (-not (Test-Path $BasePath)) {
    Write-Host "❌ Base path not found: $BasePath" -ForegroundColor Red
    Write-Host "Please run the structure creation script first!" -ForegroundColor Yellow
    exit
}

Set-Location $BasePath
Write-Host "📁 Working in: $BasePath" -ForegroundColor Gray

# Counter for created files
$filesCreated = 0

# Function to create file with content
function Create-DocFile {
    param(
        [string]$Path,
        [string]$Content
    )
    
    $fullPath = Join-Path $BasePath $Path
    
    # Create directory if it doesn't exist
    $directory = Split-Path $fullPath -Parent
    if (-not (Test-Path $directory)) {
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
    }
    
    # Create file
    $Content | Out-File -FilePath $fullPath -Encoding UTF8 -Force
    Write-Host "✅ Created: $Path" -ForegroundColor Green
    $script:filesCreated++
}

# 1. Create Progress Tracking Guide
$progressGuideContent = @"
# FoodXchange Progress Tracking Guide

## 🎯 Overview

This guide explains how to effectively track your FoodXchange project progress and maintain continuity across development sessions.

## 📂 Folder Structure Explained

\`\`\`
FoodXchange-Docs/
├── 01-Progress/           # Your daily work tracking
│   ├── Daily-Logs/       # Daily development logs
│   ├── Weekly-Summaries/ # Weekly progress summaries
│   ├── Milestones/       # Major milestone achievements
│   └── Chat-Sessions/    # AI assistant session logs
├── 02-Architecture/      # Technical documentation
├── 03-Scripts/          # All your PowerShell scripts
├── 04-Development/      # Setup and development guides
├── 05-Backups/         # Version snapshots
├── 06-Planning/        # Project planning docs
└── 07-Resources/       # Reference materials
\`\`\`

## 📝 Daily Workflow

### 1. Start of Day
\`\`\`powershell
# Navigate to your docs folder
cd "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs"

# Create today's log
\$date = Get-Date -Format "yyyy-MM-dd"
Copy-Item "01-Progress\Templates\daily-log-template.md" "01-Progress\Daily-Logs\\$date.md"
\`\`\`

### 2. Before Starting an AI Chat Session
1. Open \`01-Progress/current-status.md\`
2. Update with latest status
3. Copy the content to share with AI

### 3. During AI Chat Session
1. Create a new session file
2. Document:
   - Initial context provided
   - Tasks worked on
   - Code/scripts created
   - Decisions made
   - Issues encountered

### 4. End of Session
1. Update \`current-status.md\` with progress
2. Commit changes to Git

## 🔄 Version Control Commands

### Daily Commit
\`\`\`powershell
# Stage all changes
git add .

# Commit with descriptive message
git commit -m "feat: Added RFQ schema implementation"
\`\`\`

### Create Version Tag
\`\`\`powershell
# For milestones
git tag -a v0.1.0 -m "MVP: Basic structure complete"
\`\`\`

## 📊 Weekly Summary Process

Every Friday, create a weekly summary including:
- Major accomplishments
- Challenges faced
- Decisions made
- Next week's goals
- Hours spent

## 🎯 Best Practices

1. **Commit Often**: At least once per work session
2. **Descriptive Messages**: Use conventional commits (feat:, fix:, docs:, etc.)
3. **Tag Milestones**: Make it easy to rollback
4. **Document Decisions**: Future you will thank you
5. **Include Context**: Always document WHY, not just WHAT

---
*Remember: Good documentation today saves hours of confusion tomorrow!*
"@

Create-DocFile -Path "04-Development\Guides\progress-tracking-guide.md" -Content $progressGuideContent

# 2. Create Quick Setup Instructions
$setupInstructionsContent = @"
# FoodXchange Documentation - Quick Setup Instructions

## 🚀 Initial Setup (One-Time Only)

### Step 1: Run Documentation Structure Script
1. Open PowerShell as Administrator
2. Navigate to: \`C:\Users\foodz\Documents\GitHub\Development\`
3. Run the structure creation script

### Step 2: Run This Script
After structure is created, run this script to create all documentation files.

### Step 3: Copy Existing Scripts
\`\`\`powershell
# Copy your existing scripts to the Scripts folder
Copy-Item ".\FoodXchange-Diagnostic.ps1" ".\FoodXchange-Docs\03-Scripts\PowerShell\"
Copy-Item ".\FoodXchange-Manager.ps1" ".\FoodXchange-Docs\03-Scripts\PowerShell\"
\`\`\`

## 📅 Daily Workflow

### Morning Routine (2 minutes)
\`\`\`powershell
# 1. Navigate to docs
cd "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs"

# 2. Create today's log
\$date = Get-Date -Format "yyyy-MM-dd"
Copy-Item ".\01-Progress\Templates\daily-log-template.md" ".\01-Progress\Daily-Logs\\$date.md"

# 3. Open it
code ".\01-Progress\Daily-Logs\\$date.md"
\`\`\`

### Before AI Chat Session (1 minute)
\`\`\`powershell
# Update and copy current status
code ".\01-Progress\current-status.md"

# Create new session file
\$session = "\$(Get-Date -Format 'yyyy-MM-dd-HHmm')-session.md"
New-Item ".\01-Progress\Chat-Sessions\\$session"
\`\`\`

### After Work Session (2 minutes)
\`\`\`powershell
# Quick commit
git add .
git commit -m "Progress: [what you worked on today]"

# Optional: Run backup
.\03-Scripts\Utilities\backup-project.ps1 -BackupType Code -Message "After implementing X feature"
\`\`\`

## 🔄 Version Control Basics

### First Time Git Setup
\`\`\`powershell
# If you haven't set up Git yet
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"

# In your docs folder
cd "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs"
git init
git add .
git commit -m "Initial documentation setup"
\`\`\`

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
"@

Create-DocFile -Path "04-Development\Setup-Guides\quick-setup-instructions.md" -Content $setupInstructionsContent

# 3. Create Daily Log Template
$dailyLogTemplate = @"
# Daily Log - $(Get-Date -Format "yyyy-MM-dd")

## Goals for Today
- [ ] Goal 1
- [ ] Goal 2
- [ ] Goal 3

## Work Completed
- 

## Challenges/Blockers
- 

## Notes
- 

## Tomorrow's Plan
- 

## Time Spent
- Development: X hours
- Documentation: X minutes
- Meetings/Planning: X minutes

---
*Mood: 😊 / 😐 / 😫*
*Energy Level: High / Medium / Low*
"@

Create-DocFile -Path "01-Progress\Templates\daily-log-template.md" -Content $dailyLogTemplate

# 4. Create Session Template
$sessionTemplate = @"
# AI Chat Session - $(Get-Date -Format "yyyy-MM-dd HH:mm")

## Session Info
- **Date**: $(Get-Date -Format "yyyy-MM-dd")
- **Time**: $(Get-Date -Format "HH:mm")
- **Duration**: [X hours]
- **AI Assistant**: Claude
- **Focus Area**: [Main topic worked on]

## Context Provided
\`\`\`
[Paste the state document or context you shared]
\`\`\`

## Session Goals
1. 
2. 
3. 

## Work Completed
### Tasks
- [x] Task 1
- [x] Task 2
- [ ] Task 3 (incomplete)

### Code/Scripts Created
- \`filename.ps1\` - Description of what it does
- \`config.json\` - Configuration for X

### Commands Used
\`\`\`powershell
# Important commands from session
\`\`\`

## Decisions Made
1. **Decision**: [What was decided]
   - **Reasoning**: [Why this choice]
   - **Impact**: [What it affects]

## Issues Encountered
1. **Issue**: [Problem description]
   - **Solution**: [How it was resolved]
   - **Status**: ✅ Resolved / ⚠️ Workaround / ❌ Blocked

## Key Learning
- 

## Next Steps
- [ ] Immediate next task
- [ ] Follow-up needed
- [ ] Research required

## Files to Save
- [ ] Script 1 saved to: \`03-Scripts/PowerShell/\`
- [ ] Documentation updated: \`02-Architecture/\`

## Important Links/References
- 

---
*Session Quality: Excellent / Good / Fair / Poor*
*Progress Made: Significant / Moderate / Minimal*
"@

Create-DocFile -Path "01-Progress\Templates\session-template.md" -Content $sessionTemplate

# 5. Create Weekly Summary Template
$weeklySummaryTemplate = @"
# Weekly Summary - Week $(Get-Date -Format "yyyy-'W'ww")

## Week Overview
**Start Date**: [Monday date]
**End Date**: [Friday date]
**Sprint**: [Current sprint name]

## Achievements
### Major Accomplishments
- ✅ 
- ✅ 
- ✅ 

### Tasks Completed
- [ ] Task from Monday
- [ ] Task from Tuesday
- [ ] Task from Wednesday
- [ ] Task from Thursday
- [ ] Task from Friday

## Challenges Faced
1. **Challenge**: 
   - **Impact**: 
   - **Resolution**: 

## Decisions Made
- 

## Metrics
- **Hours Worked**: X
- **Commits Made**: X
- **Features Completed**: X
- **Bugs Fixed**: X
- **Documentation Updated**: Yes/No

## Code Statistics
- Lines Added: +X
- Lines Removed: -X
- Files Changed: X

## Next Week's Goals
1. 
2. 
3. 

## Notes for Future Reference
- 

## Blockers Carried Forward
- 

---
*Week Rating: 5/5*
*Velocity: On Track / Ahead / Behind*
"@

Create-DocFile -Path "01-Progress\Templates\weekly-summary-template.md" -Content $weeklySummaryTemplate

# 6. Create Milestone Template
$milestoneTemplate = @"
# Milestone: [Milestone Name]

## Overview
**Milestone Number**: #001
**Date Achieved**: $(Get-Date -Format "yyyy-MM-dd")
**Duration**: [How long it took]
**Version Tag**: v0.1.0

## What Was Achieved
### Features Implemented
- 
- 
- 

### Technical Details
- **Frontend Changes**: 
- **Backend Changes**: 
- **Database Changes**: 
- **Infrastructure**: 

## Screenshots/Demo
[Add screenshots or demo links]

## Challenges Overcome
1. 
2. 

## Lessons Learned
- 
- 

## Performance Metrics
- Page Load Time: 
- API Response Time: 
- Database Query Time: 

## Testing Summary
- Unit Tests: X passed
- Integration Tests: X passed
- Manual Testing: Completed

## Deployment Notes
- 

## Next Milestone
**Target**: [Next milestone name]
**Planned Date**: [Date]
**Key Features**: 
- 
- 

---
*Stakeholder Approval: ✅ Yes / ❌ No*
*Production Ready: ✅ Yes / ⚠️ With conditions / ❌ No*
"@

Create-DocFile -Path "01-Progress\Templates\milestone-template.md" -Content $milestoneTemplate

# 7. Create Architecture Decision Record Template
$adrTemplate = @"
# ADR-001: [Decision Title]

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Context
[Describe the context and problem statement]

## Decision
[Describe the decision that was made]

## Consequences
### Positive
- 
- 

### Negative
- 
- 

### Neutral
- 
- 

## Alternatives Considered
1. **Alternative 1**: 
   - Pros: 
   - Cons: 
   - Reason rejected: 

2. **Alternative 2**: 
   - Pros: 
   - Cons: 
   - Reason rejected: 

## Implementation Notes
- 

## References
- [Link to relevant documentation]
- [Link to discussion thread]

---
*Date*: $(Get-Date -Format "yyyy-MM-dd")
*Author*: [Your name]
*Reviewers*: [Who reviewed this decision]
"@

Create-DocFile -Path "02-Architecture\Templates\adr-template.md" -Content $adrTemplate

# 8. Create Scripts README
$scriptsReadme = @"
# FoodXchange Scripts Directory

## 📁 Structure

\`\`\`
03-Scripts/
├── PowerShell/       # Main PowerShell scripts
├── Deployment/       # Deployment automation
├── Utilities/        # Helper utilities
└── Testing/          # Test automation scripts
\`\`\`

## 🔧 PowerShell Scripts

### Core Scripts
- **FoodXchange-Diagnostic.ps1** - System diagnostic tool
- **FoodXchange-Manager.ps1** - Service management (start/stop/check)

### Deployment Scripts
- **deploy-azure-infrastructure.ps1** - Azure resource deployment
- **deploy-to-production.ps1** - Production deployment automation

### Utility Scripts
- **backup-project.ps1** - Automated backup creation
- **create-all-docs.ps1** - Documentation file generator (this script)

## 📝 Usage Examples

### Run Diagnostic
\`\`\`powershell
.\PowerShell\FoodXchange-Diagnostic.ps1
\`\`\`

### Start All Services
\`\`\`powershell
.\PowerShell\FoodXchange-Manager.ps1 -StartAll
\`\`\`

### Create Backup
\`\`\`powershell
.\Utilities\backup-project.ps1 -BackupType Full -Message "Before major update"
\`\`\`

## 🔒 Script Permissions

Some scripts require administrator privileges. Run PowerShell as Administrator for:
- Service management
- Port checking
- System modifications

## 📚 Script Documentation

Each script includes:
- Purpose description
- Parameter explanations
- Usage examples
- Error handling

Run any script with \`-Help\` parameter for details:
\`\`\`powershell
.\script-name.ps1 -Help
\`\`\`
"@

Create-DocFile -Path "03-Scripts\README.md" -Content $scriptsReadme

# 9. Create Development Standards
$devStandards = @"
# FoodXchange Development Standards

## 🎯 Code Standards

### JavaScript/Node.js
- Use ES6+ features
- Async/await over callbacks
- Meaningful variable names
- JSDoc comments for functions

### React
- Functional components with hooks
- Component files: PascalCase
- One component per file
- Props validation with TypeScript

### Git Commits
Follow conventional commits:
- \`feat:\` New feature
- \`fix:\` Bug fix
- \`docs:\` Documentation only
- \`style:\` Code style changes
- \`refactor:\` Code refactoring
- \`test:\` Test additions/changes
- \`chore:\` Maintenance tasks

### Branch Naming
- \`feature/description\`
- \`fix/bug-description\`
- \`docs/what-docs\`
- \`hotfix/critical-fix\`

## 📁 File Organization

### Frontend
\`\`\`
src/
├── components/     # Reusable components
├── pages/         # Page components
├── hooks/         # Custom hooks
├── services/      # API services
├── utils/         # Utility functions
└── styles/        # Global styles
\`\`\`

### Backend
\`\`\`
src/
├── routes/        # API routes
├── controllers/   # Route controllers
├── models/        # Database models
├── middleware/    # Custom middleware
├── services/      # Business logic
└── utils/         # Helper functions
\`\`\`

## 🔐 Security Standards

1. Never commit sensitive data
2. Use environment variables
3. Validate all inputs
4. Sanitize database queries
5. Implement rate limiting
6. Use HTTPS in production

## 🧪 Testing Standards

- Write tests for critical paths
- Aim for 70%+ code coverage
- Test file naming: \`*.test.js\`
- Use descriptive test names

## 📝 Documentation Standards

- Document all public APIs
- Include examples in docs
- Keep README files updated
- Document breaking changes
- Add inline comments for complex logic

---
*Last Updated: $(Get-Date -Format "yyyy-MM-dd")*
"@

Create-DocFile -Path "04-Development\Code-Standards\development-standards.md" -Content $devStandards

# 10. Create Initial Architecture Overview
$archOverview = @"
# FoodXchange Architecture Overview

## 🏗️ System Architecture

### High-Level Architecture
\`\`\`
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   React App     │────▶│   Node.js API   │────▶│    MongoDB      │
│   (Frontend)    │     │   (Backend)     │     │   (Database)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
         │                       │                         │
         └───────────────────────┴─────────────────────────┘
                             │
                    ┌─────────────────┐
                    │   Azure Cloud    │
                    │   - Storage      │
                    │   - AI Services  │
                    │   - Hosting      │
                    └─────────────────┘
\`\`\`

## 🔧 Technology Stack

### Frontend
- **Framework**: React 18.2
- **Language**: JavaScript/TypeScript
- **State Management**: Zustand
- **Routing**: React Router v6
- **Styling**: Tailwind CSS
- **Build Tool**: Vite

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Language**: JavaScript/TypeScript
- **Authentication**: JWT + Azure AD B2C
- **Database ORM**: Mongoose

### Database
- **Primary**: MongoDB
- **Caching**: Redis
- **Search**: Azure Cognitive Search

### Cloud Services
- **Hosting**: Azure Kubernetes Service (AKS)
- **Storage**: Azure Blob Storage
- **AI/ML**: Azure Cognitive Services
- **Messaging**: Azure Service Bus

## 🔄 Data Flow

1. User interacts with React frontend
2. Frontend makes API calls to Node.js backend
3. Backend validates request and checks auth
4. Backend queries MongoDB/Cache
5. AI services process data if needed
6. Response sent back through the chain

## 🔐 Security Layers

1. **Frontend**: Input validation, XSS protection
2. **API**: Rate limiting, JWT validation
3. **Backend**: SQL injection prevention, data sanitization
4. **Database**: Encrypted at rest, access control
5. **Network**: HTTPS, Azure firewall

## 📊 Scalability Strategy

- Horizontal scaling with Kubernetes
- Database sharding for growth
- CDN for static assets
- Microservices-ready architecture
- Event-driven processing

---
*For detailed component documentation, see specific architecture documents*
"@

Create-DocFile -Path "02-Architecture\overview.md" -Content $archOverview

# 11. Create Project State Tracker
$projectStateContent = @"
# FoodXchange Project State Tracker
*Last Updated: $(Get-Date -Format "yyyy-MM-dd HH:mm")*

## 🚀 Current Project Status

### ✅ Completed Tasks
1. **Diagnostic Script** - Ran successfully, identified React app exists
2. **Enhancement Plan** - Created comprehensive 9-point enhancement document
3. **Service Manager Script** - Created PowerShell automation for starting/stopping services
4. **Architecture Decision** - Confirmed staying with Node.js (not converting to .NET)
5. **Documentation Structure** - Created comprehensive documentation system

### 📍 Current State
- **Frontend**: React 18.2.0 app at \`C:\Users\foodz\Documents\GitHub\Development\foodxchange-app\`
- **Backend**: Node.js at \`C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend\`
- **Database**: MongoDB running on port 27017
- **Services**: Not currently running (need to start with PowerShell script)

### 🎯 Next Immediate Steps
1. Run the FoodXchange-Manager.ps1 script with \`-StartAll\` flag
2. Verify all services are running correctly
3. Begin implementing enhanced MongoDB schemas
4. Set up Azure infrastructure using deployment scripts

## 📋 Key Decisions Made

### Architecture
- **Stay with Node.js** - Better for real-time features, existing expertise
- **Microservices-ready monolith** - Start monolithic, split later
- **Event-driven architecture** - Using Azure Service Bus
- **Multi-language from start** - Hebrew, English, German, French, Spanish

### Technology Stack
- **Frontend**: React 18 + TypeScript + Vite + Tailwind CSS
- **Backend**: Node.js + Express + TypeScript
- **Database**: MongoDB with enhanced schemas
- **Cache**: Redis
- **Search**: Azure Cognitive Search
- **AI**: Azure OpenAI (GPT-4) + Cognitive Services
- **Hosting**: Azure Kubernetes Service (AKS)

### Budget
- **Development (Month 1-3)**: ~\$370/month
- **Beta (Month 4-6)**: ~\$750/month
- **Production (Month 7+)**: ~\$1,070/month

## 🔧 Active Development Tasks

### Week 1-2 (Current)
- [ ] Fix frontend startup issues
- [ ] Deploy Azure infrastructure
- [ ] Implement enhanced MongoDB schemas
- [ ] Set up CI/CD pipeline

### Week 3-4
- [ ] Build RFQ system core
- [ ] Implement basic AI supplier matching
- [ ] Add multi-language support

## 🛠️ Environment Details

### Development Machine
- **OS**: Windows
- **Node.js**: v22.15.1
- **npm**: 11.4.0
- **MongoDB**: Running as service
- **PowerShell**: v7.5.1

## 💬 How to Continue in Next Chat

When starting a new chat, include:
1. This state document
2. Any new errors or issues encountered
3. Specific task you want to work on

### Sample Opening Message:
\`\`\`
I'm continuing the FoodXchange project. Here's my current state:
[Paste this document]

Since last time:
- I ran the startup script and got [specific error]
- I want to work on: [specific task]
\`\`\`

---
*Update this document after each session with new progress and decisions*
"@

Create-DocFile -Path "01-Progress\project-state-tracker.md" -Content $projectStateContent

# 12. Create backup script documentation
$backupScriptDoc = @"
# Backup Script Documentation

## Overview
The \`backup-project.ps1\` script creates versioned backups of your FoodXchange project.

## Usage

### Basic Usage
\`\`\`powershell
.\backup-project.ps1
\`\`\`

### Parameters
- \`-BackupType\`: Choose what to backup
  - \`Full\`: Everything (frontend, backend, docs)
  - \`Code\`: Just frontend and backend
  - \`Docs\`: Just documentation
  - \`Scripts\`: Just scripts folder
- \`-Message\`: Add a description to the backup

### Examples
\`\`\`powershell
# Full backup with message
.\backup-project.ps1 -BackupType Full -Message "Before Azure deployment"

# Code only backup
.\backup-project.ps1 -BackupType Code

# Documentation backup
.\backup-project.ps1 -BackupType Docs -Message "After architecture update"
\`\`\`

## Backup Location
All backups are stored in: \`05-Backups\`

## Automatic Cleanup
The script automatically keeps only the last 10 backups to save space.

## Restore Process
To restore a backup:
1. Navigate to \`05-Backups\`
2. Find the backup folder you want
3. Copy contents to desired location
"@

Create-DocFile -Path "03-Scripts\Utilities\backup-script-documentation.md" -Content $backupScriptDoc

# Final summary
Write-Host "`n📊 Documentation Creation Summary" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "✅ Created $filesCreated documentation files" -ForegroundColor Green

Write-Host "`n📁 Files created in:" -ForegroundColor Yellow
Write-Host "  • 01-Progress: Templates and state tracker" -ForegroundColor Gray
Write-Host "  • 02-Architecture: Overview and templates" -ForegroundColor Gray
Write-Host "  • 03-Scripts: README and documentation" -ForegroundColor Gray
Write-Host "  • 04-Development: Guides and standards" -ForegroundColor Gray

Write-Host "`n🎯 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Copy your existing PowerShell scripts to 03-Scripts/PowerShell/" -ForegroundColor Gray
Write-Host "2. Update 01-Progress/project-state-tracker.md with your current status" -ForegroundColor Gray
Write-Host "3. Start using daily logs in 01-Progress/Daily-Logs/" -ForegroundColor Gray
Write-Host "4. Commit everything to Git" -ForegroundColor Gray

Write-Host "`n💡 Quick Commands:" -ForegroundColor Cyan
Write-Host "  Open docs folder: " -NoNewline -ForegroundColor Gray
Write-Host "explorer ." -ForegroundColor White
Write-Host "  Open VS Code here: " -NoNewline -ForegroundColor Gray
Write-Host "code ." -ForegroundColor White
Write-Host "  Start tracking: " -NoNewline -ForegroundColor Gray
Write-Host "code 01-Progress\project-state-tracker.md" -ForegroundColor White

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
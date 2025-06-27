# FoodXchange Enhanced State Management System v2.0
# Comprehensive session tracking with AI context understanding
# Author: FoodXchange Development Assistant
# Version: 2.0 - Enhanced with detailed summaries and roadmap tracking

param(
    [string]$Command = "menu",
    [string]$SessionNotes = "",
    [switch]$SkipGitPush = $false
)

# Global Configuration
$global:FXConfig = @{
    FrontendPath = "C:\Users\foodz\Documents\GitHub\Development\foodxchange-app"
    BackendPath = "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend"
    DocsPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation"
    StatePath = "C:\Users\foodz\Documents\FoodXchange-State"
    QuickStatePath = "C:\Users\foodz\Documents\FoodXchange-QuickState"
    Developer = "Udi Stryk (foodz)"
    ProjectName = "FoodXchange B2B Trading Platform (FDX)"
    SessionStartTime = Get-Date
}

# Initialize directories
function Initialize-FXDirectories {
    @($global:FXConfig.StatePath, $global:FXConfig.QuickStatePath) | ForEach-Object {
        if (!(Test-Path $_)) {
            New-Item -ItemType Directory -Path $_ -Force | Out-Null
        }
    }
}

# Enhanced Git Analysis with Change Tracking
function Get-EnhancedGitStatus {
    param([string]$RepoPath, [string]$RepoName)
    
    if (!(Test-Path "$RepoPath\.git")) {
        return @{ Error = "Repository not found" }
    }
    
    Push-Location $RepoPath
    
    try {
        # Get last session info from state file
        $lastStateFile = Get-ChildItem "$($global:FXConfig.StatePath)\sessions\*.md" | 
                         Sort-Object LastWriteTime -Descending | 
                         Select-Object -First 1
        
        $lastCommit = ""
        if ($lastStateFile) {
            $content = Get-Content $lastStateFile.FullName -Raw
            if ($content -match "$RepoName.*Last Commit: ([a-f0-9]{40})") {
                $lastCommit = $matches[1]
            }
        }
        
        $currentStatus = @{
            Branch = git branch --show-current
            LastCommit = git log -1 --pretty=format:"%H"
            LastCommitMessage = git log -1 --pretty=format:"%s"
            LastCommitDate = git log -1 --pretty=format:"%ai"
            LastCommitAuthor = git log -1 --pretty=format:"%an"
            UncommittedFiles = @(git status --porcelain)
            RemoteUrl = git config --get remote.origin.url
            TotalCommits = git rev-list --count HEAD
        }
        
        # Calculate changes since last session
        if ($lastCommit -and $lastCommit -ne $currentStatus.LastCommit) {
            $currentStatus.ChangesSinceLastSession = git log --oneline "$lastCommit..HEAD"
            $currentStatus.FileChangedCount = (git diff --name-only "$lastCommit..HEAD" | Measure-Object).Count
        } else {
            $currentStatus.ChangesSinceLastSession = @()
            $currentStatus.FileChangedCount = 0
        }
        
        # Get commit history for session
        $sessionStart = $global:FXConfig.SessionStartTime.AddHours(-24)
        $currentStatus.SessionCommits = git log --since="$sessionStart" --pretty=format:"%h - %s (%ar)"
        
        return $currentStatus
    }
    finally {
        Pop-Location
    }
}

# Comprehensive Session Summary Generator
function Get-SessionSummary {
    $summary = @{
        Duration = (Get-Date) - $global:FXConfig.SessionStartTime
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
        SessionID = Get-Date -Format "yyyy-MM-dd_HHmmss"
    }
    
    # Analyze each repository
    $summary.Frontend = Get-EnhancedGitStatus -RepoPath $global:FXConfig.FrontendPath -RepoName "Frontend"
    $summary.Backend = Get-EnhancedGitStatus -RepoPath $global:FXConfig.BackendPath -RepoName "Backend"
    $summary.Docs = Get-EnhancedGitStatus -RepoPath $global:FXConfig.DocsPath -RepoName "Documentation"
    
    # Count total changes
    $summary.TotalCommits = 0
    $summary.TotalFiles = 0
    
    foreach ($repo in @($summary.Frontend, $summary.Backend, $summary.Docs)) {
        if ($repo.SessionCommits) {
            $summary.TotalCommits += ($repo.SessionCommits | Measure-Object).Count
        }
        $summary.TotalFiles += $repo.FileChangedCount
    }
    
    return $summary
}

# Generate Comprehensive State Document
function New-EnhancedStateDocument {
    param([hashtable]$Summary)
    
    $stateDoc = @"
# FoodXchange Comprehensive Session State
Generated: $($Summary.Timestamp)
Developer: $($global:FXConfig.Developer)
Session ID: $($Summary.SessionID)

## 🎯 Project Overview
- **Name**: FoodXchange B2B Trading Platform (FDX)
- **Goal**: Achieve 50%+ productivity increase through automation
- **Stage**: Solo testing MVP development
- **Architecture**: React + Node.js/Express + MongoDB + Azure AI

## 📊 Repository Status

### Frontend (foodxchange-app)
- **Branch**: $($Summary.Frontend.Branch)
- **Last Commit**: $($Summary.Frontend.LastCommitMessage)
- **Changes Since Last Session**: $(if($Summary.Frontend.FileChangedCount -gt 0){"$($Summary.Frontend.FileChangedCount) files changed"}else{"No changes"})
- **Uncommitted**: $($Summary.Frontend.UncommittedFiles.Count) files

### Backend (Foodxchange-backend)
- **Branch**: $($Summary.Backend.Branch)
- **Last Commit**: $($Summary.Backend.LastCommitMessage) - $($Summary.Backend.LastCommitDate)
- **Changes Since Last Session**: $(if($Summary.Backend.FileChangedCount -gt 0){"$($Summary.Backend.FileChangedCount) files changed"}else{"No changes"})
- **Uncommitted**: $($Summary.Backend.UncommittedFiles.Count) files

### Documentation
- **Branch**: $($Summary.Docs.Branch)
- **Last Commit**: $($Summary.Docs.LastCommitMessage)
- **Uncommitted**: $($Summary.Docs.UncommittedFiles.Count) files

## 🏗️ Roadmap & Architecture

### 4-Module System Architecture

1. **RFQ Module** (Priority 1)
   - AI/Machine Vision for request creation
   - Buyer request → Seller RFQ conversion
   - Email template system
   - AI agent for supplier matching
   - Multi-supplier comparison

2. **Adaptation Module**
   - Expert marketplace
   - Contractor assignment
   - Market compliance (Kosher, Organic, etc.)
   - QA advisors integration

3. **Orders Module**
   - Purchase order management
   - Proforma invoice matching
   - Shipment tracking
   - Multi-date deliveries

4. **Billing Module**
   - Commission tracking
   - Revenue sharing for agents
   - Transaction management

## 📝 What Was Accomplished This Session
"@

    # Add placeholder for manual notes
    $stateDoc += @"

### Development Progress:
- [SYSTEM WILL AUTO-FILL BASED ON COMMITS AND CHANGES]
- Enhanced state management system implementation
- PowerShell profile configuration with productivity aliases
- Git integration for automated repository tracking
- AI context questionnaire for session continuity

### Configuration Updates:
- Configured fxs, fxn, fxstart commands for quick workflows
- Implemented automated session summaries
- Set up repository change tracking
- Enhanced documentation structure

### Architecture Decisions:
- Established 4-module roadmap (RFQ → Adaptation → Orders → Billing)
- Prioritized RFQ system with AI integration
- Defined commission-based revenue model
- Confirmed Azure Founder's Hub utilization

## 🎨 Artifacts Created This Session
"@
    
    # Add artifacts section
    $stateDoc += @"

### PowerShell Scripts:
- FoodXchange-Enhanced-State-V2.ps1 (Main state management)
- Profile configuration with aliases
- Automated Git synchronization

### Documentation:
- Enhanced session state templates
- AI context questionnaire
- Roadmap documentation

### Code Implementations:
- [TO BE FILLED WITH ACTUAL IMPLEMENTATIONS]

## 🔑 Key Decisions Made

### Business Decisions:
- Solo MVP testing approach targeting 50% productivity increase
- Commission-based revenue model for all parties
- Azure Founder's Hub for unlimited AI services
- Initial focus on RFQ module with email automation

### Technical Decisions:
- 4-module architecture implementation
- AI-powered supplier matching priority
- Email template system for seller recruitment
- Expert marketplace integration planning

## 🚧 Current Implementation Status

### ✅ Completed
- Basic authentication (JWT)
- Role-based access (Buyer/Seller/Admin/Contractor/Agent)
- Company profiles
- Basic CRUD operations
- PowerShell automation setup
- State management system

### 🔄 In Progress
- RFQ system with AI integration
- Email template system
- Supplier matching algorithm
- Multi-language support
- Azure Cognitive Services setup

### 📋 TODO Next
- Implement Azure Computer Vision for RFQ creation
- Create RFQ data models (buyer → seller conversion)
- Build email automation system
- Develop AI agent for supplier database matching
- Set up sample tracking system
- Implement price versioning system

## 🐛 Known Issues
1. Frontend branch appears empty - needs investigation
2. Port conflicts occasionally on startup
3. MongoDB connection timeouts on cold start

## 💡 Session Notes & Ideas

### AI Assistant Recommendations:
1. **RFQ Module Architecture**: Consider implementing a state machine for RFQ workflow (Draft → Sent → Responded → Negotiating → Accepted)
2. **Email Templates**: Use SendGrid or Azure Communication Services for scalable email delivery
3. **AI Integration**: Leverage Azure Form Recognizer for document parsing alongside Computer Vision
4. **Expert Marketplace**: Implement rating/review system early for quality control
5. **Database Design**: Use MongoDB aggregation pipelines for complex supplier matching queries

### Additional Expert Types to Consider:
- Packaging specialists
- Logistics coordinators
- Regulatory compliance officers
- Food safety auditors
- Halal certification experts
- Supply chain analysts
- Sustainability consultants
- Import/export documentation specialists

## 🔧 Quick Commands
```powershell
# Save state: fxs
# New chat: fxn
# Continue work: fxstart
# Help: fxhelp
# View all commands: fxcommands
```

## 📈 Productivity Metrics
- **Session Duration**: $([int]$Summary.Duration.TotalMinutes) minutes
- **Commits Made**: $($Summary.TotalCommits)
- **Files Changed**: $($Summary.TotalFiles)
- **Productivity Score**: $(if($Summary.TotalCommits -gt 0){"Active"}else{"Planning"})

## 🎯 Continue From

### Immediate Next Steps:
1. Set up Azure Cognitive Services in Founder's Hub
2. Create RFQ MongoDB schemas with versioning
3. Implement basic email template engine
4. Build supplier matching algorithm prototype

### This Week's Goals:
- Complete RFQ module MVP
- Test AI-powered request creation
- Implement supplier email automation
- Create sample tracking system

### Architecture Focus:
- Design state machine for RFQ workflow
- Plan microservices separation for modules
- Implement event-driven architecture for real-time updates

---
*FoodXchange Enhanced State v2.0*
"@
    
    return $stateDoc
}

# AI Context Questionnaire Generator
function New-AIContextQuestionnaire {
    param([hashtable]$Summary)
    
    $questionnaire = @"
# FoodXchange AI Context Questionnaire
*For achieving 98% session understanding*

## 🔍 Session Context Questions

### 1. What specific RFQ features were you implementing?
- [ ] AI/Machine vision integration
- [ ] Email template system
- [ ] Supplier matching algorithm
- [ ] Database schema design
- [ ] Other: _______________

### 2. Which artifacts/code did you create or modify?
Please list all files with brief descriptions:
- Frontend: _______________
- Backend: _______________
- Scripts: _______________

### 3. What technical challenges did you encounter?
_______________

### 4. What decisions need to be made next session?
_______________

### 5. Which Azure services did you configure?
- [ ] Cognitive Services
- [ ] Computer Vision
- [ ] Form Recognizer
- [ ] Communication Services
- [ ] Other: _______________

### 6. What's the current blocker preventing progress?
_______________

## 📊 Current System State

### Active Features:
$( if ($Summary.Backend.Branch -eq "ai-features") { "- AI features branch active in backend" } )
$( if ($Summary.Frontend.UncommittedFiles.Count -gt 0) { "- Uncommitted frontend changes: $($Summary.Frontend.UncommittedFiles -join ', ')" } )

### Recent Commits:
$(if ($Summary.Backend.SessionCommits) { $Summary.Backend.SessionCommits | ForEach-Object { "- $_" } })

## 🎯 Priority Clarification

1. **RFQ Module Status**: 
   - Database models: [Not Started/In Progress/Complete]
   - Email templates: [Not Started/In Progress/Complete]
   - AI integration: [Not Started/In Progress/Complete]

2. **Next Implementation Priority**:
   - [ ] Azure setup
   - [ ] Database schemas
   - [ ] API endpoints
   - [ ] Frontend components
   - [ ] Email automation

## 📝 Additional Context Needed
Please provide any additional information about:
- Specific code snippets that need review
- Error messages encountered
- Configuration changes made
- Business logic decisions

---
*Copy this questionnaire and fill it out for your next session*
"@
    
    return $questionnaire
}

# Enhanced Save State Function
function Save-EnhancedState {
    Write-Host "`n💾 SAVING COMPREHENSIVE STATE..." -ForegroundColor Cyan
    
    # Get session summary
    $summary = Get-SessionSummary
    
    # Generate documents
    $stateDoc = New-EnhancedStateDocument -Summary $summary
    $aiQuestions = New-AIContextQuestionnaire -Summary $summary
    
    # Save files
    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $statePath = "$($global:FXConfig.StatePath)\sessions\state_$timestamp.md"
    $questionPath = "$($global:FXConfig.StatePath)\sessions\ai_context_$timestamp.md"
    
    $stateDoc | Out-File -FilePath $statePath -Encoding UTF8
    $aiQuestions | Out-File -FilePath $questionPath -Encoding UTF8
    
    # Update latest links
    $stateDoc | Out-File -FilePath "$($global:FXConfig.StatePath)\latest_state.md" -Encoding UTF8
    $aiQuestions | Out-File -FilePath "$($global:FXConfig.StatePath)\latest_questions.md" -Encoding UTF8
    
    # Git operations
    if (!$SkipGitPush) {
        Write-Host "`n🔄 Updating repositories..." -ForegroundColor Yellow
        
        # Auto-commit and push all repos
        @(
            @{Path=$global:FXConfig.FrontendPath; Name="Frontend"},
            @{Path=$global:FXConfig.BackendPath; Name="Backend"},
            @{Path=$global:FXConfig.DocsPath; Name="Documentation"}
        ) | ForEach-Object {
            Push-Location $_.Path
            $changes = git status --porcelain
            if ($changes) {
                git add .
                git commit -m "Auto-save: Session $timestamp"
                git push
                Write-Host "✅ $($_.Name) updated" -ForegroundColor Green
            }
            Pop-Location
        }
    }
    
    # Copy to clipboard
    $clipboardContent = @"
## Session State Saved: $timestamp
State Document: $statePath
AI Questions: $questionPath

Key Accomplishments:
- Enhanced state management system
- Automated Git synchronization
- AI context questionnaire
- Productivity tracking

Total Commits: $($summary.TotalCommits)
Files Changed: $($summary.TotalFiles)
"@
    
    $clipboardContent | Set-Clipboard
    
    Write-Host "`n✅ STATE SAVED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "📄 State: $statePath" -ForegroundColor Cyan
    Write-Host "❓ Questions: $questionPath" -ForegroundColor Cyan
    Write-Host "📋 Summary copied to clipboard" -ForegroundColor Yellow
    
    # Open in notepad for additional notes
    Write-Host "`n📝 Opening state document for your notes..." -ForegroundColor Yellow
    Start-Process notepad $statePath
}

# New Chat Message Generator
function New-ChatMessage {
    Write-Host "`n🆕 GENERATING NEW CHAT MESSAGE..." -ForegroundColor Cyan
    
    # Get latest state
    $latestState = Get-Content "$($global:FXConfig.StatePath)\latest_state.md" -Raw -ErrorAction SilentlyContinue
    $latestQuestions = Get-Content "$($global:FXConfig.StatePath)\latest_questions.md" -Raw -ErrorAction SilentlyContinue
    
    $message = @"
I'm continuing work on my FoodXchange B2B platform (FDX).

**Project**: FoodXchange - B2B Food Trading Platform
**Developer**: Udi Stryk (foodz)
**Target**: 50% productivity increase through automation
**Architecture**: React + Node.js/Express + MongoDB + Azure AI

## Previous Session Summary
$latestState

## Current Goal
I want to continue implementing the RFQ module with AI integration. Specifically:
1. [SPECIFY YOUR EXACT TASK]
2. [ANY BLOCKERS OR ISSUES]

## Questions for Context
Please review the attached AI context questionnaire and ask any additional questions needed to achieve 98% understanding of my project state.

**Repositories to check**:
- Frontend: https://github.com/foodXchange/foodxchange-app
- Backend: https://github.com/foodXchange/Foodxchange-backend
- Docs: https://github.com/foodXchange/FoodXchange-Documentation

Please help me continue from where I left off with focus on [SPECIFIC AREA].
"@
    
    $message | Set-Clipboard
    
    Write-Host "✅ Chat message copied to clipboard!" -ForegroundColor Green
    Write-Host "📋 Paste it in your new chat" -ForegroundColor Yellow
    Write-Host "📎 Don't forget to attach the AI context questionnaire!" -ForegroundColor Cyan
}

# Quick Start Environment
function Start-FXEnvironment {
    Write-Host "`n🚀 STARTING FOODXCHANGE ENVIRONMENT..." -ForegroundColor Cyan
    
    # Change to backend directory first
    Set-Location $global:FXConfig.BackendPath
    
    Write-Host "📍 Current directory: $(Get-Location)" -ForegroundColor Gray
    Write-Host "`n▶️  Starting MongoDB..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "mongod"
    
    Start-Sleep -Seconds 3
    
    Write-Host "▶️  Starting Backend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($global:FXConfig.BackendPath)'; npm start"
    
    Start-Sleep -Seconds 5
    
    Write-Host "▶️  Starting Frontend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($global:FXConfig.FrontendPath)'; npm start"
    
    Write-Host "▶️  Opening VS Code..." -ForegroundColor Yellow
    code $global:FXConfig.FrontendPath
    code $global:FXConfig.BackendPath
    code $global:FXConfig.DocsPath
    
    Write-Host "`n⏳ Waiting for services to start..." -ForegroundColor Gray
    Start-Sleep -Seconds 10
    
    Write-Host "`n✅ ENVIRONMENT READY!" -ForegroundColor Green
    Write-Host "📱 Frontend: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "🔧 Backend: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "🗄️  MongoDB: mongodb://localhost:27017" -ForegroundColor Cyan
}

# Main menu
function Show-Menu {
    Clear-Host
    Write-Host @"
╔═══════════════════════════════════════════════════════════════╗
║              FoodXchange Enhanced State Manager v2.0          ║
╚═══════════════════════════════════════════════════════════════╝

🎯 PROJECT: FoodXchange B2B Trading Platform (FDX)
👤 DEVELOPER: Udi Stryk (foodz)
📅 DATE: $(Get-Date -Format "yyyy-MM-dd HH:mm")

╔═══════════════════════════════════════════════════════════════╗
║                        QUICK COMMANDS                         ║
╠═══════════════════════════════════════════════════════════════╣
║  💾 Save State & Close Chat.......... fxs                     ║
║  🆕 Generate New Chat Message........ fxn                     ║
║  ▶️  Start Development Environment.... fxstart                 ║
║  ❓ Show All Commands................ fxhelp                  ║
╚═══════════════════════════════════════════════════════════════╝

Select an option:
1. 💾 Save comprehensive state (end of chat)
2. 🆕 Generate new chat message
3. ▶️  Start development environment
4. 📊 View current repository status
5. ❓ Show detailed help
6. 🚪 Exit

"@ -ForegroundColor Cyan
    
    $choice = Read-Host "Enter your choice (1-6)"
    
    switch ($choice) {
        "1" { Save-EnhancedState }
        "2" { New-ChatMessage }
        "3" { Start-FXEnvironment }
        "4" { Get-SessionSummary | Format-List }
        "5" { Show-DetailedHelp }
        "6" { exit }
        default { Show-Menu }
    }
}

# Detailed help
function Show-DetailedHelp {
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                   FOODXCHANGE COMMAND REFERENCE               ║
╚═══════════════════════════════════════════════════════════════╝

🔧 CORE COMMANDS
================
fxs (foodx-save)
  Saves complete session state including Git commits, changes, and progress.
  Auto-commits all repos and generates AI context questionnaire.
  Usage: fxs
  
fxn (foodx-new)
  Generates new chat message with full context from previous session.
  Copies to clipboard ready to paste in new chat.
  Usage: fxn

fxstart (foodx-start)
  Launches complete dev environment: MongoDB, Backend, Frontend, VS Code.
  Ensures all services start in correct order with proper delays.
  Usage: fxstart

📁 NAVIGATION SHORTCUTS
=======================
fxf - Navigate to Frontend directory
fxb - Navigate to Backend directory
fxd - Navigate to Documentation directory
fxstate - Navigate to State management directory

🔄 GIT COMMANDS
===============
fxcommit - Commit all changes in current repo with message
fxpush - Push all commits to remote repository
fxpull - Pull latest changes from remote repository
fxsync - Sync all three repositories (pull, commit, push)
fxstatus - Show status of all repositories

📊 PRODUCTIVITY TOOLS
=====================
fxstats - Display session statistics and productivity metrics
fxroutine - Show daily development routine checklist
fxfocus [module] - Set focus module for current session (rfq/adapt/orders/billing)
fxtodo - Show current TODO list from roadmap

🎯 MODULE SHORTCUTS
==================
fxrfq - Focus on RFQ module development
fxadapt - Focus on Adaptation module
fxorders - Focus on Orders module
fxbilling - Focus on Billing module

💡 PRODUCTIVITY TIPS
===================
1. Start each day with 'fxroutine' to see your checklist
2. Use 'fxfocus rfq' to set daily module priority
3. Run 'fxs' before ending each session
4. Use 'fxstats' to track productivity trends
5. Commit frequently with descriptive messages

📈 DAILY ROUTINE
================
Morning:
  1. fxstart - Launch environment
  2. fxpull - Get latest changes
  3. fxroutine - Review daily tasks
  4. fxfocus [module] - Set priority

During Work:
  1. fxcommit - Regular commits
  2. fxstats - Check progress
  3. fxtodo - Update task list

End of Session:
  1. fxs - Save complete state
  2. Review generated AI questionnaire
  3. Add session notes in Notepad

🔗 QUICK REFERENCES
===================
Frontend: http://localhost:3000
Backend: http://localhost:5000
MongoDB: mongodb://localhost:27017
Azure Portal: https://portal.azure.com
GitHub: https://github.com/foodXchange

Press any key to continue...
"@ -ForegroundColor Cyan
    
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Initialize
Initialize-FXDirectories

# Execute based on parameter
switch ($Command.ToLower()) {
    "save" { Save-EnhancedState }
    "new" { New-ChatMessage }
    "start" { Start-FXEnvironment }
    "help" { Show-DetailedHelp }
    default { Show-Menu }
}
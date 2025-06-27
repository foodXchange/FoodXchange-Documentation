# FoodXchange Enhanced State Management System with AI Context
# Version: 2.0 - Production Ready
# Author: FoodXchange Assistant
# Date: 2025-06-27

# Set execution policy for current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

# Global configuration
$global:FoodXConfig = @{
    DocsPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation"
    BackendPath = "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend"
    FrontendPath = "C:\Users\foodz\Documents\GitHub\Development\foodxchange-app"
    QuickStatePath = "C:\Users\foodz\Documents\FoodXchange-QuickState"
    StateHistoryPath = "C:\Users\foodz\Documents\FoodXchange-QuickState\history"
    ArtifactsPath = "C:\Users\foodz\Documents\FoodXchange-QuickState\artifacts"
    SessionsPath = "C:\Users\foodz\Documents\FoodXchange-QuickState\sessions"
}

# Initialize directories
function Initialize-FoodXDirectories {
    $directories = @(
        $global:FoodXConfig.QuickStatePath,
        $global:FoodXConfig.StateHistoryPath,
        $global:FoodXConfig.ArtifactsPath,
        $global:FoodXConfig.SessionsPath
    )
    
    foreach ($dir in $directories) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
    }
}

# Enhanced Save State Function (fxs)
function Save-FoodXState {
    param(
        [string]$SessionNotes = "",
        [switch]$DetailedCapture = $true
    )
    
    # Change to docs directory first
    cd $global:FoodXConfig.DocsPath
    
    Write-Host "`n💾 SAVING ENHANCED STATE..." -ForegroundColor Cyan
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $sessionId = "FXS_$timestamp"
    
    # Capture current work context
    Write-Host "📊 Analyzing repositories..." -ForegroundColor Yellow
    
    # Get Git status for all repos
    $gitStatus = @{
        Frontend = Get-GitRepoStatus -Path $global:FoodXConfig.FrontendPath
        Backend = Get-GitRepoStatus -Path $global:FoodXConfig.BackendPath
        Docs = Get-GitRepoStatus -Path $global:FoodXConfig.DocsPath
    }
    
    # Capture session artifacts
    Write-Host "🎨 Capturing session artifacts..." -ForegroundColor Yellow
    $artifacts = @{
        Created = @()
        Modified = @()
        CodeSnapshots = @()
    }
    
    # Build comprehensive state document
    $stateDoc = @"
# FoodXchange Enhanced State Document
## Session: $sessionId
## Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

---

## 🚀 PROJECT ROADMAP STATUS

### MVP Target: ASAP (Solo Testing Phase)
**Goal**: 50%+ productivity increase for food procurement

### 📋 Core Modules Progress:
1. **RFQ System with AI** [🔄 In Development]
   - Machine vision for product identification
   - Buyer request → Seller RFQ conversion
   - Email template system
   - AI agent for supplier matching
   
2. **Adaptation Module** [⏳ Planned]
   - Expert/Contractor marketplace
   - Multi-market product adaptation
   - Professional network (designers, regulation, QA, kosher, organic advisors)
   
3. **Orders Management** [⏳ Planned]
   - PO verification system
   - Proforma invoice matching
   - Shipment tracking
   - Split order handling
   
4. **Billing Module** [⏳ Planned]
   - Commission structure (buyers & sellers)
   - Contractor payments
   - Agent revenue sharing

---

## 💼 SESSION SUMMARY

### What Was Accomplished:
$($SessionNotes)

### Artifacts Created This Session:
$(if ($artifacts.Created.Count -gt 0) {
    $artifacts.Created | ForEach-Object { "- $_" }
} else {
    "- No new artifacts created"
})

### Code Changes:
- Frontend: $($gitStatus.Frontend.Changes) changes
- Backend: $($gitStatus.Backend.Changes) changes  
- Documentation: $($gitStatus.Docs.Changes) changes

### Key Decisions Made:
[TO BE FILLED BY DEVELOPER]

---

## 🔧 TECHNICAL STATE

### Repository Status:
#### Frontend (React 18)
- **Path**: $($global:FoodXConfig.FrontendPath)
- **Branch**: $($gitStatus.Frontend.Branch)
- **Last Commit**: $($gitStatus.Frontend.LastCommit)
- **Uncommitted**: $($gitStatus.Frontend.Changes) files

#### Backend (Node.js/Express)
- **Path**: $($global:FoodXConfig.BackendPath)
- **Branch**: $($gitStatus.Backend.Branch)
- **Last Commit**: $($gitStatus.Backend.LastCommit)
- **Uncommitted**: $($gitStatus.Backend.Changes) files

#### Documentation
- **Path**: $($global:FoodXConfig.DocsPath)
- **Branch**: $($gitStatus.Docs.Branch)
- **Last Commit**: $($gitStatus.Docs.LastCommit)
- **Uncommitted**: $($gitStatus.Docs.Changes) files

### Environment Configuration:
- **MongoDB**: localhost:27017 (foodxchange_db)
- **Backend API**: http://localhost:5000
- **Frontend**: http://localhost:3000
- **Azure Services**: Founder's Hub (No budget limits)

---

## 🎯 NEXT CHAT REQUIREMENTS

### Questions for AI Assistant:
1. What specific RFQ features were implemented?
2. Which AI/ML components were integrated?
3. What database schema changes were made?
4. Which email templates were created?
5. What expert types were defined in the system?

### Required Context Files:
- [ ] This state document
- [ ] Any new component code (especially RFQ-related)
- [ ] Database schema updates
- [ ] API endpoint changes
- [ ] UI/UX mockups or screenshots

### Continue From:
[SPECIFIC TASK OR FEATURE TO CONTINUE]

---

## 📝 DEVELOPER NOTES

$($SessionNotes)

---

## 🚀 QUICK CONTINUE COMMANDS

### Start Everything:
```powershell
foodx-start
```

### View This State:
```powershell
code "$($global:FoodXConfig.QuickStatePath)\sessions\$sessionId.md"
```

### Git Sync All:
```powershell
foodx-sync
```

---

*Generated by FoodXchange Enhanced State System v2.0*
"@

    # Save state document
    $stateFile = "$($global:FoodXConfig.SessionsPath)\$sessionId.md"
    $stateDoc | Out-File -FilePath $stateFile -Encoding UTF8
    
    # Also save as latest
    $stateDoc | Out-File -FilePath "$($global:FoodXConfig.QuickStatePath)\latest.md" -Encoding UTF8
    
    # Copy to clipboard
    $stateDoc | Set-Clipboard
    
    # Update Git repos with state
    if ($DetailedCapture) {
        Write-Host "`n📤 Updating repositories..." -ForegroundColor Yellow
        
        # Add state to docs repo
        Push-Location $global:FoodXConfig.DocsPath
        Copy-Item $stateFile -Destination ".\01-Progress\Chat-Sessions\$sessionId.md" -Force
        git add .
        git commit -m "State: Session $sessionId saved"
        git push
        Pop-Location
        
        Write-Host "✅ Repository updated!" -ForegroundColor Green
    }
    
    Write-Host @"

✅ ENHANCED STATE SAVED!
📋 State copied to clipboard!
📄 File: $stateFile

📝 Opening for your notes...
"@ -ForegroundColor Green

    # Open in notepad for additional notes
    Start-Process notepad $stateFile -Wait
    
    # Re-read and copy updated file
    $updatedState = Get-Content $stateFile -Raw
    $updatedState | Set-Clipboard
    
    Write-Host "`n📋 Updated state copied to clipboard!" -ForegroundColor Cyan
}

# Enhanced New Chat Function (fxn)
function New-FoodXChat {
    Write-Host "`n📋 GENERATING ENHANCED CHAT MESSAGE..." -ForegroundColor Cyan
    
    # Read latest state
    $latestState = "$($global:FoodXConfig.QuickStatePath)\latest.md"
    if (Test-Path $latestState) {
        $stateContent = Get-Content $latestState -Raw
    } else {
        $stateContent = "No previous state found"
    }
    
    # Get current git status
    $currentStatus = @{
        Frontend = Get-GitRepoStatus -Path $global:FoodXConfig.FrontendPath
        Backend = Get-GitRepoStatus -Path $global:FoodXConfig.BackendPath
        Docs = Get-GitRepoStatus -Path $global:FoodXConfig.DocsPath
    }
    
    $chatMessage = @"
I'm continuing work on my FoodXchange B2B platform.

**Project**: FoodXchange (FDX) - B2B Food Trading Platform
**Developer**: Udi Stryk (foodz)
**Architecture**: React 18 + Node.js/Express + MongoDB + Azure AI
**Goal**: Solo testing to achieve 50%+ productivity increase

## 📊 Previous Session State
[Attached: Enhanced state document]

## 🎯 Current Focus
I'm working on the RFQ (Request for Quotation) system with AI integration, which is the first of 4 core modules:
1. RFQ System (current)
2. Adaptation Module
3. Orders Management  
4. Billing Module

## 🔧 Repository Status
- **Frontend**: Branch '$($currentStatus.Frontend.Branch)' | $($currentStatus.Frontend.Changes) uncommitted changes
- **Backend**: Branch '$($currentStatus.Backend.Branch)' | $($currentStatus.Backend.Changes) uncommitted changes
- **Docs**: Branch '$($currentStatus.Docs.Branch)' | $($currentStatus.Docs.Changes) uncommitted changes

## 📋 Specific Questions
1. [Your specific question or task here]

## 🎨 Context from Last Session
Please check:
1. The attached state document for detailed progress
2. Artifacts created in the last session
3. Any code changes in the repositories

Please help me continue from where I left off. If you need more context, ask specific questions until you have 98% understanding of the project state.
"@

    $chatMessage | Set-Clipboard
    
    Write-Host @"

✅ ENHANCED CHAT MESSAGE READY!
📋 Message copied to clipboard!

🎯 NEXT STEPS:
1. Paste this message in your new chat
2. Attach the latest state document
3. Answer any follow-up questions from the AI
4. Continue your development!

📄 State document: $latestState
"@ -ForegroundColor Green
}

# Start Environment Function (fxstart)
function Start-FoodXEnvironment {
    Write-Host @"

🚀 STARTING FOODXCHANGE ENVIRONMENT...

"@ -ForegroundColor Cyan
    
    # Change to backend directory first
    cd $global:FoodXConfig.BackendPath
    
    # Check prerequisites
    Write-Host "🔍 Checking prerequisites..." -ForegroundColor Yellow
    
    $checks = @{
        "MongoDB" = (Get-Process mongod -ErrorAction SilentlyContinue)
        "Node.js" = (node --version)
        "NPM" = (npm --version)
    }
    
    # Start MongoDB if not running
    if (-not $checks["MongoDB"]) {
        Write-Host "▶️  Starting MongoDB..." -ForegroundColor Yellow
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "mongod" -WorkingDirectory "C:\"
        Start-Sleep -Seconds 3
    }
    
    # Start Backend
    Write-Host "▶️  Starting Backend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($global:FoodXConfig.BackendPath)'; npm start" 
    
    # Start Frontend
    Start-Sleep -Seconds 3
    Write-Host "▶️  Starting Frontend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($global:FoodXConfig.FrontendPath)'; npm start"
    
    # Open VS Code
    Write-Host "▶️  Opening VS Code..." -ForegroundColor Yellow
    code $global:FoodXConfig.FrontendPath
    code $global:FoodXConfig.BackendPath
    code $global:FoodXConfig.DocsPath
    
    # Wait and open browser
    Write-Host "⏳ Waiting for services to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 8
    Start-Process "http://localhost:3000"
    
    Write-Host @"

✅ ENVIRONMENT READY!
📱 Frontend: http://localhost:3000
🔧 Backend: http://localhost:5000
🗄️  MongoDB: mongodb://localhost:27017

💡 Daily Productivity Tips:
- Start with 'foodx-status' to check system health
- Use 'foodx-sync' to sync all repos before starting
- Save state every 2 hours with 'fxs'
- Document decisions in the state notes

"@ -ForegroundColor Green
}

# Git Repository Status Helper
function Get-GitRepoStatus {
    param([string]$Path)
    
    if (!(Test-Path "$Path\.git")) {
        return @{
            Branch = "not-a-git-repo"
            Changes = 0
            LastCommit = "N/A"
        }
    }
    
    Push-Location $Path
    $branch = git branch --show-current 2>$null
    $changes = (git status --porcelain 2>$null | Measure-Object).Count
    $lastCommit = git log -1 --pretty=format:"%h - %s" 2>$null
    Pop-Location
    
    return @{
        Branch = $branch
        Changes = $changes
        LastCommit = $lastCommit
    }
}

# Sync all repositories
function Sync-FoodXRepos {
    Write-Host "`n🔄 SYNCING ALL REPOSITORIES..." -ForegroundColor Cyan
    
    $repos = @(
        @{Name="Frontend"; Path=$global:FoodXConfig.FrontendPath},
        @{Name="Backend"; Path=$global:FoodXConfig.BackendPath},
        @{Name="Documentation"; Path=$global:FoodXConfig.DocsPath}
    )
    
    foreach ($repo in $repos) {
        Write-Host "`n📦 $($repo.Name)..." -ForegroundColor Yellow
        Push-Location $repo.Path
        
        # Check for changes
        $status = git status --porcelain
        if ($status) {
            Write-Host "  📝 Committing changes..." -ForegroundColor Yellow
            git add .
            git commit -m "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        }
        
        # Pull and push
        Write-Host "  ⬇️  Pulling latest..." -ForegroundColor Yellow
        git pull
        Write-Host "  ⬆️  Pushing changes..." -ForegroundColor Yellow
        git push
        
        Pop-Location
        Write-Host "  ✅ $($repo.Name) synced!" -ForegroundColor Green
    }
    
    Write-Host "`n✅ ALL REPOSITORIES SYNCED!" -ForegroundColor Green
}

# Check system status
function Get-FoodXStatus {
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                  FOODXCHANGE SYSTEM STATUS                    ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan
    
    # Check services
    $services = @{
        "MongoDB" = (Get-Process mongod -ErrorAction SilentlyContinue) -ne $null
        "Backend" = (Test-NetConnection -ComputerName localhost -Port 5000 -InformationLevel Quiet)
        "Frontend" = (Test-NetConnection -ComputerName localhost -Port 3000 -InformationLevel Quiet)
    }
    
    Write-Host "🔧 SERVICES:" -ForegroundColor Yellow
    foreach ($service in $services.GetEnumerator()) {
        $status = if ($service.Value) { "✅ Running" } else { "❌ Stopped" }
        $color = if ($service.Value) { "Green" } else { "Red" }
        Write-Host "  $($service.Key): $status" -ForegroundColor $color
    }
    
    # Check repositories
    Write-Host "`n📦 REPOSITORIES:" -ForegroundColor Yellow
    $repos = @(
        @{Name="Frontend"; Path=$global:FoodXConfig.FrontendPath},
        @{Name="Backend"; Path=$global:FoodXConfig.BackendPath},
        @{Name="Docs"; Path=$global:FoodXConfig.DocsPath}
    )
    
    foreach ($repo in $repos) {
        $status = Get-GitRepoStatus -Path $repo.Path
        Write-Host "  $($repo.Name): $($status.Branch) | $($status.Changes) changes" -ForegroundColor Cyan
    }
    
    # Show roadmap progress
    Write-Host "`n📈 ROADMAP PROGRESS:" -ForegroundColor Yellow
    Write-Host "  1. RFQ System: 🔄 In Development (30%)" -ForegroundColor Cyan
    Write-Host "  2. Adaptation: ⏳ Planned" -ForegroundColor Gray
    Write-Host "  3. Orders Mgmt: ⏳ Planned" -ForegroundColor Gray
    Write-Host "  4. Billing: ⏳ Planned" -ForegroundColor Gray
    
    Write-Host "`n💡 Next: Use 'foodx-help' for all commands" -ForegroundColor Green
}

# Enhanced help function
function Show-FoodXHelp {
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║                  FOODXCHANGE COMMAND CENTER                   ║
╚═══════════════════════════════════════════════════════════════╝

🎯 CORE COMMANDS:
  fxs, foodx-save      💾 Save enhanced state with AI context
  fxn, foodx-new       🆕 Generate new chat with full context  
  fxstart, foodx-start ▶️  Start complete dev environment
  fxsync, foodx-sync   🔄 Sync all Git repositories

📊 MONITORING:
  fxstatus, foodx-status  📈 Check system health & progress
  fxlog, foodx-log        📝 View session history
  fxrepo, foodx-repo      🔍 Check repository status

🛠️ UTILITIES:
  fxcd-front    📁 Go to Frontend directory
  fxcd-back     📁 Go to Backend directory  
  fxcd-docs     📁 Go to Documentation directory
  fxtest        🧪 Run all tests
  fxbuild       🏗️  Build all projects

📈 PRODUCTIVITY WORKFLOW:
  
  🌅 MORNING ROUTINE:
  1. fxstatus    - Check system health
  2. fxsync      - Sync all repos
  3. fxstart     - Start environment
  
  💾 EVERY 2 HOURS:
  1. fxs         - Save state with notes
  
  🌙 END OF DAY:
  1. fxs         - Final state save
  2. fxsync      - Push all changes
  
💡 TIPS:
  • Always run fxs before closing chat
  • Use detailed notes in state saves
  • Check fxstatus if something seems wrong
  • Run fxsync before starting new features

📚 DOCUMENTATION:
  • State files: $($global:FoodXConfig.QuickStatePath)
  • Sessions: $($global:FoodXConfig.SessionsPath)
  • Artifacts: $($global:FoodXConfig.ArtifactsPath)

🚀 CURRENT FOCUS: RFQ System with AI Integration

"@ -ForegroundColor Cyan
}

# Directory navigation shortcuts
function Set-FoodXFrontend { cd $global:FoodXConfig.FrontendPath; pwd }
function Set-FoodXBackend { cd $global:FoodXConfig.BackendPath; pwd }
function Set-FoodXDocs { cd $global:FoodXConfig.DocsPath; pwd }

# View session history
function Get-FoodXHistory {
    Write-Host "`n📜 FOODXCHANGE SESSION HISTORY" -ForegroundColor Cyan
    Write-Host "══════════════════════════════" -ForegroundColor Cyan
    
    $sessions = Get-ChildItem "$($global:FoodXConfig.SessionsPath)\*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 10
    
    foreach ($session in $sessions) {
        $content = Get-Content $session.FullName -First 20
        $dateMatch = $content | Select-String "Generated: (.+)" | Select-Object -First 1
        
        Write-Host "`n📄 $($session.BaseName)" -ForegroundColor Yellow
        if ($dateMatch) {
            Write-Host "   $($dateMatch.Matches[0].Groups[1].Value)" -ForegroundColor Gray
        }
    }
    
    Write-Host "`n💡 Use 'code <session-file>' to view details" -ForegroundColor Green
}

# Initialize the system
Initialize-FoodXDirectories

# Create aliases - Short versions
Set-Alias -Name fxs -Value Save-FoodXState -Scope Global
Set-Alias -Name fxn -Value New-FoodXChat -Scope Global
Set-Alias -Name fxstart -Value Start-FoodXEnvironment -Scope Global
Set-Alias -Name fxsync -Value Sync-FoodXRepos -Scope Global
Set-Alias -Name fxstatus -Value Get-FoodXStatus -Scope Global
Set-Alias -Name fxhelp -Value Show-FoodXHelp -Scope Global
Set-Alias -Name fxlog -Value Get-FoodXHistory -Scope Global
Set-Alias -Name fxcd-front -Value Set-FoodXFrontend -Scope Global
Set-Alias -Name fxcd-back -Value Set-FoodXBackend -Scope Global
Set-Alias -Name fxcd-docs -Value Set-FoodXDocs -Scope Global

# Create aliases - Long versions
Set-Alias -Name foodx-save -Value Save-FoodXState -Scope Global
Set-Alias -Name foodx-new -Value New-FoodXChat -Scope Global
Set-Alias -Name foodx-start -Value Start-FoodXEnvironment -Scope Global
Set-Alias -Name foodx-sync -Value Sync-FoodXRepos -Scope Global
Set-Alias -Name foodx-status -Value Get-FoodXStatus -Scope Global
Set-Alias -Name foodx-help -Value Show-FoodXHelp -Scope Global
Set-Alias -Name foodx-log -Value Get-FoodXHistory -Scope Global
Set-Alias -Name foodx-repo -Value Get-GitRepoStatus -Scope Global

# Show startup message with all commands
Clear-Host
Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║              🍔 FOODXCHANGE ENHANCED STATE SYSTEM 🍔          ║
║                        Version 2.0                            ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

Write-Host "✅ FoodXchange Enhanced System Loaded!" -ForegroundColor Green
Write-Host "📍 Current Directory: $(Get-Location)" -ForegroundColor Yellow

Write-Host @"

🚀 QUICK COMMANDS:
   Save State:  fxs        New Chat:    fxn
   Start Work:  fxstart    Sync Repos:  fxsync
   Status:      fxstatus   Help:        fxhelp

💡 PRODUCTIVITY TIP: Start with 'fxstatus' to check system health

🎯 CURRENT SPRINT: RFQ System with AI Integration (Module 1 of 4)

"@ -ForegroundColor Cyan

# Auto-check status on load
Get-FoodXStatus

Write-Host "`n📝 Type 'fxhelp' for all commands and productivity tips" -ForegroundColor Green
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
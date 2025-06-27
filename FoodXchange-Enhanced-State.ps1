# FoodXchange Enhanced State Management System v2.0
# Comprehensive session tracking with AI context preservation
# Author: FoodXchange Assistant for Udi Stryk
# Date: 2025-06-27

param(
    [string]$Command = "save",
    [string]$OutputPath = "C:\Users\foodz\Documents\FoodXchange-QuickState",
    [switch]$Verbose = $true
)

# Change to documentation directory first
Set-Location "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation" -ErrorAction SilentlyContinue

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║     FoodXchange Enhanced State Management System v2.0         ║
║              Comprehensive Session Tracking                   ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Configuration
$global:FoodXConfig = @{
    FrontendPath = "C:\Users\foodz\Documents\GitHub\Development\foodxchange-app"
    BackendPath = "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend"
    DocsPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation"
    StatePath = $OutputPath
    Timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    SessionDate = Get-Date -Format "yyyy-MM-dd HH:mm"
}

# Ensure state directory exists
if (!(Test-Path $global:FoodXConfig.StatePath)) {
    New-Item -ItemType Directory -Path $global:FoodXConfig.StatePath -Force | Out-Null
    New-Item -ItemType Directory -Path "$($global:FoodXConfig.StatePath)\sessions" -Force | Out-Null
    New-Item -ItemType Directory -Path "$($global:FoodXConfig.StatePath)\artifacts" -Force | Out-Null
}

# Function to get detailed Git information
function Get-EnhancedGitStatus {
    param([string]$RepoPath, [string]$RepoName)
    
    if (Test-Path "$RepoPath\.git") {
        Push-Location $RepoPath
        
        $status = @{
            Branch = git branch --show-current 2>$null
            LastCommit = git log -1 --pretty=format:"%H" 2>$null
            LastCommitMessage = git log -1 --pretty=format:"%s" 2>$null
            LastCommitDate = git log -1 --pretty=format:"%ai" 2>$null
            LastCommitAuthor = git log -1 --pretty=format:"%an" 2>$null
            UncommittedChanges = @(git status --porcelain 2>$null)
            CommitHistory = @(git log --oneline -10 2>$null)
            RemoteUrl = git config --get remote.origin.url 2>$null
            FileChanges = @{
                Added = @(git diff --name-only --diff-filter=A 2>$null)
                Modified = @(git diff --name-only --diff-filter=M 2>$null)
                Deleted = @(git diff --name-only --diff-filter=D 2>$null)
            }
        }
        
        Pop-Location
        return $status
    }
    return $null
}

# Function to analyze project changes
function Get-ProjectChanges {
    param([string]$RepoPath, [string]$LastStateFile)
    
    $changes = @{
        NewFiles = @()
        ModifiedFiles = @()
        DeletedFiles = @()
        Summary = ""
    }
    
    if (Test-Path $LastStateFile) {
        $lastState = Get-Content $LastStateFile -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($lastState -and $lastState.LastCommit) {
            Push-Location $RepoPath
            
            # Get changes since last state
            $changes.NewFiles = @(git diff --name-only --diff-filter=A "$($lastState.LastCommit)..HEAD" 2>$null)
            $changes.ModifiedFiles = @(git diff --name-only --diff-filter=M "$($lastState.LastCommit)..HEAD" 2>$null)
            $changes.DeletedFiles = @(git diff --name-only --diff-filter=D "$($lastState.LastCommit)..HEAD" 2>$null)
            
            $totalChanges = $changes.NewFiles.Count + $changes.ModifiedFiles.Count + $changes.DeletedFiles.Count
            $changes.Summary = "$totalChanges files changed (${($changes.NewFiles.Count)} added, ${($changes.ModifiedFiles.Count)} modified, ${($changes.DeletedFiles.Count)} deleted)"
            
            Pop-Location
        }
    }
    
    return $changes
}

# Function to generate comprehensive state document
function New-EnhancedStateDocument {
    Write-Host "`n📝 Generating comprehensive state document..." -ForegroundColor Yellow
    
    # Get Git status for all repos
    $frontendGit = Get-EnhancedGitStatus -RepoPath $global:FoodXConfig.FrontendPath -RepoName "Frontend"
    $backendGit = Get-EnhancedGitStatus -RepoPath $global:FoodXConfig.BackendPath -RepoName "Backend"
    $docsGit = Get-EnhancedGitStatus -RepoPath $global:FoodXConfig.DocsPath -RepoName "Documentation"
    
    # Get last state file
    $lastStateFile = Get-ChildItem "$($global:FoodXConfig.StatePath)\sessions\state_*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    # Analyze changes
    $frontendChanges = if ($lastStateFile) { Get-ProjectChanges -RepoPath $global:FoodXConfig.FrontendPath -LastStateFile $lastStateFile.FullName } else { @{Summary = "First state capture"} }
    $backendChanges = if ($lastStateFile) { Get-ProjectChanges -RepoPath $global:FoodXConfig.BackendPath -LastStateFile $lastStateFile.FullName } else { @{Summary = "First state capture"} }
    
    $stateDoc = @"
# FoodXchange Comprehensive Session State
**Generated**: $($global:FoodXConfig.SessionDate)
**Developer**: Udi Stryk (foodz)
**Session ID**: $($global:FoodXConfig.Timestamp)

## 🎯 Project Overview
- **Name**: FoodXchange B2B Trading Platform (FDX)
- **Goal**: Achieve 50%+ productivity increase through automation
- **Stage**: Solo testing MVP development
- **Architecture**: React + Node.js/Express + MongoDB + Azure AI

## 📊 Repository Status

### Frontend (foodxchange-app)
- **Branch**: $($frontendGit.Branch)
- **Last Commit**: $($frontendGit.LastCommitMessage)
- **Changes Since Last Session**: $($frontendChanges.Summary)
- **Uncommitted**: $($frontendGit.UncommittedChanges.Count) files

### Backend (Foodxchange-backend)
- **Branch**: $($backendGit.Branch)
- **Last Commit**: $($backendGit.LastCommitMessage)
- **Changes Since Last Session**: $($backendChanges.Summary)
- **Uncommitted**: $($backendGit.UncommittedChanges.Count) files

### Documentation
- **Branch**: $($docsGit.Branch)
- **Last Commit**: $($docsGit.LastCommitMessage)
- **Uncommitted**: $($docsGit.UncommittedChanges.Count) files

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
[AUTO-FILLED BY SCRIPT - ADD YOUR NOTES HERE]

## 🎨 Artifacts Created This Session
[AUTO-FILLED BY SCRIPT - LIST ALL ARTIFACTS]

## 🔑 Key Decisions Made
[AUTO-FILLED BY SCRIPT - IMPORTANT DECISIONS]

## 🚧 Current Implementation Status

### ✅ Completed
- Basic authentication (JWT)
- Role-based access (Buyer/Seller/Admin/Contractor/Agent)
- Company profiles
- Basic CRUD operations

### 🔄 In Progress
- RFQ system with AI integration
- Email template system
- Supplier matching algorithm
- Multi-language support

### 📋 TODO Next
- Azure Cognitive Services setup
- RFQ data models
- Email automation
- AI agent development

## 🐛 Known Issues
1. Frontend branch appears empty - needs investigation
2. [Add any current issues]

## 💡 Session Notes & Ideas
[ADD YOUR THOUGHTS HERE]

## 🔧 Quick Commands
\`\`\`powershell
# Save state: fxs
# New chat: fxn
# Continue work: fxstart
# Help: fxhelp
\`\`\`

## 📈 Productivity Metrics
- Session Duration: [CALCULATED]
- Commits Made: [CALCULATED]
- Files Changed: [CALCULATED]

## 🎯 Continue From
[SPECIFIC NEXT STEPS]

---
*FoodXchange Enhanced State v2.0*
"@

    # Save JSON state for comparison
    $jsonState = @{
        SessionId = $global:FoodXConfig.Timestamp
        Timestamp = $global:FoodXConfig.SessionDate
        Frontend = $frontendGit
        Backend = $backendGit
        Documentation = $docsGit
        Changes = @{
            Frontend = $frontendChanges
            Backend = $backendChanges
        }
    }
    
    $jsonState | ConvertTo-Json -Depth 10 | Out-File -FilePath "$($global:FoodXConfig.StatePath)\sessions\state_$($global:FoodXConfig.Timestamp).json" -Encoding UTF8
    
    return $stateDoc
}

# Function to generate AI context questionnaire
function New-AIContextQuestionnaire {
    $questionnaire = @"
# FoodXchange AI Context Questionnaire
*To achieve 98% understanding of previous session*

## 📋 Required Information Checklist

### 1. Session Context
- [ ] What specific feature/module were you working on?
- [ ] What was the last code change you made?
- [ ] Any errors or blockers encountered?

### 2. RFQ Module Status (if applicable)
- [ ] RFQ data model defined? (Y/N)
- [ ] Email templates created? (Y/N)
- [ ] AI integration started? (Y/N)
- [ ] Machine vision setup? (Y/N)

### 3. Technical Details
- [ ] Any new npm packages installed?
- [ ] Database schema changes?
- [ ] API endpoints created/modified?
- [ ] Frontend components added?

### 4. Azure Services
- [ ] Cognitive Services configured?
- [ ] Which services are active?
- [ ] API keys stored in .env?

### 5. Testing Status
- [ ] What was tested?
- [ ] Test results?
- [ ] Performance metrics?

### 6. Expert/Contractor Types Needed
Food industry experts to consider:
- Graphic designers (packaging/branding)
- Regulatory compliance advisors
- Kosher certification agencies
- Halal certification agencies
- Organic certification consultants
- Gluten-free advisors
- QA/Quality control experts
- Food safety consultants
- Import/export specialists
- Logistics coordinators
- Translation services
- Nutritionist consultants
- Packaging engineers
- Supply chain analysts
- Food photographers
- Legal advisors (food law)
- Insurance brokers
- Lab testing services

### 7. Immediate Next Steps
What are the next 3 tasks to complete?
1. ___________________________
2. ___________________________
3. ___________________________

## 📎 Required Attachments
Please provide if available:
- [ ] Error logs or screenshots
- [ ] Code snippets you were working on
- [ ] API responses or test data
- [ ] Design mockups or wireframes
- [ ] Email templates drafted

## 🎯 Specific Questions About Last Session
[DYNAMIC QUESTIONS BASED ON STATE]

---
*Complete this questionnaire for optimal session continuity*
"@
    
    return $questionnaire
}

# Function to save session state
function Save-SessionState {
    Write-Host "`n💾 SAVING COMPREHENSIVE STATE..." -ForegroundColor Yellow
    
    # Generate state document
    $stateDoc = New-EnhancedStateDocument
    
    # Save main state
    $statePath = "$($global:FoodXConfig.StatePath)\sessions\state_$($global:FoodXConfig.Timestamp).md"
    $stateDoc | Out-File -FilePath $statePath -Encoding UTF8
    
    # Save to latest
    $stateDoc | Out-File -FilePath "$($global:FoodXConfig.StatePath)\latest.md" -Encoding UTF8
    
    # Generate questionnaire
    $questionnaire = New-AIContextQuestionnaire
    $questionnaire | Out-File -FilePath "$($global:FoodXConfig.StatePath)\questionnaire_$($global:FoodXConfig.Timestamp).md" -Encoding UTF8
    
    # Copy to clipboard
    $stateDoc | Set-Clipboard
    
    Write-Host "✅ State saved to: $statePath" -ForegroundColor Green
    Write-Host "📋 State copied to clipboard!" -ForegroundColor Green
    Write-Host "📝 Opening state document for your notes..." -ForegroundColor Yellow
    
    # Open in notepad for notes
    Start-Process notepad.exe -ArgumentList $statePath -Wait
    
    # Update Git repos
    Write-Host "`n🔄 Updating Git repositories..." -ForegroundColor Yellow
    Update-GitRepos
    
    Write-Host "`n✅ SESSION STATE SAVED SUCCESSFULLY!" -ForegroundColor Green
}

# Function to update Git repositories
function Update-GitRepos {
    $repos = @(
        @{Path = $global:FoodXConfig.DocsPath; Name = "Documentation"},
        @{Path = $global:FoodXConfig.FrontendPath; Name = "Frontend"},
        @{Path = $global:FoodXConfig.BackendPath; Name = "Backend"}
    )
    
    foreach ($repo in $repos) {
        if (Test-Path "$($repo.Path)\.git") {
            Write-Host "  📂 Updating $($repo.Name)..." -ForegroundColor Cyan
            Push-Location $repo.Path
            
            $changes = @(git status --porcelain 2>$null)
            if ($changes.Count -gt 0) {
                git add . 2>$null
                git commit -m "Auto-save: Session $($global:FoodXConfig.Timestamp)" 2>$null
                git push 2>$null
                Write-Host "    ✓ Committed and pushed $($changes.Count) changes" -ForegroundColor Green
            } else {
                Write-Host "    ✓ No changes to commit" -ForegroundColor Gray
            }
            
            Pop-Location
        }
    }
}

# Function to generate new chat message
function New-ChatMessage {
    Write-Host "`n📋 GENERATING NEW CHAT MESSAGE..." -ForegroundColor Yellow
    
    # Read latest state
    $latestState = Get-Content "$($global:FoodXConfig.StatePath)\latest.md" -Raw -ErrorAction SilentlyContinue
    
    # Get latest questionnaire
    $latestQuestionnaire = Get-ChildItem "$($global:FoodXConfig.StatePath)\questionnaire_*.md" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    $newChatMessage = @"
I'm continuing work on my FoodXchange B2B platform (FDX.trading).

## 🚀 Project Context
- **Developer**: Udi Stryk (foodz)
- **Goal**: Solo MVP testing to achieve 50%+ productivity increase
- **Architecture**: React + Node.js/Express + MongoDB + Azure AI
- **Revenue Model**: Commission-based (buyers/sellers/contractors)
- **Azure**: Using Founder's Hub (no budget limits)

## 📊 Repository Locations
- **Frontend**: https://github.com/foodXchange/foodxchange-app
  Local: C:\Users\foodz\Documents\GitHub\Development\foodxchange-app
- **Backend**: https://github.com/foodXchange/Foodxchange-backend
  Local: C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend
- **Docs**: https://github.com/foodXchange/FoodXchange-Documentation
  Local: C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation

## 🏗️ 4-Module Roadmap
1. **RFQ System** (Current Priority)
   - AI/Machine vision for request creation
   - Email templates for supplier outreach
   - Multi-supplier price comparison
   
2. **Adaptation Module**
   - Expert marketplace (designers, QA, compliance, etc.)
   
3. **Orders Management**
   - PO/Invoice matching, shipment tracking
   
4. **Billing System**
   - Commission tracking, revenue sharing

## 📋 Latest State Document
[Attached: state_*.md from $($global:FoodXConfig.StatePath)]

## ❓ Context Questions
Please review the attached questionnaire and state document to understand what was accomplished in the previous session.

## 🎯 Today's Goal
[SPECIFY YOUR FOCUS FOR THIS SESSION]

Please analyze the attached state document and help me continue development.
"@
    
    $newChatMessage | Set-Clipboard
    
    Write-Host "✅ Chat message copied to clipboard!" -ForegroundColor Green
    Write-Host "📎 Don't forget to attach:" -ForegroundColor Yellow
    Write-Host "   - Latest state document" -ForegroundColor White
    Write-Host "   - Questionnaire (if needed)" -ForegroundColor White
    Write-Host "   - Any error logs or code snippets" -ForegroundColor White
}

# Function to start development environment
function Start-DevelopmentEnvironment {
    Write-Host "`n🚀 STARTING FOODXCHANGE ENVIRONMENT..." -ForegroundColor Yellow
    
    # Check latest state and show summary
    $latestState = Get-ChildItem "$($global:FoodXConfig.StatePath)\sessions\state_*.json" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latestState) {
        $state = Get-Content $latestState.FullName -Raw | ConvertFrom-Json
        Write-Host "`n📊 Last Session Summary:" -ForegroundColor Cyan
        Write-Host "   Date: $($state.Timestamp)" -ForegroundColor White
        Write-Host "   Frontend: $($state.Frontend.Branch) branch" -ForegroundColor White
        Write-Host "   Backend: $($state.Backend.Branch) branch" -ForegroundColor White
    }
    
    Write-Host "`n▶️  Starting MongoDB..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd C:\; mongod"
    
    Start-Sleep -Seconds 3
    
    Write-Host "▶️  Starting Backend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($global:FoodXConfig.BackendPath)'; npm start"
    
    Start-Sleep -Seconds 3
    
    Write-Host "▶️  Starting Frontend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($global:FoodXConfig.FrontendPath)'; npm start"
    
    Write-Host "▶️  Opening VS Code..." -ForegroundColor Yellow
    Start-Process code -ArgumentList $global:FoodXConfig.FrontendPath
    Start-Process code -ArgumentList $global:FoodXConfig.BackendPath
    Start-Process code -ArgumentList $global:FoodXConfig.DocsPath
    
    Write-Host "`n⏳ Waiting for services to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    
    Write-Host "`n✅ ENVIRONMENT READY!" -ForegroundColor Green
    Write-Host "📱 Frontend: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "🔧 Backend: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "🗄️  MongoDB: mongodb://localhost:27017" -ForegroundColor Cyan
    
    # Show productivity tips
    Show-ProductivityTips
}

# Function to show productivity tips
function Show-ProductivityTips {
    Write-Host "`n📈 PRODUCTIVITY TIPS:" -ForegroundColor Yellow
    Write-Host "1. Use 'fxs' to save state before ending session" -ForegroundColor White
    Write-Host "2. Use 'fxn' to generate new chat context" -ForegroundColor White
    Write-Host "3. Commit frequently with descriptive messages" -ForegroundColor White
    Write-Host "4. Update state document with accomplishments" -ForegroundColor White
    Write-Host "5. Use the questionnaire for better AI context" -ForegroundColor White
    
    Write-Host "`n🔄 DAILY ROUTINE:" -ForegroundColor Yellow
    Write-Host "Morning: fxstart → Review state → Plan tasks" -ForegroundColor White
    Write-Host "During: Regular commits → Update notes" -ForegroundColor White
    Write-Host "Evening: fxs → Document progress → Plan tomorrow" -ForegroundColor White
}

# Main execution
switch ($Command.ToLower()) {
    "save" { Save-SessionState }
    "new" { New-ChatMessage }
    "start" { Start-DevelopmentEnvironment }
    "continue" { Start-DevelopmentEnvironment }
    default { Save-SessionState }
}
# FoodXchange State Generator PowerShell Script
# This script captures the complete state of your FoodXchange project for easy continuation
# Author: FoodXchange Assistant
# Date: 2025-06-27

param(
    [string]$OutputPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-State",
    [switch]$IncludeCode = $true,
    [switch]$CompressOutput = $true
)

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║           FoodXchange Complete State Generator                ║
║                  Session Continuation Tool                    ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Configuration
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$sessionDate = Get-Date -Format "yyyy-MM-dd"
$config = @{
    FrontendPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange"
    BackendPath = "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend"
    DocsPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation"
    StatePath = $OutputPath
}

# Create state directory structure
function Initialize-StateDirectory {
    Write-Host "`n📁 Creating state directory structure..." -ForegroundColor Yellow
    
    $directories = @(
        "$($config.StatePath)",
        "$($config.StatePath)\sessions",
        "$($config.StatePath)\code-snapshots",
        "$($config.StatePath)\progress",
        "$($config.StatePath)\decisions",
        "$($config.StatePath)\issues"
    )
    
    foreach ($dir in $directories) {
        if (!(Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Host "  ✓ Created: $dir" -ForegroundColor Green
        }
    }
}

# Capture current Git status
function Get-GitStatus {
    param([string]$RepoPath, [string]$RepoName)
    
    Write-Host "`n🔍 Analyzing $RepoName repository..." -ForegroundColor Yellow
    
    if (Test-Path "$RepoPath\.git") {
        Push-Location $RepoPath
        
        $status = @{
            Branch = git branch --show-current
            LastCommit = git log -1 --pretty=format:"%H"
            LastCommitMessage = git log -1 --pretty=format:"%s"
            LastCommitDate = git log -1 --pretty=format:"%ai"
            UncommittedChanges = git status --porcelain
            RemoteUrl = git config --get remote.origin.url
        }
        
        Pop-Location
        return $status
    }
    return $null
}

# Analyze project structure and dependencies
function Get-ProjectAnalysis {
    param([string]$ProjectPath, [string]$ProjectType)
    
    $analysis = @{
        Type = $ProjectType
        Path = $ProjectPath
        Structure = @()
        Dependencies = @{}
        Configuration = @{}
    }
    
    if ($ProjectType -eq "Frontend") {
        if (Test-Path "$ProjectPath\package.json") {
            $packageJson = Get-Content "$ProjectPath\package.json" -Raw | ConvertFrom-Json
            $analysis.Dependencies = $packageJson.dependencies
            $analysis.Name = $packageJson.name
            $analysis.Version = $packageJson.version
            $analysis.Scripts = $packageJson.scripts
        }
        
        # Check for key frontend files
        $analysis.KeyFiles = @{
            "src/App.js" = Test-Path "$ProjectPath\src\App.js"
            "src/index.js" = Test-Path "$ProjectPath\src\index.js"
            "public/index.html" = Test-Path "$ProjectPath\public\index.html"
            ".env" = Test-Path "$ProjectPath\.env"
        }
    }
    elseif ($ProjectType -eq "Backend") {
        if (Test-Path "$ProjectPath\package.json") {
            $packageJson = Get-Content "$ProjectPath\package.json" -Raw | ConvertFrom-Json
            $analysis.Dependencies = $packageJson.dependencies
            $analysis.Name = $packageJson.name
            $analysis.Version = $packageJson.version
            $analysis.Scripts = $packageJson.scripts
        }
        
        # Check for key backend files
        $analysis.KeyFiles = @{
            "server.js" = Test-Path "$ProjectPath\server.js"
            "app.js" = Test-Path "$ProjectPath\app.js"
            ".env" = Test-Path "$ProjectPath\.env"
            "models/" = Test-Path "$ProjectPath\models"
            "routes/" = Test-Path "$ProjectPath\routes"
        }
    }
    
    return $analysis
}

# Generate comprehensive state document
function New-StateDocument {
    Write-Host "`n📝 Generating comprehensive state document..." -ForegroundColor Yellow
    
    $stateDoc = @"
# FoodXchange Project State - $sessionDate

## 🚀 Project Overview
- **Project Name**: FoodXchange B2B Trading Platform
- **Developer**: Udi Stryk (foodz)
- **State Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
- **Session ID**: $timestamp

## 📊 Repository Status

### Frontend Repository
"@
    
    $frontendGit = Get-GitStatus -RepoPath $config.FrontendPath -RepoName "Frontend"
    if ($frontendGit) {
        $stateDoc += @"

- **Repository**: foodxchange-app
- **Branch**: $($frontendGit.Branch)
- **Last Commit**: $($frontendGit.LastCommit)
- **Commit Message**: $($frontendGit.LastCommitMessage)
- **Commit Date**: $($frontendGit.LastCommitDate)
- **Uncommitted Changes**: $(if($frontendGit.UncommittedChanges){"Yes - See details below"}else{"None"})
"@
    }
    
    $stateDoc += @"

### Backend Repository
"@
    
    $backendGit = Get-GitStatus -RepoPath $config.BackendPath -RepoName "Backend"
    if ($backendGit) {
        $stateDoc += @"

- **Repository**: Foodxchange-backend
- **Branch**: $($backendGit.Branch)
- **Last Commit**: $($backendGit.LastCommit)
- **Commit Message**: $($backendGit.LastCommitMessage)
- **Commit Date**: $($backendGit.LastCommitDate)
- **Uncommitted Changes**: $(if($backendGit.UncommittedChanges){"Yes - See details below"}else{"None"})
"@
    }
    
    # Add project analysis
    $frontendAnalysis = Get-ProjectAnalysis -ProjectPath $config.FrontendPath -ProjectType "Frontend"
    $backendAnalysis = Get-ProjectAnalysis -ProjectPath $config.BackendPath -ProjectType "Backend"
    
    $stateDoc += @"

## 🏗️ Project Structure Analysis

### Frontend (React)
- **Package Name**: $($frontendAnalysis.Name)
- **Version**: $($frontendAnalysis.Version)
- **Key Dependencies**:
$(($frontendAnalysis.Dependencies.PSObject.Properties | ForEach-Object { "  - $($_.Name): $($_.Value)" }) -join "`n")

### Backend (Node.js)
- **Package Name**: $($backendAnalysis.Name)
- **Version**: $($backendAnalysis.Version)
- **Key Dependencies**:
$(($backendAnalysis.Dependencies.PSObject.Properties | ForEach-Object { "  - $($_.Name): $($_.Value)" }) -join "`n")

## 🎯 Current Implementation Status

### Completed Features
- ✅ Basic React frontend structure
- ✅ Node.js/Express backend setup
- ✅ MongoDB connection configuration
- ✅ Authentication system (JWT-based)
- ✅ Role-based access (Buyer, Seller, Admin, Contractor, Agent)
- ✅ Product catalog with CRUD operations
- ✅ RFQ (Request for Quotation) management
- ✅ Company profile management

### In Progress
- 🔄 AI Integration (Azure Cognitive Services)
- 🔄 Advanced supplier matching algorithm
- 🔄 Multi-language support (Hebrew, English, German, French)
- 🔄 Payment integration
- 🔄 Advanced analytics dashboard

### Pending Features
- ⏳ Real-time chat system
- ⏳ Document management system
- ⏳ Automated compliance checking
- ⏳ Mobile app development
- ⏳ Advanced reporting features

## 🐛 Known Issues & Blockers

1. **Frontend not starting**: Check if npm install has been run
2. **MongoDB connection**: Ensure MongoDB is running on port 27017
3. **Port conflicts**: Frontend (3000), Backend (5000)

## 📋 Next Steps

1. **Immediate Tasks**:
   - Complete AI integration setup
   - Test supplier matching algorithm
   - Implement multi-language support
   
2. **This Week**:
   - Deploy to Azure
   - Set up CI/CD pipeline
   - Complete user testing

3. **This Month**:
   - Launch MVP
   - Onboard first 10 suppliers
   - Gather user feedback

## 🔧 Quick Commands

### Start Development Environment
\`\`\`bash
# Terminal 1 - Start MongoDB
mongod

# Terminal 2 - Start Backend
cd $($config.BackendPath)
npm start

# Terminal 3 - Start Frontend
cd $($config.FrontendPath)
npm start
\`\`\`

### Git Commands
\`\`\`bash
# Push all changes
cd $($config.FrontendPath) && git add . && git commit -m "Update frontend" && git push
cd $($config.BackendPath) && git add . && git commit -m "Update backend" && git push
cd $($config.DocsPath) && git add . && git commit -m "Update documentation" && git push
\`\`\`

## 📝 Session Notes

[Add your session notes here]

---

*Generated by FoodXchange State Generator v1.0*
"@
    
    return $stateDoc
}

# Create quick continuation script
function New-ContinuationScript {
    Write-Host "`n🚀 Creating continuation script..." -ForegroundColor Yellow
    
    $continuationScript = @"
# FoodXchange Quick Continuation Script
# Generated: $timestamp

Write-Host "🚀 Starting FoodXchange Development Environment..." -ForegroundColor Cyan

# Set paths
\`$frontend = "$($config.FrontendPath)"
\`$backend = "$($config.BackendPath)"
\`$docs = "$($config.DocsPath)"

# Open VS Code
Write-Host "Opening VS Code..." -ForegroundColor Yellow
code \`$frontend
code \`$backend
code \`$docs

# Start MongoDB
Write-Host "Starting MongoDB..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "mongod"

# Wait for MongoDB to start
Start-Sleep -Seconds 3

# Start Backend
Write-Host "Starting Backend Server..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd \`$backend; npm start"

# Wait for backend to start
Start-Sleep -Seconds 5

# Start Frontend
Write-Host "Starting Frontend..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd \`$frontend; npm start"

# Open browser
Start-Sleep -Seconds 5
Start-Process "http://localhost:3000"

Write-Host "\`n✅ FoodXchange Development Environment Started!" -ForegroundColor Green
Write-Host "Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "Backend: http://localhost:5000" -ForegroundColor Cyan
Write-Host "MongoDB: mongodb://localhost:27017" -ForegroundColor Cyan
"@
    
    return $continuationScript
}

# Main execution
Initialize-StateDirectory

# Generate state document
$stateDocument = New-StateDocument
$stateFilePath = "$($config.StatePath)\sessions\state_$timestamp.md"
$stateDocument | Out-File -FilePath $stateFilePath -Encoding UTF8
Write-Host "✅ State document saved: $stateFilePath" -ForegroundColor Green

# Generate continuation script
$continuationScript = New-ContinuationScript
$continuationPath = "$($config.StatePath)\continue_session.ps1"
$continuationScript | Out-File -FilePath $continuationPath -Encoding UTF8
Write-Host "✅ Continuation script saved: $continuationPath" -ForegroundColor Green

# Create README for the state directory
$readmeContent = @"
# FoodXchange State Management

This directory contains session states and continuation tools for the FoodXchange project.

## Quick Start

1. To continue from last session:
   \`\`\`powershell
   .\continue_session.ps1
   \`\`\`

2. To generate new state:
   \`\`\`powershell
   .\FoodXchange-State-Generator.ps1
   \`\`\`

## Directory Structure

- **sessions/**: Individual session state files
- **code-snapshots/**: Code backups at specific points
- **progress/**: Development progress tracking
- **decisions/**: Architecture and design decisions
- **issues/**: Known issues and resolutions

## Latest Session

- **File**: sessions\state_$timestamp.md
- **Generated**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

$readmeContent | Out-File -FilePath "$($config.StatePath)\README.md" -Encoding UTF8

# Create a compressed archive if requested
if ($CompressOutput) {
    Write-Host "`n📦 Creating compressed archive..." -ForegroundColor Yellow
    $archivePath = "$($config.StatePath)\FoodXchange_State_$timestamp.zip"
    
    Compress-Archive -Path "$($config.StatePath)\*" -DestinationPath $archivePath -Force
    Write-Host "✅ Archive created: $archivePath" -ForegroundColor Green
}

# Display summary
Write-Host "`n" -NoNewline
Write-Host @"
╔═══════════════════════════════════════════════════════════════╗
║                    STATE GENERATION COMPLETE                  ║
╚═══════════════════════════════════════════════════════════════╝

📁 State Directory: $($config.StatePath)
📄 State Document: $stateFilePath
🚀 Continuation Script: $continuationPath

To continue your session in a new chat:
1. Copy the state document content
2. Paste it at the beginning of your new chat
3. Run the continuation script to restore your environment

"@ -ForegroundColor Cyan

Write-Host "Press any key to open the state document..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
notepad $stateFilePath
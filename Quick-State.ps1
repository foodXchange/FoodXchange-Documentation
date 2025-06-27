# FoodXchange Quick State System - Enhanced Version
# Save this as: C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation\Quick-State.ps1

param(
    [Parameter(Position=0)]
    [ValidateSet('save', 'load', 'new', 'continue')]
    [string]$Action = 'save'
)

# Configuration
$config = @{
    FrontendPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange"
    BackendPath = "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend"
    DocsPath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Documentation"
    StatePath = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-State"
    QuickStatePath = "C:\Users\foodz\Documents\FoodXchange-QuickState"
}

# Ensure Quick State directory exists
if (!(Test-Path $config.QuickStatePath)) {
    New-Item -ItemType Directory -Path $config.QuickStatePath -Force | Out-Null
}

function Save-QuickState {
    Write-Host "`n💾 SAVING QUICK STATE..." -ForegroundColor Cyan
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $date = Get-Date -Format "yyyy-MM-dd HH:mm"
    
    # Get Git status for all repos
    $gitStatus = @{}
    foreach ($repo in @('Frontend', 'Backend', 'Docs')) {
        $path = switch ($repo) {
            'Frontend' { $config.FrontendPath }
            'Backend' { $config.BackendPath }
            'Docs' { $config.DocsPath }
        }
        
        if (Test-Path "$path\.git") {
            Push-Location $path
            $gitStatus[$repo] = @{
                Branch = git branch --show-current
                LastCommit = git log -1 --pretty=format:"%s"
                Changes = (git status --porcelain).Count
            }
            Pop-Location
        }
    }
    
    # Create quick state content
    $quickState = @"
# FoodXchange Quick State - $date

## 🚀 Quick Continue Command
\`\`\`powershell
irm https://raw.githubusercontent.com/foodXchange/FoodXchange-Documentation/main/Quick-State.ps1 | iex -Args continue
\`\`\`

## 📊 Current Status
- Frontend Branch: $($gitStatus.Frontend.Branch) | Changes: $($gitStatus.Frontend.Changes)
- Backend Branch: $($gitStatus.Backend.Branch) | Changes: $($gitStatus.Backend.Changes)
- Docs Branch: $($gitStatus.Docs.Branch) | Changes: $($gitStatus.Docs.Changes)

## 🎯 Last Working On
[AUTO-FILL YOUR LAST TASK HERE]

## 📝 Quick Notes
[ADD ANY IMPORTANT NOTES]

## 🔧 Environment
- MongoDB: localhost:27017
- Backend: http://localhost:5000
- Frontend: http://localhost:3000

*Generated: $date*
"@
    
    # Save to multiple locations for easy access
    $quickState | Out-File -FilePath "$($config.QuickStatePath)\latest.md" -Encoding UTF8
    $quickState | Out-File -FilePath "$($config.StatePath)\sessions\quick_$timestamp.md" -Encoding UTF8
    
    # Also copy to clipboard
    $quickState | Set-Clipboard
    
    Write-Host "✅ Quick state saved!" -ForegroundColor Green
    Write-Host "📋 State copied to clipboard!" -ForegroundColor Yellow
    Write-Host "📄 File: $($config.QuickStatePath)\latest.md" -ForegroundColor Gray
    
    # Open in notepad for quick edit
    Start-Process notepad "$($config.QuickStatePath)\latest.md"
    
    Write-Host "`n📝 Add your notes in Notepad, then save and close." -ForegroundColor Cyan
}

function Start-QuickEnvironment {
    Write-Host "`n🚀 STARTING FOODXCHANGE ENVIRONMENT..." -ForegroundColor Cyan
    
    # Start MongoDB
    Write-Host "▶️  Starting MongoDB..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "mongod" -WindowStyle Minimized
    Start-Sleep -Seconds 2
    
    # Start Backend
    Write-Host "▶️  Starting Backend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($config.BackendPath)'; npm start" -WindowStyle Minimized
    Start-Sleep -Seconds 3
    
    # Start Frontend
    Write-Host "▶️  Starting Frontend..." -ForegroundColor Yellow
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$($config.FrontendPath)'; npm start" -WindowStyle Minimized
    
    # Open VS Code
    Write-Host "▶️  Opening VS Code..." -ForegroundColor Yellow
    code $config.FrontendPath
    code $config.BackendPath
    code $config.DocsPath
    
    # Wait and open browser
    Write-Host "⏳ Waiting for services to start..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
    Start-Process "http://localhost:3000"
    
    Write-Host "`n✅ ENVIRONMENT READY!" -ForegroundColor Green
    Write-Host "📱 Frontend: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "🔧 Backend: http://localhost:5000" -ForegroundColor Cyan
    Write-Host "🗄️  MongoDB: mongodb://localhost:27017" -ForegroundColor Cyan
}

function New-ChatMessage {
    Write-Host "`n📋 GENERATING NEW CHAT MESSAGE..." -ForegroundColor Cyan
    
    # Read latest state
    $latestState = if (Test-Path "$($config.QuickStatePath)\latest.md") {
        Get-Content "$($config.QuickStatePath)\latest.md" -Raw
    } else {
        "No previous state found. This is a fresh start."
    }
    
    $chatMessage = @"
I'm continuing work on my FoodXchange B2B platform.

**Project**: FoodXchange - B2B Food Trading Platform
**Developer**: Udi Stryk (foodz)
**Architecture**: React frontend + Node.js/Express backend + MongoDB

## Previous State
$latestState

## Current Goal
[DESCRIBE WHAT YOU WANT TO WORK ON TODAY]

Please help me continue from where I left off.
"@
    
    $chatMessage | Set-Clipboard
    
    Write-Host "✅ Chat message copied to clipboard!" -ForegroundColor Green
    Write-Host "📋 Just paste it in your new chat!" -ForegroundColor Yellow
    
    # Also save to file
    $chatMessage | Out-File -FilePath "$($config.QuickStatePath)\chat-message.md" -Encoding UTF8
    
    # Open in notepad for editing
    Start-Process notepad "$($config.QuickStatePath)\chat-message.md"
}

function Show-QuickHelp {
    Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║              FOODXCHANGE QUICK STATE SYSTEM                   ║
╚═══════════════════════════════════════════════════════════════╝

🎯 QUICK COMMANDS:

  END OF CHAT (Save state):
    .\Quick-State.ps1 save
    
  START NEW CHAT (Generate message):
    .\Quick-State.ps1 new
    
  CONTINUE WORK (Start environment):
    .\Quick-State.ps1 continue
    
  SHOW THIS HELP:
    .\Quick-State.ps1

📌 TIPS:
  - 'save' copies state to clipboard automatically
  - 'new' creates a pre-filled chat message
  - 'continue' starts everything with one command

"@ -ForegroundColor Cyan
}

# Main execution
switch ($Action) {
    'save' {
        Save-QuickState
    }
    'new' {
        New-ChatMessage
    }
    'continue' {
        Start-QuickEnvironment
    }
    'load' {
        if (Test-Path "$($config.QuickStatePath)\latest.md") {
            Get-Content "$($config.QuickStatePath)\latest.md" -Raw | Set-Clipboard
            Write-Host "✅ Latest state copied to clipboard!" -ForegroundColor Green
        } else {
            Write-Host "❌ No saved state found!" -ForegroundColor Red
        }
    }
    default {
        Show-QuickHelp
    }
}
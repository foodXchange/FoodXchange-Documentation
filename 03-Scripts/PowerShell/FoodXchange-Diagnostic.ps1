# FoodXchange Diagnostic Script
# This script will help diagnose why the frontend isn't working

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║           FoodXchange System Diagnostic Tool                  ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Check if we're in the right directory
Write-Host "Checking directories..." -ForegroundColor Yellow
$frontendPath = "C:\Users\foodz\Documents\GitHub\Development\foodxchange-app"
$backendPath = "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend"

Write-Host "`nFrontend path: $frontendPath" -ForegroundColor Cyan
Write-Host "Backend path: $backendPath" -ForegroundColor Cyan

# Check if directories exist
if (Test-Path $frontendPath) {
    Write-Host "✓ Frontend directory exists" -ForegroundColor Green
} else {
    Write-Host "✗ Frontend directory NOT found!" -ForegroundColor Red
    Write-Host "  Please check the path: $frontendPath" -ForegroundColor Yellow
}

if (Test-Path $backendPath) {
    Write-Host "✓ Backend directory exists" -ForegroundColor Green
} else {
    Write-Host "✗ Backend directory NOT found!" -ForegroundColor Red
}

# Check what's in the frontend directory
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "FRONTEND DIRECTORY CONTENTS:" -ForegroundColor Yellow
if (Test-Path $frontendPath) {
    Set-Location $frontendPath -ErrorAction SilentlyContinue
    Write-Host "`nFiles in frontend root:" -ForegroundColor Cyan
    Get-ChildItem -Name | Select-Object -First 20 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
}

# Check if it's a React app or static HTML
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "CHECKING FRONTEND TYPE:" -ForegroundColor Yellow

if (Test-Path "$frontendPath\package.json") {
    Write-Host "✓ package.json found - This is a Node.js project" -ForegroundColor Green
    
    # Check package.json contents
    try {
        $packageContent = Get-Content "$frontendPath\package.json" -Raw | ConvertFrom-Json
        
        # Check if React is installed
        if ($packageContent.dependencies.react -or $packageContent.devDependencies.react) {
            Write-Host "✓ React is installed" -ForegroundColor Green
            if ($packageContent.dependencies.react) {
                Write-Host "  React version: $($packageContent.dependencies.react)" -ForegroundColor Cyan
            }
        } else {
            Write-Host "✗ React is NOT installed in package.json" -ForegroundColor Red
        }
        
        # Check for other important dependencies
        Write-Host "`nOther key dependencies found:" -ForegroundColor Yellow
        if ($packageContent.dependencies.'react-router-dom') {
            Write-Host "  ✓ react-router-dom: $($packageContent.dependencies.'react-router-dom')" -ForegroundColor Gray
        }
        if ($packageContent.dependencies.axios) {
            Write-Host "  ✓ axios: $($packageContent.dependencies.axios)" -ForegroundColor Gray
        }
        
        # Check available scripts
        Write-Host "`nAvailable npm scripts:" -ForegroundColor Yellow
        if ($packageContent.scripts) {
            $packageContent.scripts.PSObject.Properties | ForEach-Object {
                Write-Host "  $($_.Name): $($_.Value)" -ForegroundColor Gray
            }
        }
    } catch {
        Write-Host "✗ Error reading package.json" -ForegroundColor Red
        Write-Host "  Error: $_" -ForegroundColor Red
    }
    
} elseif (Test-Path "$frontendPath\index.html") {
    Write-Host "! Found index.html - This might be a static HTML website" -ForegroundColor Yellow
    Write-Host "  Checking if it's a built React app or plain HTML..." -ForegroundColor Yellow
    
    # Check index.html content
    $indexContent = Get-Content "$frontendPath\index.html" -Raw
    if ($indexContent -match '<div id="root"') {
        Write-Host "  ✓ Found React root element - might be a React app" -ForegroundColor Green
    } else {
        Write-Host "  ! No React root element found - likely static HTML" -ForegroundColor Yellow
    }
} else {
    Write-Host "✗ Neither package.json nor index.html found!" -ForegroundColor Red
}

# Check if node_modules exists
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "CHECKING DEPENDENCIES:" -ForegroundColor Yellow

if (Test-Path "$frontendPath\node_modules") {
    $moduleCount = (Get-ChildItem "$frontendPath\node_modules" -Directory -ErrorAction SilentlyContinue).Count
    Write-Host "✓ node_modules exists with approximately $moduleCount packages" -ForegroundColor Green
} else {
    Write-Host "✗ node_modules NOT found - Dependencies not installed" -ForegroundColor Red
    Write-Host "  Run 'npm install' to install dependencies" -ForegroundColor Yellow
}

# Check for React app structure
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "CHECKING REACT APP STRUCTURE:" -ForegroundColor Yellow

$reactDirs = @("src", "public", "build", "dist")
foreach ($dir in $reactDirs) {
    if (Test-Path "$frontendPath\$dir") {
        Write-Host "✓ $dir directory exists" -ForegroundColor Green
        if ($dir -eq "src") {
            # Check src contents
            $srcFiles = Get-ChildItem "$frontendPath\src" -File -ErrorAction SilentlyContinue | Select-Object -First 10
            if ($srcFiles) {
                Write-Host "  Sample files in src:" -ForegroundColor Gray
                $srcFiles | ForEach-Object { Write-Host "    $($_.Name)" -ForegroundColor Gray }
            }
        }
    } else {
        Write-Host "✗ $dir directory NOT found" -ForegroundColor Yellow
    }
}

# Check for important React files
$importantFiles = @("src/App.js", "src/App.jsx", "src/App.tsx", "src/index.js", "src/index.jsx", "src/index.tsx")
$foundReactFiles = $false
foreach ($file in $importantFiles) {
    if (Test-Path "$frontendPath\$file") {
        Write-Host "✓ Found $file" -ForegroundColor Green
        $foundReactFiles = $true
        break
    }
}
if (-not $foundReactFiles) {
    Write-Host "✗ No main React application files found (App.js, index.js, etc.)" -ForegroundColor Red
}

# Check Node.js and npm versions
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "CHECKING DEVELOPMENT TOOLS:" -ForegroundColor Yellow

try {
    $nodeVersion = node --version 2>$null
    Write-Host "✓ Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Node.js not found or not in PATH" -ForegroundColor Red
}

try {
    $npmVersion = npm --version 2>$null
    Write-Host "✓ npm version: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ npm not found or not in PATH" -ForegroundColor Red
}

# Check ports
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "CHECKING PORTS:" -ForegroundColor Yellow

# Check port 3000 (React default)
$port3000 = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue
if ($port3000) {
    Write-Host "✓ Port 3000 is in use" -ForegroundColor Green
    $process = Get-Process -Id $port3000[0].OwningProcess -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "  Process: $($process.ProcessName)" -ForegroundColor Gray
    }
} else {
    Write-Host "✗ Port 3000 is NOT in use (React not running)" -ForegroundColor Yellow
}

# Check port 5000 (Backend API)
$port5000 = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue
if ($port5000) {
    Write-Host "✓ Port 5000 is in use (Backend API possibly running)" -ForegroundColor Green
} else {
    Write-Host "✗ Port 5000 is NOT in use (Backend not running)" -ForegroundColor Yellow
}

# Check port 27017 (MongoDB)
$port27017 = Get-NetTCPConnection -LocalPort 27017 -ErrorAction SilentlyContinue
if ($port27017) {
    Write-Host "✓ Port 27017 is in use (MongoDB running)" -ForegroundColor Green
} else {
    Write-Host "✗ Port 27017 is NOT in use (MongoDB not running)" -ForegroundColor Yellow
}

# Check for .env files
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "CHECKING CONFIGURATION FILES:" -ForegroundColor Yellow

if (Test-Path "$frontendPath\.env") {
    Write-Host "✓ .env file found in frontend" -ForegroundColor Green
} else {
    Write-Host "! .env file NOT found in frontend" -ForegroundColor Yellow
}

if (Test-Path "$frontendPath\.env.example") {
    Write-Host "✓ .env.example file found in frontend" -ForegroundColor Green
}

# Provide diagnosis
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "DIAGNOSIS & RECOMMENDATIONS:" -ForegroundColor Yellow

$needsReactSetup = $false
$needsNpmInstall = $false

if (-not (Test-Path "$frontendPath\package.json")) {
    Write-Host "`n❌ CRITICAL: No package.json found" -ForegroundColor Red
    Write-Host "   Your frontend needs to be initialized as a React application" -ForegroundColor Yellow
    $needsReactSetup = $true
} elseif (-not (Test-Path "$frontendPath\node_modules")) {
    Write-Host "`n❌ PROBLEM: Dependencies not installed" -ForegroundColor Red
    Write-Host "   Run: npm install" -ForegroundColor Yellow
    $needsNpmInstall = $true
}

if (-not $port3000) {
    Write-Host "`n❌ Frontend not running on port 3000" -ForegroundColor Red
    if ($needsReactSetup) {
        Write-Host "   First initialize React app (see below)" -ForegroundColor Yellow
    } elseif ($needsNpmInstall) {
        Write-Host "   First install dependencies: npm install" -ForegroundColor Yellow
        Write-Host "   Then run: npm start" -ForegroundColor Yellow
    } else {
        Write-Host "   Run: npm start (in frontend directory)" -ForegroundColor Yellow
    }
}

if ($port5000) {
    Write-Host "`n✅ Backend appears to be running correctly" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  Backend not running on port 5000" -ForegroundColor Yellow
    Write-Host "   Navigate to backend directory and run: npm start" -ForegroundColor Yellow
}

# Quick fix recommendations
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "QUICK FIX RECOMMENDATIONS:" -ForegroundColor Yellow

if ($needsReactSetup) {
    Write-Host @"

Your frontend needs to be set up as a React application.

OPTION 1 - Initialize new React app (RECOMMENDED):
1. Open PowerShell as Administrator
2. cd "$frontendPath"
3. npx create-react-app . --template typescript
4. npm install axios react-router-dom zustand @tanstack/react-query
5. npm start

OPTION 2 - If you have existing React code:
1. cd "$frontendPath"
2. npm install
3. npm start

"@ -ForegroundColor Cyan
} elseif ($needsNpmInstall) {
    Write-Host @"

Your React app exists but dependencies are not installed.

To fix:
1. cd "$frontendPath"
2. npm install
3. npm start

"@ -ForegroundColor Cyan
} else {
    Write-Host @"

To start your application:
1. Make sure MongoDB is running
2. Backend: cd "$backendPath" && npm start
3. Frontend: cd "$frontendPath" && npm start

"@ -ForegroundColor Cyan
}

# Check for common issues
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "CHECKING FOR COMMON ISSUES:" -ForegroundColor Yellow

# Check if running in correct directory
if ($PWD.Path -ne $frontendPath -and $PWD.Path -ne $backendPath) {
    Write-Host "⚠️  You're not in the project directory" -ForegroundColor Yellow
    Write-Host "   Current directory: $($PWD.Path)" -ForegroundColor Gray
}

# Check for package-lock.json
if ((Test-Path "$frontendPath\package-lock.json") -or (Test-Path "$frontendPath\yarn.lock")) {
    Write-Host "✓ Lock file found (good for consistent dependencies)" -ForegroundColor Green
}

# Final summary
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
Write-Host "DIAGNOSTIC COMPLETE" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
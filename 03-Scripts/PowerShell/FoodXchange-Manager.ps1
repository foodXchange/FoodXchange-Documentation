# FoodXchange Complete Startup & Checking Script
# This script checks and starts all FoodXchange services

param(
    [switch]$CheckOnly,
    [switch]$StartAll,
    [switch]$StopAll
)

# Set paths
$frontendPath = "C:\Users\foodz\Documents\GitHub\Development\foodxchange-app"
$backendPath = "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend"

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║          FoodXchange Services Manager                         ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Function to check if a port is in use
function Test-Port {
    param($Port)
    $connection = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    if ($connection) {
        $process = Get-Process -Id $connection[0].OwningProcess -ErrorAction SilentlyContinue
        return @{
            InUse = $true
            Process = $process.ProcessName
            PID = $connection[0].OwningProcess
        }
    }
    return @{ InUse = $false }
}

# Function to check service status
function Get-ServiceStatus {
    Write-Host "`n🔍 CHECKING SERVICE STATUS..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    # Check MongoDB
    $mongoStatus = Test-Port -Port 27017
    if ($mongoStatus.InUse) {
        Write-Host "✅ MongoDB" -NoNewline -ForegroundColor Green
        Write-Host " - Running on port 27017 (Process: $($mongoStatus.Process))" -ForegroundColor Gray
    } else {
        Write-Host "❌ MongoDB" -NoNewline -ForegroundColor Red
        Write-Host " - Not running" -ForegroundColor Gray
    }
    
    # Check Backend
    $backendStatus = Test-Port -Port 5000
    if ($backendStatus.InUse) {
        Write-Host "✅ Backend API" -NoNewline -ForegroundColor Green
        Write-Host " - Running on port 5000 (Process: $($backendStatus.Process))" -ForegroundColor Gray
    } else {
        Write-Host "❌ Backend API" -NoNewline -ForegroundColor Red
        Write-Host " - Not running" -ForegroundColor Gray
    }
    
    # Check Frontend
    $frontendStatus = Test-Port -Port 3000
    if ($frontendStatus.InUse) {
        Write-Host "✅ Frontend" -NoNewline -ForegroundColor Green
        Write-Host " - Running on port 3000 (Process: $($frontendStatus.Process))" -ForegroundColor Gray
    } else {
        Write-Host "❌ Frontend" -NoNewline -ForegroundColor Red
        Write-Host " - Not running" -ForegroundColor Gray
    }
    
    return @{
        MongoDB = $mongoStatus
        Backend = $backendStatus
        Frontend = $frontendStatus
    }
}

# Function to check API health
function Test-APIHealth {
    Write-Host "`n🏥 CHECKING API HEALTH..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:5000/health" -Method Get -TimeoutSec 5
        Write-Host "✅ Backend API Health Check" -ForegroundColor Green
        Write-Host "   Status: $($response.status)" -ForegroundColor Gray
        Write-Host "   Environment: $($response.environment)" -ForegroundColor Gray
        return $true
    } catch {
        Write-Host "❌ Backend API Health Check Failed" -ForegroundColor Red
        Write-Host "   Error: $_" -ForegroundColor Gray
        return $false
    }
}

# Function to check frontend
function Test-Frontend {
    Write-Host "`n🎨 CHECKING FRONTEND..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -Method Get -TimeoutSec 5 -UseBasicParsing
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ Frontend is accessible" -ForegroundColor Green
            return $true
        }
    } catch {
        Write-Host "❌ Frontend not accessible" -ForegroundColor Red
        Write-Host "   Error: $_" -ForegroundColor Gray
        return $false
    }
    return $false
}

# Function to check environment files
function Test-EnvironmentFiles {
    Write-Host "`n🔧 CHECKING CONFIGURATION FILES..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    # Check backend .env
    if (Test-Path "$backendPath\.env") {
        Write-Host "✅ Backend .env file exists" -ForegroundColor Green
        
        # Check for MongoDB connection string
        $envContent = Get-Content "$backendPath\.env" -Raw
        if ($envContent -match "MONGODB_URI=") {
            Write-Host "   ✓ MongoDB connection string found" -ForegroundColor Gray
        } else {
            Write-Host "   ⚠️  MongoDB connection string missing" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Backend .env file missing" -ForegroundColor Red
        Write-Host "   Create one from .env.example if it exists" -ForegroundColor Yellow
    }
    
    # Check frontend .env
    if (Test-Path "$frontendPath\.env") {
        Write-Host "✅ Frontend .env file exists" -ForegroundColor Green
        
        # Check for API URL
        $envContent = Get-Content "$frontendPath\.env" -Raw
        if ($envContent -match "REACT_APP_API_URL=") {
            if ($envContent -match "REACT_APP_API_URL=http://localhost:5000") {
                Write-Host "   ✓ API URL correctly set to http://localhost:5000" -ForegroundColor Gray
            } else {
                Write-Host "   ⚠️  API URL not pointing to localhost:5000" -ForegroundColor Yellow
            }
        } else {
            Write-Host "   ⚠️  REACT_APP_API_URL not found" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Frontend .env file missing" -ForegroundColor Red
    }
}

# Function to start MongoDB
function Start-MongoDB {
    Write-Host "`n🗄️  Starting MongoDB..." -ForegroundColor Yellow
    
    # Check if MongoDB is installed
    $mongoPath = "C:\Program Files\MongoDB\Server\*\bin\mongod.exe"
    $mongod = Get-ChildItem -Path $mongoPath -ErrorAction SilentlyContinue | Select-Object -First 1
    
    if ($mongod) {
        # Check if already running
        $mongoStatus = Test-Port -Port 27017
        if ($mongoStatus.InUse) {
            Write-Host "   MongoDB is already running" -ForegroundColor Green
            return $true
        }
        
        # Start MongoDB
        Start-Process -FilePath $mongod.FullName -WindowStyle Hidden
        Start-Sleep -Seconds 3
        
        # Verify it started
        $mongoStatus = Test-Port -Port 27017
        if ($mongoStatus.InUse) {
            Write-Host "   ✅ MongoDB started successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "   ❌ Failed to start MongoDB" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "   ❌ MongoDB not found. Please install MongoDB first." -ForegroundColor Red
        Write-Host "   Download from: https://www.mongodb.com/try/download/community" -ForegroundColor Yellow
        return $false
    }
}

# Function to start backend
function Start-Backend {
    Write-Host "`n🚀 Starting Backend..." -ForegroundColor Yellow
    
    # Check if already running
    $backendStatus = Test-Port -Port 5000
    if ($backendStatus.InUse) {
        Write-Host "   Backend is already running" -ForegroundColor Green
        return $true
    }
    
    # Check if directory exists
    if (-not (Test-Path $backendPath)) {
        Write-Host "   ❌ Backend directory not found: $backendPath" -ForegroundColor Red
        return $false
    }
    
    # Start backend in new window
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell.exe"
    $startInfo.Arguments = "-NoExit -Command `"cd '$backendPath'; Write-Host 'Starting FoodXchange Backend...' -ForegroundColor Cyan; npm start`""
    $startInfo.WorkingDirectory = $backendPath
    
    try {
        [System.Diagnostics.Process]::Start($startInfo) | Out-Null
        Write-Host "   ✅ Backend starting in new window..." -ForegroundColor Green
        Write-Host "   ⏳ Wait 5-10 seconds for it to fully start" -ForegroundColor Yellow
        return $true
    } catch {
        Write-Host "   ❌ Failed to start backend: $_" -ForegroundColor Red
        return $false
    }
}

# Function to start frontend
function Start-Frontend {
    Write-Host "`n🎨 Starting Frontend..." -ForegroundColor Yellow
    
    # Check if already running
    $frontendStatus = Test-Port -Port 3000
    if ($frontendStatus.InUse) {
        Write-Host "   Frontend is already running" -ForegroundColor Green
        return $true
    }
    
    # Check if directory exists
    if (-not (Test-Path $frontendPath)) {
        Write-Host "   ❌ Frontend directory not found: $frontendPath" -ForegroundColor Red
        return $false
    }
    
    # Start frontend in new window
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powershell.exe"
    $startInfo.Arguments = "-NoExit -Command `"cd '$frontendPath'; Write-Host 'Starting FoodXchange Frontend...' -ForegroundColor Cyan; npm start`""
    $startInfo.WorkingDirectory = $frontendPath
    
    try {
        [System.Diagnostics.Process]::Start($startInfo) | Out-Null
        Write-Host "   ✅ Frontend starting in new window..." -ForegroundColor Green
        Write-Host "   ⏳ Browser should open automatically to http://localhost:3000" -ForegroundColor Yellow
        return $true
    } catch {
        Write-Host "   ❌ Failed to start frontend: $_" -ForegroundColor Red
        return $false
    }
}

# Function to stop services
function Stop-Services {
    Write-Host "`n🛑 STOPPING SERVICES..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    # Stop Frontend
    $frontendStatus = Test-Port -Port 3000
    if ($frontendStatus.InUse) {
        try {
            Stop-Process -Id $frontendStatus.PID -Force
            Write-Host "✅ Frontend stopped" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to stop frontend" -ForegroundColor Red
        }
    }
    
    # Stop Backend
    $backendStatus = Test-Port -Port 5000
    if ($backendStatus.InUse) {
        try {
            Stop-Process -Id $backendStatus.PID -Force
            Write-Host "✅ Backend stopped" -ForegroundColor Green
        } catch {
            Write-Host "❌ Failed to stop backend" -ForegroundColor Red
        }
    }
    
    Write-Host "`nNote: MongoDB was not stopped (usually runs as a service)" -ForegroundColor Yellow
}

# Main execution
if ($StopAll) {
    Stop-Services
    exit
}

# Always show current status
$status = Get-ServiceStatus

# Check configuration files
Test-EnvironmentFiles

# If backend is running, check its health
if ($status.Backend.InUse) {
    Test-APIHealth | Out-Null
}

# If frontend is running, check if it's accessible
if ($status.Frontend.InUse) {
    Test-Frontend | Out-Null
}

if ($CheckOnly) {
    Write-Host "`n✅ Status check complete!" -ForegroundColor Green
    exit
}

if ($StartAll) {
    Write-Host "`n🚀 STARTING ALL SERVICES..." -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    # Start MongoDB if needed
    if (-not $status.MongoDB.InUse) {
        Start-MongoDB | Out-Null
    }
    
    # Start Backend if needed
    if (-not $status.Backend.InUse) {
        Start-Backend | Out-Null
    }
    
    # Start Frontend if needed
    if (-not $status.Frontend.InUse) {
        Start-Frontend | Out-Null
    }
    
    Write-Host "`n⏳ Waiting 10 seconds for services to fully start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    
    # Check final status
    Write-Host "`n📊 FINAL STATUS CHECK:" -ForegroundColor Cyan
    $finalStatus = Get-ServiceStatus
    
    # Test API health if backend is running
    if ($finalStatus.Backend.InUse) {
        Start-Sleep -Seconds 5  # Extra wait for backend
        Test-APIHealth | Out-Null
    }
    
    Write-Host "`n✅ Startup process complete!" -ForegroundColor Green
    
    if ($finalStatus.Frontend.InUse -and $finalStatus.Backend.InUse) {
        Write-Host "`n🎉 Your FoodXchange platform is ready!" -ForegroundColor Cyan
        Write-Host "   Frontend: http://localhost:3000" -ForegroundColor Gray
        Write-Host "   Backend API: http://localhost:5000" -ForegroundColor Gray
        Write-Host "   API Health: http://localhost:5000/health" -ForegroundColor Gray
    }
}

# Show menu if no parameters
if (-not $CheckOnly -and -not $StartAll -and -not $StopAll) {
    Write-Host "`n📋 AVAILABLE ACTIONS:" -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    Write-Host "1. Check status only" -ForegroundColor Cyan
    Write-Host "2. Start all services" -ForegroundColor Cyan
    Write-Host "3. Stop all services" -ForegroundColor Cyan
    Write-Host "4. Exit" -ForegroundColor Cyan
    
    $choice = Read-Host "`nSelect an option (1-4)"
    
    switch ($choice) {
        "1" { 
            # Status already shown above
            Write-Host "`n✅ Status check complete!" -ForegroundColor Green
        }
        "2" { 
            & $PSCommandPath -StartAll
        }
        "3" { 
            & $PSCommandPath -StopAll
        }
        "4" { 
            Write-Host "`nExiting..." -ForegroundColor Gray
        }
        default {
            Write-Host "`n❌ Invalid option" -ForegroundColor Red
        }
    }
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
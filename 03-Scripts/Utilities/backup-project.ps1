# FoodXchange Project Backup Script
# This script creates versioned backups of your entire project

param(
    [string]$ProjectRoot = "C:\Users\foodz\Documents\GitHub\Development",
    [string]$BackupRoot = "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs\05-Backups",
    [ValidateSet("Full", "Code", "Docs", "Scripts")]
    [string]$BackupType = "Full",
    [string]$Message = ""
)

Write-Host @"

╔═══════════════════════════════════════════════════════════════╗
║            FoodXchange Project Backup Tool                    ║
╚═══════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Create timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$backupName = "FoodXchange_${BackupType}_${timestamp}"

# Define what to backup based on type
$itemsToBackup = @()

switch ($BackupType) {
    "Full" {
        $itemsToBackup = @(
            @{Path = "$ProjectRoot\foodxchange-app"; Name = "frontend"},
            @{Path = "$ProjectRoot\Foodxchange-backend"; Name = "backend"},
            @{Path = "$ProjectRoot\FoodXchange-Docs"; Name = "docs"}
        )
    }
    "Code" {
        $itemsToBackup = @(
            @{Path = "$ProjectRoot\foodxchange-app"; Name = "frontend"},
            @{Path = "$ProjectRoot\Foodxchange-backend"; Name = "backend"}
        )
    }
    "Docs" {
        $itemsToBackup = @(
            @{Path = "$ProjectRoot\FoodXchange-Docs"; Name = "docs"}
        )
    }
    "Scripts" {
        $itemsToBackup = @(
            @{Path = "$ProjectRoot\FoodXchange-Docs\03-Scripts"; Name = "scripts"}
        )
    }
}

# Create backup directory
$backupPath = Join-Path $BackupRoot $backupName
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

Write-Host "📦 Creating $BackupType backup..." -ForegroundColor Yellow
Write-Host "📍 Backup location: $backupPath" -ForegroundColor Gray

# Create backup info file
$backupInfo = @"
# FoodXchange Backup Information

**Date**: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Type**: $BackupType
**Machine**: $env:COMPUTERNAME
**User**: $env:USERNAME
**Message**: $Message

## Git Status at Backup Time
"@

# Add git status if available
Set-Location $ProjectRoot
try {
    $gitStatus = git status --short
    $gitBranch = git branch --show-current
    $gitCommit = git rev-parse --short HEAD
    
    $backupInfo += @"

**Branch**: $gitBranch
**Commit**: $gitCommit

### Uncommitted Changes:
``````
$gitStatus
``````
"@
} catch {
    $backupInfo += "`n*Git information not available*"
}

$backupInfo | Out-File -FilePath "$backupPath\BACKUP_INFO.md" -Encoding UTF8

# Perform backup
$totalSize = 0
$fileCount = 0

foreach ($item in $itemsToBackup) {
    if (Test-Path $item.Path) {
        Write-Host "`n📁 Backing up $($item.Name)..." -ForegroundColor Yellow
        
        $destination = Join-Path $backupPath $item.Name
        
        # Create exclusion list
        $excludes = @(
            "node_modules",
            "dist",
            "build",
            ".git",
            "*.log",
            ".env"
        )
        
        # Copy with exclusions
        $robocopyArgs = @(
            $item.Path,
            $destination,
            "/E",  # Copy subdirectories including empty
            "/XD", # Exclude directories
            "node_modules", "dist", "build", ".git", ".next", ".cache",
            "/XF", # Exclude files
            "*.log", ".env", "*.tmp", "*.temp",
            "/NFL", # No file list
            "/NDL", # No directory list
            "/NJH", # No job header
            "/NJS", # No job summary
            "/NC",  # No class
            "/NS"   # No size
        )
        
        $result = robocopy @robocopyArgs
        
        # Get backup size
        $size = (Get-ChildItem $destination -Recurse | Measure-Object -Property Length -Sum).Sum
        $totalSize += $size
        
        # Count files
        $files = (Get-ChildItem $destination -Recurse -File).Count
        $fileCount += $files
        
        Write-Host "   ✅ Backed up $files files ($('{0:N2}' -f ($size / 1MB)) MB)" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Path not found: $($item.Path)" -ForegroundColor Yellow
    }
}

# Create backup summary
$summary = @"

## Backup Summary

- **Total Files**: $fileCount
- **Total Size**: $('{0:N2}' -f ($totalSize / 1MB)) MB
- **Duration**: $(((Get-Date) - [datetime]::ParseExact($timestamp, "yyyy-MM-dd_HHmmss", $null)).TotalSeconds) seconds

## Contents Backed Up
"@

foreach ($item in $itemsToBackup) {
    if (Test-Path (Join-Path $backupPath $item.Name)) {
        $summary += "`n- ✅ $($item.Name)"
    }
}

# Append summary to backup info
$summary | Out-File -FilePath "$backupPath\BACKUP_INFO.md" -Encoding UTF8 -Append

# Create a compressed archive (optional)
$compress = Read-Host "`nCreate compressed archive? (Y/N)"
if ($compress -eq 'Y') {
    Write-Host "`n📦 Creating compressed archive..." -ForegroundColor Yellow
    $zipPath = "$BackupRoot\$backupName.zip"
    
    Compress-Archive -Path "$backupPath\*" -DestinationPath $zipPath -CompressionLevel Optimal
    
    $zipSize = (Get-Item $zipPath).Length / 1MB
    Write-Host "✅ Archive created: $backupName.zip ($('{0:N2}' -f $zipSize) MB)" -ForegroundColor Green
}

# Update backup log
$logEntry = @"
| $(Get-Date -Format "yyyy-MM-dd HH:mm") | $BackupType | $fileCount files | $('{0:N2}' -f ($totalSize / 1MB)) MB | $Message |
"@

$logFile = "$BackupRoot\backup-log.md"
if (-not (Test-Path $logFile)) {
    # Create log file with header
    @"
# FoodXchange Backup Log

| Date | Type | Files | Size | Message |
|------|------|-------|------|---------|
"@ | Out-File -FilePath $logFile -Encoding UTF8
}

$logEntry | Out-File -FilePath $logFile -Encoding UTF8 -Append

Write-Host "`n✅ Backup completed successfully!" -ForegroundColor Green
Write-Host @"

📊 BACKUP SUMMARY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Location: $backupPath
📄 Files: $fileCount
💾 Size: $('{0:N2}' -f ($totalSize / 1MB)) MB
📋 Info: $backupPath\BACKUP_INFO.md

"@ -ForegroundColor Cyan

# Cleanup old backups (keep last 10)
Write-Host "🧹 Checking for old backups..." -ForegroundColor Yellow
$backups = Get-ChildItem $BackupRoot -Directory | Where-Object { $_.Name -like "FoodXchange_*" } | Sort-Object CreationTime -Descending

if ($backups.Count -gt 10) {
    $toDelete = $backups | Select-Object -Skip 10
    Write-Host "   Found $($toDelete.Count) old backups to remove" -ForegroundColor Yellow
    
    foreach ($old in $toDelete) {
        Remove-Item $old.FullName -Recurse -Force
        Write-Host "   ✅ Removed: $($old.Name)" -ForegroundColor Gray
    }
}

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
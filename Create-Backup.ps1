# FoodXchange Backup Script
param(
    [string]$BackupLocation = "C:\Backups\FoodXchange"
)

$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$backupPath = "$BackupLocation\FoodXchange_$timestamp"

Write-Host "Creating backup at: $backupPath" -ForegroundColor Cyan

# Create backup directory
New-Item -ItemType Directory -Force -Path $backupPath

# Define what to backup
$itemsToBackup = @(
    "C:\Users\foodz\Documents\GitHub\Development\foodxchange-app",
    "C:\Users\foodz\Documents\GitHub\Development\Foodxchange-backend",
    "C:\Users\foodz\Documents\GitHub\Development\FoodXchange-Docs"
)

foreach ($item in $itemsToBackup) {
    if (Test-Path $item) {
        $itemName = Split-Path $item -Leaf
        Write-Host "Backing up $itemName..." -ForegroundColor Gray
        
        # Use Robocopy for efficient copying
        robocopy $item "$backupPath\$itemName" /E /XD node_modules .git /XF .env *.log
    }
}

# Create backup info file
@"
FoodXchange Backup
Created: $(Get-Date)
Location: $backupPath

Included:
- Frontend application
- Backend application  
- Documentation

Excluded:
- node_modules
- .git folders
- .env files
- log files
"@ | Out-File "$backupPath\BACKUP_INFO.txt"

Write-Host "`n✅ Backup completed!" -ForegroundColor Green
Write-Host "Location: $backupPath" -ForegroundColor Cyan

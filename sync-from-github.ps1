# Quick sync script for FoodXchange-Documentation
Write-Host "Syncing with GitHub..." -ForegroundColor Cyan
git pull origin main
Write-Host "✓ Sync complete!" -ForegroundColor Green
git status

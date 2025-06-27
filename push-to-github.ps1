# Quick push script for FoodXchange-Documentation
param(
    [string]$Message = "Update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git add .
git commit -m "$Message"
git push origin main
Write-Host "✓ Push complete!" -ForegroundColor Green

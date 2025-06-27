# FoodXchange Scripts Directory

## 📁 Structure

\\\
03-Scripts/
├── PowerShell/       # Main PowerShell scripts
├── Deployment/       # Deployment automation
├── Utilities/        # Helper utilities
└── Testing/          # Test automation scripts
\\\

## 🔧 PowerShell Scripts

### Core Scripts
- **FoodXchange-Diagnostic.ps1** - System diagnostic tool
- **FoodXchange-Manager.ps1** - Service management (start/stop/check)

### Deployment Scripts
- **deploy-azure-infrastructure.ps1** - Azure resource deployment
- **deploy-to-production.ps1** - Production deployment automation

### Utility Scripts
- **backup-project.ps1** - Automated backup creation
- **create-all-docs.ps1** - Documentation file generator (this script)

## 📝 Usage Examples

### Run Diagnostic
\\\powershell
.\PowerShell\FoodXchange-Diagnostic.ps1
\\\

### Start All Services
\\\powershell
.\PowerShell\FoodXchange-Manager.ps1 -StartAll
\\\

### Create Backup
\\\powershell
.\Utilities\backup-project.ps1 -BackupType Full -Message "Before major update"
\\\

## 🔒 Script Permissions

Some scripts require administrator privileges. Run PowerShell as Administrator for:
- Service management
- Port checking
- System modifications

## 📚 Script Documentation

Each script includes:
- Purpose description
- Parameter explanations
- Usage examples
- Error handling

Run any script with \-Help\ parameter for details:
\\\powershell
.\script-name.ps1 -Help
\\\

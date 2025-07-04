# Backup Script Documentation

## Overview
The \ackup-project.ps1\ script creates versioned backups of your FoodXchange project.

## Usage

### Basic Usage
\\\powershell
.\backup-project.ps1
\\\

### Parameters
- \-BackupType\: Choose what to backup
  - \Full\: Everything (frontend, backend, docs)
  - \Code\: Just frontend and backend
  - \Docs\: Just documentation
  - \Scripts\: Just scripts folder
- \-Message\: Add a description to the backup

### Examples
\\\powershell
# Full backup with message
.\backup-project.ps1 -BackupType Full -Message "Before Azure deployment"

# Code only backup
.\backup-project.ps1 -BackupType Code

# Documentation backup
.\backup-project.ps1 -BackupType Docs -Message "After architecture update"
\\\

## Backup Location
All backups are stored in: \ 5-Backups\

## Automatic Cleanup
The script automatically keeps only the last 10 backups to save space.

## Restore Process
To restore a backup:
1. Navigate to \ 5-Backups\
2. Find the backup folder you want
3. Copy contents to desired location

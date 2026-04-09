#!/bin/bash

# Configuration
BACKUP_DIR="/mnt/gaza/backups"
DATE=$(date +"%Y-%m-%d_%H-%M")
FILENAME="server_lean_backup_$DATE.tar.gz"

# 1. Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

echo "--- Starting Backup Process: $DATE ---"

# 2. Run the Tar command (including Komodo/Manage while live, others while stopped)
echo "Creating lean tarball..."
tar -cpzf "$BACKUP_DIR/$FILENAME" \
  --warning=no-file-changed \
  --exclude='*/cache' \
  --exclude='*/Cache' \
  --exclude='*/.cache' \
  --exclude='*/logs' \
  --exclude='*/Logs' \
  --exclude='*/metadata' \
  --exclude='*/Metadata' \
  --exclude='*/MediaCover' \
  --exclude='*/backups' \
  --exclude='*/Backups' \
  --exclude='*/transcodes' \
  --exclude='*/Thumbnails' \
  --exclude='*/Data/data' \
  --exclude='*/Drivers' \
  --exclude='*/Codecs' \
  --exclude='*/Crash Reports' \
  --exclude='*/common/Temp' \
  --exclude='*/browser_download_archive' \
  --exclude='*/Sentry' \
  --exclude='*/BT_backup' \
  --exclude='*/JobReports' \
  --exclude='*/Application Support/Plex Media Server' \
  --exclude='*/www/SupportedApps' \
  --exclude='*.log' \
  --exclude='*/qui/config/tracker-icons' \
  --exclude='*/Tdarr/Plugins/FlowPlugins' \
  --exclude='*/Tdarr/Plugins/methods' \
  --exclude='*/Tdarr/Plugins/Community' \
  --exclude='*/prowlarr/config/Definitions' \
  --exclude='*/bazarr/config/backup' \
  --exclude='*/bazarr/config/log' \
  /opt/stacks

# 1. Fix permissions so the media user owns the backup
chown 1000:1000 "$BACKUP_DIR/$FILENAME"

# 4. Keep the 5 most recent backups, delete the rest
ls -t /mnt/gaza/backups/server_lean_backup_*.tar.gz | tail -n +6 | xargs -d '\n' rm -f --

# Notify your phone when the backup is done
curl -d "Lenovo Thinkpad Backup Complete: $FILENAME" http://localhost:8082/admin

echo "--- Backup Complete: $FILENAME ---"

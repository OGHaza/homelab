#!/bin/bash

# 1. Safety Check: Ensure backup drive is mounted
if ! mountpoint -q /mnt/gaza; then
    curl -H "Priority: urgent" -d "Backup Aborted: /mnt/gaza not mounted." http://localhost:8082/admin
    echo "Backup drive not mounted"; exit 1
fi

THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="/mnt/gaza/backups"
DATE=$(date +"%Y-%m-%d_%H-%M")
DAY_OF_WEEK=$(date +"%u")  # 1 (Mon) to 7 (Sun)
DAY_OF_MONTH=$(date +"%d") # 01 to 31

# Move to the root of the stacks
cd "$THIS_DIR/.." || exit

# 2. Determine Backup Type for Rotation
# Default is daily. Sunday (7) is weekly. 1st of month is monthly.
TYPE="daily"
if [ "$DAY_OF_MONTH" == "01" ]; then
    TYPE="monthly"
elif [ "$DAY_OF_WEEK" == "7" ]; then
    TYPE="weekly"
fi

FILENAME="server_lean_${TYPE}_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "--- Starting $TYPE Backup Process: $DATE ---"

docker exec komodo-db mongodump --out /data/db/latest_dump

# 3. Create Tarball
# Using --ignore-case as requested, though patterns in excludes.txt are still the primary filter
tar -cpzf "$BACKUP_DIR/$FILENAME" --ignore-case --exclude-from "$THIS_DIR/excludes.txt" .

rm -r /opt/stacks/ctrl/komodo/mongodb_data/latest_dump

# 4. Post-Backup Logic
if [ $? -eq 0 ]; then
    chown 1000:1000 "$BACKUP_DIR/$FILENAME"
    SIZE=$(du -h "$BACKUP_DIR/$FILENAME" | awk '{print $1}')

    # Success Notification
    curl -d "Backup ($TYPE) Complete: $FILENAME ($SIZE)" http://ntfy.home:8082/admin

    # 5. Smart Retention Cleanup
    # Keep past 3 Dailies
    ls -t "$BACKUP_DIR"/server_lean_daily_*.tar.gz 2>/dev/null | tail -n +4 | xargs -r rm -f --
    # Keep past 1 Weekly
    ls -t "$BACKUP_DIR"/server_lean_weekly_*.tar.gz 2>/dev/null | tail -n +2 | xargs -r rm -f --
    # Keep past 1 Monthly (for the 4-week requirement)
    ls -t "$BACKUP_DIR"/server_lean_monthly_*.tar.gz 2>/dev/null | tail -n +2 | xargs -r rm -f --

else
    # Failure Notification
    curl -H "Priority: high" -H "Tags: warning,skull" -d "BACKUP FAILED: $FILENAME" http://ntfy.home:8082/admin
    exit 1
fi

echo "--- Backup Complete: $FILENAME ---"

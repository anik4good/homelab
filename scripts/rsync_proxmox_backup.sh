#!/bin/bash

# === Configuration ===
SRC="/var/lib/vz/dump/"
DEST="/mnt/pve/nas1tb/backup/proxmox/dump"
LOG="/var/log/proxmox_backup_sync.log"
UPTIME_KUMA_URL="https://uptimekuma.local.root2tech.com/api/push/KgB6GmqCn9?status=up&msg=OK&ping="

# === Run rsync ===
{
    echo "=== Rsync Started: $(date) ==="
    rsync -avh --ignore-existing --progress "$SRC" "$DEST"
    status=$?
    echo "=== Rsync Finished: $(date) ==="

    # === Notify Uptime Kuma ===
    if [ "$status" -eq 0 ]; then
        curl -s "$UPTIME_KUMA_URL"
        echo "Uptime Kuma notified successfully."
    else
        echo "❌ Rsync failed with status code $status."
    fi
    echo "==============================="
} >> "$LOG" 2>&1


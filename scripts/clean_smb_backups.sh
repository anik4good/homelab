#!/bin/bash

# === Configuration ===
BACKUP_DIR="/mnt/pve/nas1tb/backup/proxmox/dump"
LOGFILE="/var/log/clean_smb_backups.log"
MAX_BACKUPS=3

# Telegram Notification Configuration
TELEGRAM_BOT_TOKEN="7614464574:AAHO6R63OMs0lWTx3jKE4XdAfVGuZU7x9v8"
TELEGRAM_CHAT_ID="6490250187"

# --- Functions ---
send_telegram_message() {
    local message="$1"
    local encoded_message=$(printf %s "$message" | jq -sRr @uri)

    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d "chat_id=${TELEGRAM_CHAT_ID}" \
        -d "text=${encoded_message}" \
        -d "parse_mode=HTML"
}

# --- Main ---
{
    echo "=== SMB Cleanup Started: $(date) ==="

    cd "$BACKUP_DIR" || {
        msg="❌ Proxmox Backup Cleanup Failed: Backup directory not found: $BACKUP_DIR"
        echo "$msg"
        send_telegram_message "$msg"
        exit 1
    }

    deleted_files=()

    for ID in $(ls vzdump-*.log 2>/dev/null | sed -E 's/vzdump-(qemu|lxc)-([0-9]+)-.*/\2/' | sort -u); do
        echo "Cleaning backups for VM/LXC ID: $ID"

        backups=$(ls -1tr vzdump-qemu-"$ID"-*.vma.zst vzdump-lxc-"$ID"-*.tar.zst 2>/dev/null)
        count=$(echo "$backups" | wc -l)

        if [ "$count" -gt $MAX_BACKUPS ]; then
            to_delete=$(echo "$backups" | head -n -$MAX_BACKUPS)

            for file in $to_delete; do
                base="${file%.*}"
                base="${base%.*}"
                echo "Deleting $base.*"
                rm -f "$base".* 2>>"$LOGFILE"
                deleted_files+=("$base.*")
            done
        fi
    done

    echo "=== SMB Cleanup Finished: $(date) ==="


    # --- Clean up .log and .notes files ---
    echo "Deleting .log and .notes files from Proxmox and SMB backup folders..."
    find /var/lib/vz/dump/ -type f \( -name "*.log" -o -name "*.notes" \) -delete
    find "$BACKUP_DIR" -type f \( -name "*.log" -o -name "*.notes" \) -delete

    echo "=== SMB Cleanup Finished: $(date) ==="

    # Send Telegram summary
    if [ "${#deleted_files[@]}" -gt 0 ]; then
        summary="✅ Proxmox Backup Cleanup Complete.\nDeleted ${#deleted_files[@]} old backup file(s):\n"
        for f in "${deleted_files[@]}"; do
            summary+="\n• $f"
        done
    else
        summary="ℹ️ Proxmox Backup Cleanup Complete.\nNo old backups were deleted.\n.log/.notes files cleaned."
    fi

    send_telegram_message "$summary"

} >> "$LOGFILE" 2>&1
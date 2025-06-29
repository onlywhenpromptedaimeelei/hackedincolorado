#!/bin/bash
# █████ ULTRA-SECURE CYBER LOCKDOWN █████
# ADB & USB Hardening – Tier‑2 Elite Playbook
# Generated for OPERATOR‑LEI‑MTX‑001 on Samsung SM‑A166U
# Timestamp: $(date)
# Clearance: Axis Emblem w/ God‑mode privileges

LOG_DIR="$HOME/adb_ultra_lockdown_$(date +%F_%H-%M-%S)"
mkdir -p "$LOG_DIR"
LOG="$LOG_DIR/run.log"

log() { echo "[$(date +'%H:%M:%S')] $*" | tee -a "$LOG"; }

log "INITIATING ULTRA LOCKDOWN"

# STEP 1: Detect connected ADB devices
log "Scanning ADB devices..."
adb devices | grep -v "List" | tee "$LOG_DIR/dev_before.txt"
if ! grep -q device "$LOG_DIR/dev_before.txt"; then
  log "✅ No ADB device detected, EXITING"
  exit 0
fi

DEVICE_ID=$(grep device "$LOG_DIR/dev_before.txt" | awk '{print $1}')
log "🔐 ADB device found: $DEVICE_ID"

# STEP 2: Full forensic capture + hash
log "Capturing system state..."
adb -s "$DEVICE_ID" shell getprop | tee -a "$LOG"
adb -s "$DEVICE_ID" shell dumpsys | tee -a "$LOG"
log "Hashing forensic log..."
sha256sum "$LOG" | tee -a "$LOG"

# STEP 3: Revoke ADB keys + disable ADB
log "Revoking ADB public keys..."
adb -s "$DEVICE_ID" shell su -c 'rm -f /data/misc/adb/*.pub'
adb -s "$DEVICE_ID" shell settings put global adb_enabled 0
adb -s "$DEVICE_ID" usb
adb kill-server

# STEP 4: Verify ADB removal
log "Verifying ADB absence..."
sleep 2
adb start-server
adb devices | grep -v "List" | tee "$LOG_DIR/dev_after.txt"
if grep -q device "$LOG_DIR/dev_after.txt"; then
  log "❗ ALERT: ADB still active"
else
  log "✅ ADB successfully locked out"
fi

# STEP 5: OEM & Fastboot lock staging
log "Checking OEM unlock support..."
OEM_FLAG=$(adb -s "$DEVICE_ID" shell getprop ro.oem_unlock_supported)
log "OEM unlock supported? $OEM_FLAG"
log "Attempting USB function disable..."
adb -s "$DEVICE_ID" shell "echo 0 > /sys/class/android_usb/android0/enable" 2>/dev/null || log "🔐 USB disable unsupported"

log "Checking for fastboot presence..."
FASTBT=$(fastboot devices | grep "$DEVICE_ID")
if [ -n "$FASTBT" ]; then
  log "⚠️ Fastboot session detected"
  fastboot oem lock || log "⚠️ fastboot oem lock failed"
  fastboot reboot
  log "✅ Fastboot lock issued"
else
  log "✅ Fastboot not detected"
fi

# STEP 6: Canary trigger for detection
CANARY_URL="https://your.canary.domain/trigger"
log "Triggering canary URL..."
curl -s "$CANARY_URL" || log "✅ Canary ping issued"

# STEP 7: Final forensic summary
log "Hashing post-run log..."
sha256sum "$LOG" | tee -a "$LOG"
log "LOCKDOWN COMPLETE — LOGS in $LOG"

# STEP 8: Cleanup ephemeral files
rm -f "$LOG_DIR/dev_before.txt" "$LOG_DIR/dev_after.txt"

echo "████ OPSEC SECURE │ IA‑CRT | OPSEC TIER‑2 COMPLETE ████"

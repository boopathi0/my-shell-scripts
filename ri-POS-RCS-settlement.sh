#!/bin/bash

# Path to the log file
LOGFILE="/home/tomax/logs/isd_java_rcs_settlement.log"
#LOGFILE="/tmp/isd_java_rcs_settlement.log"

# Keywords to search for
KEYWORDS=(
  "Connection timed out"
  "Unable to transfer the trigger file-com.jcraft.jsch.JSchException"
  "No ACK files found in the time allotted."
)

# Check if the log file exists
if [[ ! -f "$LOGFILE" ]]; then
  echo "Error: Log file not found at $LOGFILE"
  exit 1
fi

# Initialize flag to check if any keyword is found
found=0

# Search for each keyword in the log file
for keyword in "${KEYWORDS[@]}"; do
  if grep -qF "$keyword" "$LOGFILE"; then
    found=1
    break
  fi
done

# Output 1 if any keyword is found, otherwise 0
echo "$found"

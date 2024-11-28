#!/bin/bash

# Get the ActiveEnterTimestamp
start_time=$(systemctl show -p ActiveEnterTimestamp ri-jboss1.service | cut -d'=' -f2)

# Convert start time to epoch
start_epoch=$(date -d "$start_time" +%s)

# Get the current time in epoch
current_epoch=$(date +%s)

# Calculate the difference in seconds
diff_seconds=$((current_epoch - start_epoch))

# Convert seconds to hours
diff_hours=$((diff_seconds / 3600))

echo $diff_hours

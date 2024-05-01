#!/bin/bash

# Set the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Set the name of the log file
LOG_FILE="$DIR/temp_log.txt"

# Function to run ethtool and append its output to the log file
run_ethtool() {
    echo "Running ethtool:" >> "$LOG_FILE"
    ethtool "$1" >> "$LOG_FILE" 2>&1
    echo "---------------------------------------" >> "$LOG_FILE"
}

# Function to enable hugepages by modifying /sys/kernel/mm/transparent_hugepage
# Function to enable hugepages by modifying /sys/kernel/mm/transparent_hugepage
enable_hugepages() {
    echo "Enabling hugepages:" >> "$LOG_FILE"
    
    # Print original values
    echo "Original values:" >> "$LOG_FILE"
    cat /sys/kernel/mm/transparent_hugepage/enabled >> "$LOG_FILE" 2>&1
    cat /sys/kernel/mm/transparent_hugepage/defrag >> "$LOG_FILE" 2>&1
    echo "---------------------------------------" >> "$LOG_FILE"
    
    # Enable hugepages
    sudo bash -c "echo 'always' > /sys/kernel/mm/transparent_hugepage/enabled" >> "$LOG_FILE" 2>&1
    sudo bash -c "echo 'always' > /sys/kernel/mm/transparent_hugepage/defrag" >> "$LOG_FILE" 2>&1
    
    # Print modified values
    echo "Modified values:" >> "$LOG_FILE"
    cat /sys/kernel/mm/transparent_hugepage/enabled >> "$LOG_FILE" 2>&1
    cat /sys/kernel/mm/transparent_hugepage/defrag >> "$LOG_FILE" 2>&1
    echo "---------------------------------------" >> "$LOG_FILE"
}


# Your script commands go here
# For demonstration purposes, let's run ethtool for eth0 and eth1
run_ethtool eth0
run_ethtool eth1

# Enable hugepages
enable_hugepages

# Print a message indicating where the log file is located
echo "Logs are saved to: $LOG_FILE"

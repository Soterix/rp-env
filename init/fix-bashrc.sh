#!/bin/bash

# Define the target file
TARGET_FILE="$HOME/.bashrc"

# Check if the file exists
if [[ -f "$TARGET_FILE" ]]; then
    # Use sed to remove lines like "source /etc/rp_environment" only if they are at the end of the file
    sed -i ':a;N;$!ba;s/\(source \/etc\/rp_environment\)\n*$//g' "$TARGET_FILE"
else
    echo "    File $TARGET_FILE does not exist."
fi
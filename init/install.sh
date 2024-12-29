#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 package1 package2 ..."
    exit 1
fi

# Array to hold missing packages
MISSING_PACKAGES=()

# Check each package
for package in "$@"; do
    if ! command_exists "$package"; then
        echo "$package is not installed."
        MISSING_PACKAGES+=("$package")
    fi
done

# Install missing packages if necessary
if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    echo "    Updating apt and installing missing packages: ${MISSING_PACKAGES[@]}"
    apt update
    apt install -y ${MISSING_PACKAGES[@]}
else
    echo "    Packages $@ are already installed."
fi


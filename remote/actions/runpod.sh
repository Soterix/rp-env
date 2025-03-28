#!/usr/bin/env sh

# Bash script above will pollute .bashrc with calls to /etc/rp_environment after each restart, 
# as result it will not be possible to add something that changes PATH
runpod_fix_bashrc() {

    # Define the target file
    TARGET_FILE="$HOME/.bashrc"

    # Check if the file exists
    if [ -f "$TARGET_FILE" ]; then
        # Use sed to remove lines like "source /etc/rp_environment" only if they are at the end of the file
        sed -i ':a;N;$!ba;s/\(source \/etc\/rp_environment\)\n*$//g' "$TARGET_FILE"
        echo "[runpod_fix_bashrc] Duplicated "/etc/rp_environment" removed from $TARGET_FILE"
    else
        echo "[runpod_fix_bashrc] File ${TARGET_FILE} does not exist."
    fi
}

# Fixing sleep at the end of original Ru Pod’s start script, so we can run our script after it 
runpod_fix_start_script() {
    
    FILE="/start.sh"

    if [ -f "$FILE" ]; then
        sed -i '/sleep infinity/d' ${FILE} && echo "Original ${FILE} fixed"
        echo "[runpod_fix_start_script] Original ${FILE} fixed"
    fi
}
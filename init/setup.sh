#!/bin/bash 

# Function to ensure a specific line is present in bashrc
ensure_line_in_bashrc() {
    local line_to_ensure="$1"
    local bashrc="$HOME/.bashrc"

    # Check if the line is already in .bashrc
    if ! grep -Fxq "$line_to_ensure" "$bashrc"; then
        echo "$line_to_ensure" >> "$bashrc"
    fi
}

# Removing sleep infinity from original start script
sed -i '/sleep infinity/d' /start.sh && echo "Original start.sh fixed"

# Running original start script 
/start.sh

# Bash script above will pollute .bashrc with calls to /etc/rp_environment after each restart, 
# as result it will not be possible to add something that changes PATH
/workspace/init/fix-bashrc.sh && echo ".bashrc fixed"

echo "Performing custom setup..."

/workspace/init/install.sh rsync screen nvtop \
    && echo "1. Ubuntu packages installed"

rm -rf "/root/.vscode-server" \
    && mkdir -p "/workspace/apps/vscode-server" \
    && ln -s "/workspace/apps/vscode-server" "/root/.vscode-server" \
    && echo "2. Vscode-server folder linked"

cp -rf "/workspace/.ssh" "/root" \
    && chmod -R 600 "/root/.ssh" \
    && echo "Include ~/.ssh/ssh_config" > "/root/.ssh/config" \
    && echo "3. Ssh configuration completed"

rm -rf "/root/PhD"\
    && mkdir -p "/workspace/PhD" \
    && ln -s "/workspace/PhD" "/root/PhD" \
    && echo "4. PhD workspace created"

/workspace/init/poetry.sh \
    && /workspace/apps/poetry/bin/poetry config virtualenvs.in-project true \
    && ensure_line_in_bashrc 'export PATH="/workspace/apps/poetry/bin:$PATH"' \
    && echo "5. Poetry installation ensured"

mkdir -p "/workspace/apps/cli-tools" \
    && ensure_line_in_bashrc 'export PATH="/workspace/apps/cli-tools:$PATH"' \
    && echo "6. CLI-tools registred"

echo "Custom setup script(s) finished, pod is ready to use."

sleep infinity


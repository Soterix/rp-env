#!/bin/sh

SSH_DIR="$HOME/.ssh"

ssh_save_keys() {
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    found="false"

    env | grep -E '^RUNPOD_SECRET_SSHKEY_|^RUNPOD_SSHKEY_' | while IFS='=' read -r env_name env_value; do
        found="true"
        key_name=$(echo "$env_name" | sed 's/^RUNPOD_SECRET_SSHKEY_//' | sed 's/^RUNPOD_SSHKEY_//' | tr '[:upper:]' '[:lower:]')
        
        echo "$env_value" | base64 -d > "$SSH_DIR/$key_name"
        chmod 600 "$SSH_DIR/$key_name"
        echo "[ssh_save_keys] $key_name"
    done

    if [ found = "false" ]; then
        echo "[ssh_save_keys] No SSH identities found, please pass secrets to pod"
    fi
}

ssh_config() {
  SSH_DIR="${SSH_DIR:-$HOME/.ssh}"
  host="$1"
  shift

  while [ $# -gt 0 ]; do
    case "$1" in
      --hostname) hostname="$2"; shift 2 ;;
      --port) port="$2"; shift 2 ;;
      --user) user="$2"; shift 2 ;;
      --identity) identity="$2"; shift 2 ;;
      *) shift ;;
    esac
  done

  host=$(echo "$host" | sed 's/^ *//;s/ *$//')
  filename=$(echo "$host" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\{1,\}/_/g; s/^_*\|_*$//g')
  config_file="${SSH_DIR}/configs/${filename}"

  mkdir -p "${SSH_DIR}/configs"

  {
    echo "Host $host"
    [ -n "$hostname" ] && echo "  HostName $hostname"
    [ -n "$port" ] && echo "  Port $port"
    [ -n "$user" ] && echo "  User $user"
    [ -n "$identity" ] && echo "  IdentityFile $identity"
  } > "$config_file"

  include_line="Include ${SSH_DIR}/configs/${filename}"

  if [ ! -f "${SSH_DIR}/config" ] || ! grep -qxF "$include_line" "${SSH_DIR}/config"; then
    tmpfile=$(mktemp)
    {
      echo "$include_line"
      [ -f "${SSH_DIR}/config" ] && cat "${SSH_DIR}/config"
    } > "$tmpfile"
    mv "$tmpfile" "${SSH_DIR}/config"
  fi

  echo "[ssh_config] SSH configuration: ${SSH_DIR}/configs/${filename}"
}
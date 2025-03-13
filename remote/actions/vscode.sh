#!/usr/bin/env sh

[ -n "${__RP_ENV_ALREADY_IMPORTED_VSCODE}" ] && return
__RP_ENV_ALREADY_IMPORTED_VSCODE=1

vscode_map_server_folder() {
    if [ -z "$1" ]; then
        echo "[vscode_map_server_folder] New location should be passed as a single argument"
        exit 1
    fi

    TARGET_DIR="$1"
    SRC_DIR="${HOME}/.vscode-server"

    mkdir -p "$TARGET_DIR"

    if [ -d "$SRC_DIR" ] && [ "$(ls -A "$SRC_DIR")" ]; then
        cp -r "$SRC_DIR/"* "$TARGET_DIR/"
    fi

    rm -rf "$SRC_DIR"
    ln -s "$TARGET_DIR" "$SRC_DIR"

    echo "[vscode_map_server_folder] vscode server folder mapped to ${TARGET_DIR}"
}
#!/usr/bin/env sh

[ -n "${__RP_ENV_ALREADY_IMPORTED_SH}" ] && return
__RP_ENV_ALREADY_IMPORTED_SH=1

sh_ensure_rc() {

    if [ "$#" -ne 1 ]; then
        echo "[sh_ensure_rc] Exactly one argument expected. Did you missed quotation marks?"
        return 1
    fi

    COMMAND="$1"

    CURRENT_SHELL=$(basename "$SHELL")
    case "$CURRENT_SHELL" in
        bash)
            RC_FILE="$HOME/.bashrc"
            ;;
        zsh)
            RC_FILE="$HOME/.zshrc"
            ;;
        sh)
            RC_FILE="$HOME/.shrc"
            ;;
        *)
            echo "[sh_ensure_rc] Unsupported shell: $CURRENT_SHELL"
            return 1
            ;;
    esac

    [ -f "$RC_FILE" ] || touch "$RC_FILE"

    if grep -Fxq "$COMMAND" "$RC_FILE"; then
        echo "[sh_ensure_rc] '$COMMAND' is already in rc file"
        return 0
    fi

    echo "$COMMAND" >> "$RC_FILE"
    echo "[sh_ensure_rc] Added '$COMMAND' to $RC_FILE"
}

sh_rc_source() {

    CURRENT_SHELL=$(basename "$SHELL")
    echo $CURRENT_SHELL
    case "$CURRENT_SHELL" in
        zsh)
            [ -f "$HOME/.zshrc" ] && . "$HOME/.zshrc"
            ;;
        bash)
            [ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"
            ;;
        sh)
            [ -f "$HOME/.shrc" ] && . "$HOME/.shrc"
            ;;
        *)
            echo "[sh_rc_source] Unsupported shell: $CURRENT_SHELL"
            return 1
            ;;
    esac
}

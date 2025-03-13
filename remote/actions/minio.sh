#!/usr/MINIO_BIN/env sh

[ -n "${__RP_ENV_ALREADY_IMPORTED_MINIO}" ] && return
__RP_ENV_ALREADY_IMPORTED_MINIO=1

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/actions/sh.sh"

minio_install() {
    
    MINIO_DIR="${HOME}/.minio-cli"

    while [ $# -gt 0 ]; do
        case "$1" in
            --dir)
                MINIO_DIR="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done

    MINIO_BIN="${MINIO_DIR}/mc"

    if [ -x "${MINIO_BIN}" ]; then
        VERSION=$("${MINIO_BIN}" --version 2>/dev/null | head -n1 | awk '{print $3}')
        if [ -n "${VERSION}" ]; then
            echo "[minio_install] minio-cli ${VERSION} is already installed in ${MINIO_DIR}"
            return
        fi
    fi

    rm -rf "${MINIO_DIR}"
    mkdir -p "${MINIO_DIR}"

    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    case "${ARCH}" in
        X86_64) ARCH="amd64";;
        ARM64|AARCH64) ARCH="arm64";;
        *) ARCH="amd64";;
    esac
    curl -sSL "https://dl.min.io/client/mc/release/${OS}-${ARCH}/mc" -o "${MINIO_BIN}"
    chmod +x "${MINIO_BIN}"

    sh_ensure_rc "export PATH=\"${MINIO_DIR}:\$PATH\""

    echo "[minio_install] Minio installed."
}

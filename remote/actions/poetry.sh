#!/usr/bin/env sh

[ -n "${__RP_ENV_ALREADY_IMPORTED_POETRY}" ] && return
__RP_ENV_ALREADY_IMPORTED_POETRY=1

. "$script_dir/actions/sh.sh"

poetry_install() {
  POETRY_DIR="$HOME/.poetry"
  POETRY_VERSION="latest"

  while [ $# -gt 0 ]; do
    case "$1" in
      --dir)
        shift
        POETRY_DIR="$1"
        ;;
      --version)
        shift
        POETRY_VERSION="$1"
        ;;
      *)
        echo "Unknown argument: $1"
        return 1
        ;;
    esac
    shift
  done

  POETRY_BIN="$POETRY_DIR/bin/poetry"
  ACTUAL_VERSION=""

  if [ -x "$POETRY_BIN" ]; then
    ACTUAL_VERSION=$($POETRY_BIN --version 2>/dev/null | awk -F'[ )]+' '{print $3}')
    echo $ACTUAL_VERSION
    if [ -z "$ACTUAL_VERSION" ]; then
      echo "[poetry_install] Poetry instalation is not found or malformed. New version will be installed."
      rm -rf "$POETRY_DIR"
    else
      if [ "$POETRY_VERSION" = "latest" ] || [ "$POETRY_VERSION" = "$ACTUAL_VERSION" ]; then
        echo "[poetry_install] Poetry $ACTUAL_VERSION is already installed in $POETRY_DIR"
        return 0
      else
        echo "[poetry_install] Poetry version $ACTUAL_VERSION found, will be replaced with version $POETRY_VERSION"
        rm -rf "$POETRY_DIR"
      fi
    fi
  else
    echo "[poetry_install] Poetry instalation is not found or malformed. New version will be installed."
    rm -rf "$POETRY_DIR"
  fi

  if [ "$POETRY_VERSION" = "latest" ]; then
    curl -sSL https://install.python-poetry.org | POETRY_HOME="$POETRY_DIR" python3 -
  else
    curl -sSL https://install.python-poetry.org | POETRY_HOME="$POETRY_DIR" python3 - --version "$POETRY_VERSION"
  fi

  sh_ensure_rc "export PATH=\"$POETRY_DIR/bin:\$PATH\""
}


#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

. "$SCRIPT_DIR/actions/ssh.sh"
. "$SCRIPT_DIR/actions/git.sh"
. "$SCRIPT_DIR/actions/package.sh"
. "$SCRIPT_DIR/actions/poetry.sh"
. "$SCRIPT_DIR/actions/vscode.sh"
. "$SCRIPT_DIR/actions/minio.sh"
. "$SCRIPT_DIR/actions/runpod.sh"

runpod_fix_start_script

# /start.sh

runpod_fix_bashrc

ssh_save_keys

ssh_config github.com --user git --identity ${HOME}/.ssh/gh_rp_env

git_init "Serhii Kozlov" "serhii.kozlov@gmail.com"

package_update

package_install rsync screen nvtop vim nload

poetry_install --version 1.8.5

# vscode_map_server_folder /workspace/rp-env/apps/vscode

minio_install

sh_rc_source

mc alias set gcs https://storage.googleapis.com ${RUNPOD_SECRET_GCS_ACCESS_KEY} ${RUNPOD_SECRET_GCS_SECRET_KEY}
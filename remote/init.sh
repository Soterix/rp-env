#!/bin/sh

script_dir="$(cd "$(dirname "$0")" && pwd)"

. "$script_dir/actions/ssh.sh"
. "$script_dir/actions/git.sh"
. "$script_dir/actions/package.sh"
. "$script_dir/actions/poetry.sh"
. "$script_dir/actions/vscode.sh"

ssh_save_keys

ssh_config github.com --user git --identity ${HOME}/.ssh/gh_rp_env

git_init "Serhii Kozlov" "serhii.kozlov@gmail.com"

package_update

package_install rsync screen nvtop vim

poetry_install --version 1.8.5

vscode_map_server_folder /workspace/rp-env/apps/vscode

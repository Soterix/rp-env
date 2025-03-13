#!/bin/sh

script_dir="$(cd "$(dirname "$0")" && pwd)"

. "$script_dir/actions/ssh.sh"
. "$script_dir/actions/git.sh"


ssh_save_keys

ssh_config github.com --hostname github.com --port 28001 --user git --identity ${HOME}/.ssh/gh_rp_env

git_init "Serhii Kozlov" "serhii.kozlov@gmail.com"
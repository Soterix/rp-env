#!/bin/sh

script_dir="$(cd "$(dirname "$0")" && pwd)"

. "$script_dir/actions/ssh.sh"
. "$script_dir/actions/git.sh"
. "$script_dir/actions/package.sh"

ssh_save_keys

ssh_config github.com --user git --identity ${HOME}/.ssh/gh_rp_env

git_init "Serhii Kozlov" "serhii.kozlov@gmail.com"

pacakge_update

package_install rsync screen nvtop
#!/usr/bin/env sh

. ${RP_ENV_ACTIONS}/actions.sh

runpod_fix_start_script

/start.sh

runpod_fix_bashrc

ssh_save_keys

ssh_config github.com --user git --identity ${HOME}/.ssh/gh_rp_env

git_init "Serhii Kozlov" "serhii.kozlov@gmail.com"

ssh_host github.com

git_clone_env /workspace/PhD

minio_alias_env

sleep infinity 
#!/usr/bin/env sh

[ -n "${__RP_ENV_ALREADY_IMPORTED_GIT}" ] && return
__RP_ENV_ALREADY_IMPORTED_GIT=1

git_init() {
    if [ "$#" -ne 2 ]; then
        echo "[git_init]: Something is missed, please provide two arguments - username and email"
        return 1
    fi

    username=$1
    email=$2

    git init
    git config user.name "$username"
    git config user.email "$email"

    echo "[git_init] Git configured for ${username} (${email})"
}

git_clone() {
    if [ "$#" -lt 2 ]; then
        echo "[git_clone]: Usage: git_clone <gitrepo> <workdir> [ssh_id]"
        return 1
    fi

    local gitrepo="$1"
    local workdir="$2"

    local id="$3"

    local reponame=$(basename "${gitrepo%.git}")

    if [ -d "${workdir}/${reponame}/.git" ]; then
        echo "[git_clone]: Repository ${gitrepo} already cloned into ${workdir}/${reponame}"
        return 0
    fi

    if [ ! -d "$workdir" ]; then
        mkdir -p "$workdir" || return 1
    fi

    cd "$workdir" || return 1

    if [ -n "$id" ]; then
        if [ ! -f "${HOME}/.ssh/$id" ]; then
            echo "[git_clone]: SSH identity file '$id' does not exist."
            return 1
        fi

        # Use the specified SSH identity to clone the repo
        GIT_SSH_COMMAND="ssh -i ${HOME}/.ssh/$id -o StrictHostKeyChecking=accept-new -o IdentitiesOnly=yes" git clone "$gitrepo" "$reponame"
    else
        # Clone the repository using the default SSH configuration
        git clone "$gitrepo" "$reponame"
    fi

   echo "[git_clone]: Repository ${gitrepo} successfully cloned into ${workdir}/${reponame}"
}

git_clone_env() {
    if [ -z "$1" ]; then
        echo "Usage: git_clone_env <workdir> [id]"
        return 1
    fi

    local workdir="$1"
    local id="$2"

    env | grep '^RUNPOD_GIT_' | while IFS='=' read -r envname gitrepo; do
        if [ -n "$gitrepo" ]; then
            echo "[git_clone_env]: Cloning $gitrepo from $envname"
            git_clone "$gitrepo" "$workdir" "$id"
        fi
    done
}
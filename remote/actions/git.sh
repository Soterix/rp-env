#!/bin/sh

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
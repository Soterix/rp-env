#!/bin/sh

pacakge_update() {
    apt-get update
}

package_install() {
    [ "$#" -eq 0 ] && { echo "[package_install] List of packages should be provided"; exit 1; }

    installed_packages=""
    missing_packages=""

    for pkg in "$@"; do
        if dpkg -s "$pkg" >/dev/null 2>&1; then
            installed_packages="${installed_packages:+$installed_packages, }$pkg"
        else
            missing_packages="$missing_packages $pkg"
        fi
    done

    [ -n "$installed_packages" ] && echo "[package_install] Already installed: $installed_packages"


    if [ -z "$missing_packages" ]; then
        echo "[package_install] Nothing to install"
        return
    fi

    apt-get install -y $missing_packages
}
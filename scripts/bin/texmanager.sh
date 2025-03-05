#!/bin/bash

if ! command -v tex >>/dev/null; then
    echo "A TeX distribution is not installed."
    exit 1 >>/dev/null
fi

texlive_installation=$(dirname "$(command -v tex)")
tlmgr_command=$(cygpath "$texlive_installation/tlmgr.bat")

function tlmgr-search() {
    local package_name="$1"
    echo "Searching for packages matching '$package_name'..."

    if ! eval "$tlmgr_command search --global $package_name"; then
        echo "tlmgr error: failed to search for packages."
        return 1
    fi

    return 0
}

function tlmgr-install() {
    local package_name="$1"
    echo "Installing package '$package_name'..."

    if ! eval "$tlmgr_command install $package_name"; then
        echo "tlmgr error: failed to install package."
        return 1
    fi

    return 0
}

if [[ $# -eq 0 ]] || [[ -z "$1" ]]; then
    echo "Usage: texmanager <search | install> [package_name]"
    exit 1 >>/dev/null
fi

case "$1" in
search)
    if [[ -z "$2" ]]; then
        echo "Usage: texmanager search <package_name>"
        exit 1 >>/dev/null
    fi

    tlmgr-search "$2"
    ;;
install)
    if [[ -z "$2" ]]; then
        echo "Usage: texmanager install <package_name>"
        exit 1 >>/dev/null
    fi

    shift 1

    tlmgr-install "$*"
    ;;
*)
    echo "Usage: texmanager <search | install> [package_name]"
    exit 1 >>/dev/null
    ;;
esac

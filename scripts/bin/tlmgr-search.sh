#!/bin/bash

alias tlmgr="tlmgr.bat"

function tlmgr-search() {
    if [[ $# -eq 0 ]] || [[ -z "$1" ]]; then
        echo "Usage: tlmgr-search <package>"
        return 1
    fi

    local package="$1"

    tlmgr search --global --file --list "$package"
}

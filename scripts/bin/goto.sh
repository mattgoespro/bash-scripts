#!/bin/bash

function goto() {
    dirmap=(
        ["desktop"]="$HOME/Desktop"
        ["code"]="$HOME/Desktop/Code"
        ["js-scripts"]="$HOME/Desktop/Code/Node/js-scripts"
        ["bash-scripts"]="$HOME/Desktop/Code/Node/bash-scripts"
        ["icons"]="${LOCALAPPDATA:?}/Icons"
    )

    function usage() {
        echo "Usage: goto <directory-alias>"
        echo "Available directory aliases:"
        for alias in "${!dirmap[@]}"; do
            echo "  $alias -> ${dirmap[$alias]}"
        done
    }

    if [[ $# -eq 0 ]]; then
        usage
        return 1
    fi

    alias="$1"
    target_dir="${dirmap[$alias]}"

    if [[ -z "$target_dir" ]]; then
        echo "Error: Unknown directory alias '$alias'."
        usage
        exit 1
    fi

    if [[ ! -d "$target_dir" ]]; then
        echo "error: alias '$alias' target directory '$target_dir' does not yet exist."
        exit 1
    fi

    cd "$target_dir" || {
        echo "error: could not change directory to '$target_dir'."
        exit 1
    }

    echo "navigated to directory alias '$alias'."
    return 0
}

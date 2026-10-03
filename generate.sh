#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

js_scripts_executables_dir="$(cygpath "$HOME")/Desktop/Code/CLI/js-scripts/dist"

# shellcheck disable=SC1091
source "$cwd/scripts/functions.sh"

if ! "$cwd/add-utilities.sh"; then
    echo -e "\n$(color-text "error: failed to generate bash_aliases." red)"
    exit 1
fi

if ! "$cwd/add-rcfile.sh"; then
    echo -e "\n$(color-text "error: failed to generate global bashrc." red)"
    exit 1
fi

echo -e "\n$(color-text "successfully generated global bashrc and aliases." green)"
exit 0

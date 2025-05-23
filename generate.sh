#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$cwd/scripts/functions.sh"

if ! "$cwd/gen-bash-aliases-rcfile.sh"; then
    echo -e "\n$(color-text "error: failed to generate bash_aliases." red)"
    exit 1
fi

if ! "$cwd/gen-global-bash-rcfile.sh"; then
    echo -e "\n$(color-text "error: failed to generate global bashrc." red)"
    exit 1
fi

echo -e "\n$(color-text "successfully generated global bashrc and aliases." green)"
exit 0

#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! "$cwd/gen-bash-aliases-rcfile.sh"; then
    echo "Failed to generate bash aliases rcfile, aborting."
    exit 1
fi

if ! "$cwd/gen-global-bash-rcfile.sh"; then
    echo "Failed to generate global bash rcfile, aborting."
    exit 1
fi

printf "\nSuccessfully generated bash aliases rcfile and global bash rcfile."
exit 0

#!/bin/bash

# Completions file for the `goto` function defined in `goto.sh`
_goto() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    opts="desktop code node js-scripts bash-scripts"

    if [[ ${COMP_CWORD} -eq 1 ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
        return 0
    fi
}

complete -F _goto goto

#!/bin/bash

# Completions file for the `goto` function defined in `goto.sh`
_goto() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    opts="code code-cli code-desktop code-browser code-mobile"

    if [[ ${COMP_CWORD} -eq 1 ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
        return 0
    fi
}

complete -F _goto goto

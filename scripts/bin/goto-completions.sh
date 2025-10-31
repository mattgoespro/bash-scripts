#!/bin/bash

# show completion list as a single column
set print-completions-horizontally off

# Completions file for the `goto` function defined in `goto.sh`
_goto() {
    local cur opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"

    opts="bash-scripts        code       desktop      icons        js-scripts"

    if [[ ${COMP_CWORD} -eq 1 ]]; then
        mapfile -t COMPREPLY < <(compgen -W "${opts}" -- "${cur}")
        return 0
    fi
}

complete -F _goto goto

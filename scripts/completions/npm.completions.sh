#!/bin/bash

_npm_remove_package_completion() {
  local cur

  cur="${COMP_WORDS[COMP_CWORD]}"

  [[ "${COMP_WORDS[1]}" != "remove" ]] && return
  [[ ! -f package.json ]] && return
  command -v jq >/dev/null 2>&1 || return

  local packages
  packages="$(
    jq -r '
      (.dependencies // {} | keys[]) ,
      (.devDependencies // {} | keys[])
    ' package.json 2>/dev/null | tr -d '\r'
  )"

  mapfile -t COMPREPLY < <(compgen -W "$packages" -- "$cur")
}

complete -F _npm_remove_package_completion npm

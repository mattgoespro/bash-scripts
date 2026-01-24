#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "$cwd/scripts/functions.sh"

user_aliases_file_name=".user_aliases"

log_prefix="$(color-text "gen-global-bash-rcfile: " blue)"

function log() {
    local message="$1"

    # Split the message by newline and append the prefix to each line
    while IFS= read -r line; do
        echo "$(color-text "$log_prefix" blue)${line}"
    done <<<"$(echo -e "$message")"
}

function create-global-bashrc-file() {
    local global_bashrc_file_path="$1"
    local repo_bashrc_file_path="$2"

    if [[ -f "$global_bashrc_file_path" ]]; then
        rm -f "$global_bashrc_file_path"
    fi

    log "$(color-text "creating global bashrc..." green)"
    touch "$global_bashrc_file_path"

    # source this bashrc file
    {
        echo "#!/bin/bash" >>"$global_bashrc_file_path"
        echo "# shellcheck source=/dev/null"
        echo ". \"$repo_bashrc_file_path\""
    } >>"$global_bashrc_file_path"
}

function source-repo-bash-aliases() {
    local global_aliases_file_path="$1"
    local repo_aliases_file_path="$2"

    log "$(color-text "sourcing repo bash_aliases in global bashrc..." green)"
    echo "source \"$repo_aliases_file_path\"" >>"$global_aliases_file_path"

}

function source-utility-functions() {
    local global_bashrc_file_path="$1"
    local repo_functions="$cwd/scripts/functions.sh"

    log "$(color-text "sourcing utility functions in global bashrc..." green)"
    echo "source \"$repo_functions\"" >>"$global_bashrc_file_path"

}

function add-user-aliases() {
    local repo_aliases="$1"
    local user_aliases_file="$cwd/$user_aliases_file_name"

    log "$(color-text "sourcing user aliases in repo bash_aliases..." green)"
    echo "source \"$user_aliases_file\"" >>"$repo_aliases"
}

global_bashrc_file=$(cygpath "$HOME/.bashrc")
repo_bashrc_file="$cwd/.bashrc"

repo_bash_aliases_file="$cwd/.bash_aliases"

create-global-bashrc-file "$global_bashrc_file" "$repo_bashrc_file"
source-repo-bash-aliases "$global_bashrc_file" "$repo_bash_aliases_file"
source-utility-functions "$global_bashrc_file"
add-user-aliases "$repo_bash_aliases_file"

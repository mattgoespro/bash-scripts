#!/bin/bash

function log() {
    echo "gen-global-bash-rcfile: $*"
}

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "$cwd/scripts/functions.sh"

function create-global-bashrc-file() {
    local global_bashrc_file_path="$1"
    local repo_bashrc_file_path="$2"

    read -r -p "$(log "a bashrc file already exists at '$global_bashrc_file_path'. Type 'confirm' to overwrite it:") " response

    if [[ "$response" != "confirm" ]]; then
        log "aborting."
        exit 1
    fi

    global_bashrc_backup_file_path="$HOME/.bashrc.bak"

    if [[ -f "$global_bashrc_backup_file_path" ]]; then
        rm -f "$global_bashrc_backup_file_path"
        log "removed existing backup of bashrc file"
    fi

    cat "$global_bashrc_file_path" >"$global_bashrc_backup_file_path"
    log "created backup of bashrc file: $global_bashrc_backup_file_path"

    rm -f "$global_bashrc_file_path"
    log "removed existing bashrc file"

    log "initializing, creating bashrc file..."
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

    log "sourcing bash aliases..."

    echo "source \"$repo_aliases_file_path\"" >>"$global_aliases_file_path"
    log "added source of repo bash_aliases to global bashrc"
}

function source-utility-functions() {
    local global_bashrc_file_path="$1"

    log "sourcing functions..."

    local repo_functions="$cwd/scripts/functions.sh"

    echo "source \"$repo_functions\"" >>"$global_bashrc_file_path"
    log "added source of repo functions to global bashrc"
}

function add-user-aliases() {
    log "adding user-defined aliases..."

    local repo_aliases="$1"
    local user_aliases_file
    local user_aliases_file="$cwd/scripts/.user-aliases"

    echo "source \"$user_aliases_file\"" >>"$repo_aliases"
    log "added source of user-defined aliases to repo bash_aliases"
}

global_bashrc_file=$(cygpath "$HOME/.bashrc")
echo "global_bashrc_file: $global_bashrc_file"
repo_bashrc_file="$cwd/.bashrc"

repo_bash_aliases_file="$cwd/.bash_aliases"

create-global-bashrc-file "$global_bashrc_file" "$repo_bashrc_file"
source-repo-bash-aliases "$global_bashrc_file" "$repo_bash_aliases_file"
source-utility-functions "$global_bashrc_file"

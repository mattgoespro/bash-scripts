#!/bin/bash

function log() {
    echo "gen-global-bash-rcfile: $*"
}

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "$cwd/scripts/functions.sh"

function create-global-bashrc-file() {
    local global="$1"
    local repo="$2"

    read -r -p "$(log "a bashrc file already exists at '$global'. Type 'confirm' to overwrite it.") " response

    if [[ "$response" != "confirm" ]]; then
        log "aborting."
        exit 0
    fi

    backup_rcfile="$HOME/.bashrc.bak"

    if [[ -f "$backup_rcfile" ]]; then
        rm -f "$backup_rcfile"
        log "removed existing backup of bashrc file"
    fi

    cat "$global" >"$backup_rcfile"
    log "created backup of bashrc file: $backup_rcfile"

    rm -f "$global"
    log "removed existing bashrc file"

    log "initializing, creating bashrc file..."
    touch "$global"

    # source this bashrc file
    {
        echo "#!/bin/bash" >>"$global"

        echo "# shellcheck source=/dev/null"
        echo ". \"$repo\""
    } >>"$global"
}

function source-repo-bash-aliases() {
    local global="$1"
    local repo="$2"

    log "sourcing bash aliases..."

    echo "source \"$repo\"" >>"$global"
    log "added source of repo bash_aliases to global bashrc"
}

function source-utility-functions() {
    local global="$1"

    log "sourcing functions..."

    local repo_functions="$cwd/scripts/functions.sh"

    echo "source \"$repo_functions\"" >>"$global"
    log "added source of repo functions to global bashrc"
}
function add-user-defined-aliases() {
    log "adding user-defined aliases..."

    local repo_aliases="$1"
    local manual_aliases_file
    local manual_aliases_file="$cwd/scripts/.user-aliases"

    echo "source \"$manual_aliases_file\"" >>"$repo_aliases"
    log "added source of user-defined aliases to repo bash_aliases"
}

global_bashrc_file="$HOME/.bashrc"
repo_bashrc_file="$cwd/.bashrc"

repo_bash_aliases_file="$cwd/.bash_aliases"

create-global-bashrc-file "$global_bashrc_file" "$repo_bashrc_file"
source-repo-bash-aliases "$global_bashrc_file" "$repo_bash_aliases_file"
source-utility-functions "$global_bashrc_file"

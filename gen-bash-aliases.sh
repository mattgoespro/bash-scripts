#!/bin/bash

function log() {
    echo "add-aliases: $*"
}

source_dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
source "$source_dirname/scripts/bin/update-else-append-file.sh"

bashrc_file="$HOME/.bashrc"
repo_bash_aliases_file="$source_dirname/.bash_aliases"

if [ -f "$bashrc_file" ]; then
    rm -f "$bashrc_file"
fi

log "initializing, creating bashrc file for the first time..."

touch "$bashrc_file"

# source this bashrc file
{
    echo "#!/bin/bash" >>"$bashrc_file"

    repo_bashrc_file="$source_dirname/.bashrc"

    echo "# shellcheck source=/dev/null"
    echo "source \"$repo_bashrc_file\""
} >>"$bashrc_file"

# source the bash aliases
echo "source \"$repo_bash_aliases_file\"" >>"$bashrc_file"
log "added source of bash_aliases file in bashrc"

function generate-bash-aliases-rcfile() {
    if [ -f "$repo_bash_aliases_file" ]; then
        rm -f "$repo_bash_aliases_file"
    fi

    if ! grep -q "source $repo_bash_aliases_file" "$bashrc_file"; then
        echo "source \"$repo_bash_aliases_file\"" >>"$bashrc_file"
    fi
}

function extract_first_chars() {
    local input="$1"
    local result=""

    # Split the string by '-' and extract the first character of each part
    IFS='-' read -ra parts <<<"$input"

    if [ "${#parts[@]}" -eq 1 ]; then
        echo "${parts[0]}"
        return
    fi

    for part in "${parts[@]}"; do
        if [[ -z "$part" ]]; then
            echo "$input"
            return
        fi
        result+="${part:0:1}"
    done

    echo "$result"
}

function add-script-aliases() {
    log "adding script aliases..."

    while IFS= read -r -d '' file_path; do
        filename="$(basename "$file_path" .sh)"
        alias_cmd="alias $filename=\"$file_path\""

        if ! grep -q "$filename" "$repo_bash_aliases_file"; then
            echo "alias $filename=\"$file_path\"" >>"$repo_bash_aliases_file"
            log "added alias: '$filename' -> '$file_path'"
        else
            log "already exists: '$filename'"
        fi

        short_filename="$(extract_first_chars "$filename")"
        alias_cmd="alias $short_filename=\"$file_path\""

        if ! grep -q "$short_filename" "$repo_bash_aliases_file"; then
            echo "$alias_cmd" >>"$repo_bash_aliases_file"
            log "added '$filename' short alias: '$short_filename' -> '$file_path'"
        else
            log "already exists: '$short_filename'"
        fi
    done < <(find "$source_dirname/scripts/bin" -maxdepth 1 -name "*.sh" -type f -print0)
}

function add-cli-aliases() {
    log "adding CLI aliases..."

    local script_aliases_file
    script_aliases_file="$source_dirname/scripts/.cli-aliases"

    IFS=$'\n' read -d '' -r -a aliases <"$script_aliases_file"

    for alias_cmd in "${aliases[@]}"; do
        # get the alias name between the `alias ` and the `=`
        alias_name="$(echo "$alias_cmd" | cut -d' ' -f2 | cut -d'=' -f1)"

        if ! grep -q "$alias_name" "$repo_bash_aliases_file"; then
            echo "$alias_cmd" >>"$repo_bash_aliases_file"
            log "added custom alias: '$alias_cmd'"
        else
            log "already exists: '$alias_cmd'"
        fi
    done
}

function source-utility-functions() {
    log "sourcing functions..."

    local functions="$source_dirname/scripts/functions.sh"

    if ! grep -q "$functions" "$bashrc_file"; then
        echo "source \"$functions\"" >>"$bashrc_file"
        log "sourced functions from 'scripts/functions.sh'"
    else
        log "functions already sourced"
    fi
}

{
    generate-bash-aliases-rcfile
    add-script-aliases
    add-cli-aliases
    source-utility-functions
} || {
    log "error occurred, exiting..."
    exit 1
}

# shellcheck source=/dev/null
source "$bashrc_file"

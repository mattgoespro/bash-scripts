#!/bin/bash

function log() {
    echo "gen-bash-aliases-rcfile: $*"
}

source_dirname="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log "source_dirname: $source_dirname"

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

function add-script-shorthand-alias() {
    local repo_aliases="$1"
    local filename="$2"

    short_filename="$(extract_first_chars "$filename")"
    alias_cmd="alias $short_filename=\"$file_path\""

    if ! grep -q "$short_filename" "$repo_aliases"; then
        echo "$alias_cmd" >>"$repo_aliases"
        log "added '$filename' short alias: '$short_filename' -> '$file_path'"
    else
        log "already exists: '$short_filename'"
    fi
}

function add-script-aliases() {
    local repo_aliases="$1"

    log "generating script aliases..."

    while IFS= read -r -d '' file_path; do
        filename="$(basename "$file_path" .sh)"
        alias_cmd="alias $filename=\"$file_path\""

        if ! grep -q "$filename" "$repo_aliases"; then
            echo "alias $filename=\"$file_path\"" >>"$repo_aliases"
            log "added alias: '$filename' -> '$file_path'"
        else
            log "already exists: '$filename'"
        fi

        if grep -q "$filename" "./scripts/.shorthand-bin-aliases"; then
            add-script-shorthand-alias "$repo_aliases" "$filename"
        fi
    done < <(find "$source_dirname/scripts/bin" -maxdepth 1 -name "*.sh" -type f -print0)
}

function add-manual-aliases() {
    log "adding CLI aliases..."

    local repo_aliases="$1"
    local script_aliases_file
    script_aliases_file="$source_dirname/scripts/.manual-aliases"

    IFS=$'\n' read -d '' -r -a aliases <"$script_aliases_file"

    for alias_cmd in "${aliases[@]}"; do
        # get the alias name between the `alias ` and the `=`
        alias_name="$(echo "$alias_cmd" | cut -d' ' -f2 | cut -d'=' -f1)"

        if ! grep -q "$alias_name" "$repo_aliases"; then
            echo "$alias_cmd" >>"$repo_aliases"
            log "added custom alias: '$alias_cmd'"
        else
            log "already exists: '$alias_cmd'"
        fi
    done
}

function generate-repo-bash-aliases-rcfile() {
    local repo_bash_aliases_file="$source_dirname/.bash_aliases"

    log "generating repo bash aliases rcfile..."

    if [ -f "$repo_bash_aliases_file" ]; then
        rm -f "$repo_bash_aliases_file"
        log "removed existing repo bash aliases rcfile"
    fi

    echo "#!/bin/bash" >"$repo_bash_aliases_file"
    log "created repo bash aliases rcfile"

    add-script-aliases "$repo_bash_aliases_file"
    add-manual-aliases "$repo_bash_aliases_file"
}

generate-repo-bash-aliases-rcfile

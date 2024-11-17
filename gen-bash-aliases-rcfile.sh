#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function log() {
    local prefix="gen-bash-aliases-rcfile: "
    local message="$1"

    # Split the message by newline and append the prefix to each line
    while IFS= read -r line; do
        echo "${prefix}${line}"
    done <<<"$(echo -e "$message")"
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

function generated-alias-exists() {
    local generated_aliases_rcfile="$1"
    local alias_definition="$2"

    if grep -q "$alias_definition" "$generated_aliases_rcfile"; then
        return 0
    fi

    return 1
}

function script-has-shorthand-alias() {
    local script_alias="$1"

    if grep -q "= $script_alias" "$cwd/scripts/.shorthand-bin-aliases"; then
        return 0
    fi

    return 1
}

function add-script-shorthand-alias() {
    local generated_aliases_rcfile="$1"
    local script_file_name="$2"

    local script_short_file_name
    script_short_file_name="$(extract_first_chars "$script_file_name")"
    local alias_definition
    alias_definition="alias $script_short_file_name=\"$script_file_name\""

    if ! generated-alias-exists "$generated_aliases_rcfile" "$script_short_file_name"; then
        echo "$alias_definition" >>"$generated_aliases_rcfile"
        log "added '$filename' short alias: '$script_short_file_name' -> '$script_file_name'"
    else
        log "alias already exists: '$script_short_file_name'"
    fi
}

function add-script-aliases() {
    local generated_aliases_rcfile="$1"

    log "generating script aliases..."

    while IFS= read -r -d '' script_file_path; do
        local filename
        filename="$(basename "$script_file_path" .sh)"
        local alias_definition="alias $filename=\"$script_file_path\""

        if ! generated-alias-exists "$generated_aliases_rcfile" "$filename"; then
            echo "$alias_definition" >>"$generated_aliases_rcfile"
            log "added alias: '$filename' -> '$script_file_path'"
        else
            log "alias already exists: '$filename'"
        fi

        if script-has-shorthand-alias "$filename"; then
            add-script-shorthand-alias "$filename" "$generated_aliases_rcfile"
        fi
    done < <(find "$cwd/scripts/bin" -maxdepth 1 -name "*.sh" -type f -print0)
}

function add-user-defined-aliases() {
    log "adding user-defined aliases..."

    local repo_aliases="$1"
    local manual_aliases_file
    manual_aliases_file="$cwd/scripts/.user-aliases"

    IFS=$'\n' read -d '' -r -a aliases <"$manual_aliases_file"

    for alias_cmd in "${aliases[@]}"; do
        # get the alias name between the `alias ` and the `=`
        alias_name="$(echo "$alias_cmd" | cut -d' ' -f2 | cut -d'=' -f1)"

        if ! grep -q "$alias_name" "$repo_aliases"; then
            echo "$alias_cmd" >>"$repo_aliases"
            log "added manual alias: '$alias_cmd'"
        else
            log "alias already exists: '$alias_cmd'"
        fi
    done
}

function generate-repo-bash-aliases-rcfile() {
    local repo_bash_aliases_file="$cwd/.bash_aliases"

    log "generating repo bash aliases rcfile..."
    sleep 1

    if [ -f "$repo_bash_aliases_file" ]; then
        rm -f "$repo_bash_aliases_file"
        log "removed existing repo bash aliases rcfile"
    fi

    echo "#!/bin/bash" >"$repo_bash_aliases_file"
    log "created repo bash aliases rcfile: $repo_bash_aliases_file"
    sleep 2

    add-script-aliases "$repo_bash_aliases_file"
    log "\nsuccessfully added script aliases!"
    sleep 2

    add-user-defined-aliases "$repo_bash_aliases_file"
    log "\nsuccessfully added user aliases!"
}

generate-repo-bash-aliases-rcfile || {
    log "error: failed to generate repo bash aliases rcfile."
    exit 1
}

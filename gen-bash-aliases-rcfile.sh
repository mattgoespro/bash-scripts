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

    if [[ "${#parts[@]}" -eq 1 ]]; then
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

function script-has-user-alias() {
    local script_alias="$1"

    if grep -q "= $script_alias" "$cwd/.user-aliases"; then
        return 0
    fi

    return 1
}

function add-script-user-alias() {
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

function has-sourced-script() {
    local script_file_path="$1"
    local sourced_script_file_path="$2"

    if grep -q "$sourced_script_file_path" "$script_file_path"; then
        return 0
    fi

    return 1
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

        if script-has-user-alias "$filename"; then
            add-script-user-alias "$filename" "$generated_aliases_rcfile"
        fi
    done < <(find "$cwd/scripts/bin" -maxdepth 1 -name "*.sh" -type f -print0)
}

function add-js-scripts-executable-aliases() {
    local generated_aliases_rcfile="$1"

    log "generating aliases for js-scripts executables..."

    while IFS= read -r -d '' executable_file_path; do
        local filename
        filename="$(basename "$executable_file_path" .exe)"
        local alias_definition="alias $filename=\"$executable_file_path\""

        if ! generated-alias-exists "$generated_aliases_rcfile" "$filename"; then
            echo "$alias_definition" >>"$generated_aliases_rcfile"
            log "added js-scripts executable alias: '$filename' -> '$executable_file_path'"
        else
            log "js-scripts executable alias already exists: '$filename'"
        fi
    done < <(find "$(cygpath "$HOME")/Desktop/Code/Node/js-scripts/bin" -maxdepth 1 -name "*.exe" -type f -print0)
}

function generate-repo-bash-aliases-rcfile() {
    local repo_bash_aliases_file="$cwd/.bash_aliases"

    log "generating repo bash aliases rcfile..."
    sleep 1

    if [[ -f "$repo_bash_aliases_file" ]]; then
        rm -f "$repo_bash_aliases_file"
        log "removed existing repo bash aliases rcfile"
    fi

    echo "#!/bin/bash" >"$repo_bash_aliases_file"
    log "created repo bash aliases rcfile: $repo_bash_aliases_file"
    sleep 0.5

    add-script-aliases "$repo_bash_aliases_file"
    log "\nsuccessfully added script aliases!"
    sleep 0.5

    add-js-scripts-executable-aliases "$repo_bash_aliases_file"
    log "\nsuccessfully added js-scripts executable aliases!"
    sleep 0.5

    log "\nsuccessfully added user aliases!"
}

generate-repo-bash-aliases-rcfile || {
    log "error: failed to generate repo bash aliases rcfile."
    exit 1
}

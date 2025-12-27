#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$cwd/scripts/functions.sh"

user_aliases_file_name=".user_aliases"

function log() {
    local prefix="add-utilities: "
    local message="$1"

    # Split the message by newline and append the prefix to each line
    while IFS= read -r line; do
        echo "$(color-text "$prefix" blue)${line}"
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

    grep "$alias_definition" "$generated_aliases_rcfile"
    if grep -q "$alias_definition" "$generated_aliases_rcfile"; then
        return 0
    fi

    return 1
}

function script-has-user-alias() {
    local script_alias="$1"

    if grep -q "= $script_alias" "$cwd/$user_aliases_file_name"; then
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

    echo "$alias_definition" >>"$generated_aliases_rcfile"
    log "added '$(color-text "$filename" grey)' short alias: '$(color-text "$script_short_file_name" yellow)' -> '$(color-text "$script_file_name'" green)"
}

function add-script-aliases() {
    local generated_aliases_rcfile="$1"

    log "$(color-text "generating script aliases..." blue)"

    while IFS= read -r -d '' script_file_path; do
        local filename
        filename="$(basename "$script_file_path" .sh)"
        local alias_definition="alias $filename=\"$script_file_path\""

        echo "$alias_definition" >>"$generated_aliases_rcfile"
        log "$(color-text "added alias" "grey"): $(color-text "$filename" cyan) -> '$(color-text "$script_file_path'" green)"

        if script-has-user-alias "$filename"; then
            add-script-user-alias "$filename" "$generated_aliases_rcfile"
        fi
    done < <(find "$cwd/scripts/bin" -maxdepth 1 -name "*.sh" -type f -print0)
}

function add-js-scripts-executable-aliases() {
    local generated_aliases_rcfile="$1"
    local js_scripts_executables_dir
    js_scripts_executables_dir="$(cygpath "$HOME")/Desktop/Code/Node/js-scripts/dist"
    js_scripts_executables_ext=".exe"

    if [[ ! -d "$js_scripts_executables_dir" ]]; then
        log "$(color-text "[error] js-scripts executables in directory '$js_scripts_executables_dir' haven't been compiled, skipping." red) "
        return 1
    fi

    log "$(color-text "generating aliases for js-scripts executables in directory '$js_scripts_executables_dir'" blue)"

    while IFS= read -r -d '' executable_file_path; do
        local filename
        filename="$(basename "$executable_file_path" "$js_scripts_executables_ext")"
        local alias_definition="alias $filename=\"$executable_file_path\""

        echo "$alias_definition" >>"$generated_aliases_rcfile"
        log "$(color-text "added js-scripts executable alias: " "grey")$(color-text "$filename" magenta) -> '$(color-text "$executable_file_path'" green)"
    done < <(find "$js_scripts_executables_dir" -maxdepth 1 -name "*.exe" -type f -print0)
}

function add-bash-completions() {
    local generated_aliases_rcfile="$1"
    local bash_completions_dir
    bash_completions_dir="$cwd/scripts/completions"

    while IFS= read -r -d '' completions_file_path; do
        echo "source \"$completions_file_path\"" >>"$generated_aliases_rcfile"
        log "$(color-text "added bash completions: " "grey")$(color-text "$completions_file_path" pink)"
    done < <(find "$bash_completions_dir" -maxdepth 1 -name "*.completions.sh" -type f -print0)
}

function generate-repo-bash-aliases-rcfile() {
    local repo_bash_aliases_file="$cwd/.bash_aliases"

    if [[ -f "$repo_bash_aliases_file" ]]; then
        rm -f "$repo_bash_aliases_file"
        log "$(color-text "removed existing repo bash aliases rcfile: $repo_bash_aliases_file" grey)"
    fi

    log "$(color-text "generating repo bash aliases rcfile..." grey)"
    sleep 0.5

    if [[ -f "$repo_bash_aliases_file" ]]; then
        rm -f "$repo_bash_aliases_file"
        log "$(color-text "removed existing repo bash aliases rcfile: $repo_bash_aliases_file" grey)"
    fi

    echo "#!/bin/bash" >"$repo_bash_aliases_file"
    log "$(color-text "created repo bash aliases rcfile: $repo_bash_aliases_file" grey)"
    sleep 0.5

    add-script-aliases "$repo_bash_aliases_file"
    log "\n$(color-text "successfully added script aliases!" green)"
    log ""
    sleep 1

    add-js-scripts-executable-aliases "$repo_bash_aliases_file"
    log "\n$(color-text "successfully added js-scripts executable aliases!" green)"
    log ""

    add-bash-completions "$repo_bash_aliases_file"
    log "\n$(color-text "successfully added script completions!" green)"
    log ""
}

generate-repo-bash-aliases-rcfile || {
    log "$(color-text "error: failed to generate repo bash aliases rcfile" red)"
    exit 1
}

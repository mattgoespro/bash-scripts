#!/bin/bash

cwd="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function color() {
    if [[ "$#" -ne 2 ]]; then
        echo "Usage: color <color> <message>"
        return 1
    fi

    message="$1"
    color="$2"

    case "$2" in
    green)
        echo -e "\033[0;32m$message\033[0m"
        ;;
    dark-grey)
        echo -e "\033[0;90m$message\033[0m"
        ;;
    red)
        echo -e "\033[0;31m$message\033[0m"
        ;;
    yellow)
        echo -e "\033[0;33m$message\033[0m"
        ;;
    blue)
        echo -e "\033[0;34m$message\033[0m"
        ;;
    *)
        echo "Unknown color: $color"
        exit 1
        ;;
    esac

    return 0
}

function log() {
    local prefix="gen-bash-aliases-rcfile: "
    local message="$1"

    # Split the message by newline and append the prefix to each line
    while IFS= read -r line; do
        echo "$(color "$prefix" blue)${line}"
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
        log "added '$(color "$filename" dark-grey)' short alias: '$(color "$script_short_file_name" yellow)' -> '$(color "$script_file_name'" green)"
    else
        log "$(color "alias already exists: '$script_short_file_name'" yellow)"
    fi
}

function add-script-aliases() {
    local generated_aliases_rcfile="$1"

    log "$(color "generating script aliases..." blue)"

    while IFS= read -r -d '' script_file_path; do
        local filename
        filename="$(basename "$script_file_path" .sh)"
        local alias_definition="alias $filename=\"$script_file_path\""

        if ! generated-alias-exists "$generated_aliases_rcfile" "$filename"; then
            echo "$alias_definition" >>"$generated_aliases_rcfile"
            log "$(color "added alias" "dark-grey"): '$(color "$filename" yellow)' -> '$(color "$script_file_path'" green)"
        else
            log "$(color "alias already exists: '$filename'" dark-grey)"
        fi

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
        log "$(color "[error] js-scripts executables in directory '$js_scripts_executables_dir' haven't been compiled, skipping." red) "
        return 1
    fi

    log "$(color "generating aliases for js-scripts executables in directory '$js_scripts_executables_dir'" blue)"

    while IFS= read -r -d '' executable_file_path; do
        local filename
        filename="$(basename "$executable_file_path" "$js_scripts_executables_ext")"
        local alias_definition="alias $filename=\"$executable_file_path\""

        if ! generated-alias-exists "$generated_aliases_rcfile" "$filename"; then
            echo "$alias_definition" >>"$generated_aliases_rcfile"
            log "$(color "added js-scripts executable alias" "dark-grey"): '$(color "$filename" yellow)' -> '$(color "$executable_file_path'" green)"
        else
            log "$(color "js-scripts executable alias already exists: '$filename'" dark-grey)"
        fi
    done < <(find "$js_scripts_executables_dir" -maxdepth 1 -name "*.exe" -type f -print0)
}

function generate-repo-bash-aliases-rcfile() {
    local repo_bash_aliases_file="$cwd/.bash_aliases"

    log "$(color "generating repo bash aliases rcfile..." dark-grey)"
    sleep 0.5

    if [[ -f "$repo_bash_aliases_file" ]]; then
        rm -f "$repo_bash_aliases_file"
        log "$(color "removed existing repo bash aliases rcfile: $repo_bash_aliases_file" dark-grey)"
    fi

    echo "#!/bin/bash" >"$repo_bash_aliases_file"
    log "$(color "created repo bash aliases rcfile: $repo_bash_aliases_file" dark-grey)"
    sleep 0.5

    add-script-aliases "$repo_bash_aliases_file"
    log "\n$(color "successfully added script aliases!" green)"
    sleep 0.5

    add-js-scripts-executable-aliases "$repo_bash_aliases_file"
    log "\n$(color "successfully added js-scripts executable aliases!" green)"
    sleep 0.5

    log "\n$(color "successfully added user aliases!" green)"
}

generate-repo-bash-aliases-rcfile || {
    log "$(color "error: failed to generate repo bash aliases rcfile" red)"
    exit 1
}

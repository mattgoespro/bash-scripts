#!/bin/bash

extract_first_chars() {
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

add_bin_aliases() {
    while IFS= read -r -d '' file_path; do
        filename="$(basename "$file_path" .sh)"
        alias_cmd="alias $filename=\"$file_path\""

        if ! grep -q "$alias_cmd" "$HOME/.bash_aliases"; then
            echo "alias $filename=\"$file_path\"" >>"$HOME/.bash_aliases"
            echo "Added alias: '$filename' -> '$file_path'"
        else
            echo "Alias '$filename' already exists."
        fi

        short_filename="$(extract_first_chars "$filename")"
        alias_cmd="alias $short_filename=\"$file_path\""

        if ! grep -q "$alias_cmd" "$HOME/.bash_aliases"; then
            echo "$alias_cmd" >>"$HOME/.bash_aliases"
            echo "Added '$filename' short alias: '$short_filename' -> '$file_path'"
        else
            echo "Short alias '$short_filename' already exists."
        fi
    done < <(find "$(pwd)/scripts/bin" -maxdepth 1 -name "*.sh" -type f -print0)
}

add_fixed_aliases() {
    aliases_file="$(pwd)/scripts/aliases.sh"

    # remove the shebang and echo to `~/.bash_aliases`
    sed '1d' "$aliases_file" >>"$HOME/.bash_aliases"
    echo "Added aliases from '$aliases_file' to '~/.bash_aliases'"
}

source_functions() {
    # shellcheck disable=SC1091
    if ! grep -q "source $(pwd)/scripts/functions.sh" "$HOME/.bashrc"; then
        echo "source \"$(pwd)/scripts/functions.sh\"" >>"$HOME/.bashrc"
        echo "Sourced functions from 'scripts/functions.sh'"
    else
        echo "Functions already sourced."
    fi
}

add_bin_aliases
add_fixed_aliases
source_functions

# shellcheck disable=SC1091
source "$HOME/.bash_aliases"

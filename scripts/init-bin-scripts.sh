#!/bin/bash

if [ -z "$BinBashScripts" ]; then
    echo "error: environment value 'BinBashScripts' not set."
    exit 1
fi

if [ ! -d "$BinBashScripts" ]; then
    echo "error: 'BinBashScripts' directory does not exist: $bin_bash_scripts"
    exit 1
fi

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

bin_bash_scripts="$BinBashScripts"

while IFS= read -r -d '' file_path; do
    cp -a "$file_path" "$bin_bash_scripts"
    echo "Installed script '$file_path'"

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
done < <(find "$(pwd)/scripts" -maxdepth 1 -name "*.sh" -type f -print0)

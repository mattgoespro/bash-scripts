#!/bin/bash

if ! command -v subl &>/dev/null; then
    echo "error: sublime text executable not available on 'PATH'."
    exit 1
fi

open_path="$1"

if [[ -z "$open_path" ]]; then
    echo "Usage: open <path>"
    exit 1
fi

open_path_absolute=$(cygpath -w "$(realpath "$open_path")")
echo "info: converting '$open_path' to absolute path: '$open_path_absolute'"

if [[ -d "$open_path_absolute" ]]; then
    if [[ -d "$open_path_absolute\\.git" ]]; then
        read -t 0.5 -rp "Opening repository '$open_path_absolute' in Visual Studio Code..."
        code "$open_path_absolute"
        exit 0
    fi

    explorer "$open_path_absolute"
    exit 0
fi

if [[ ! -f "$open_path_absolute" ]]; then
    read -rp "Path '$open_path_absolute' not found, open a new file at this directory? [y/n] (default: n) " response

    if [[ "$response" != "y" ]]; then
        exit 1
    fi
fi

read -t 0.5 -rp "Opening '$open_path_absolute'..."

subl "$open_path_absolute"

exit 0

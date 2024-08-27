#!/bin/bash

function vdl() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
        echo "Usage: vdl <url> [filename]"
        return 1
    fi

    local url="$1"
    local filename="$2"
    local path="$HOME/Downloads/$filename"

    youtube-dl "$url" -o "$path"
}

function edit() {
    if ! command -v subl &>/dev/null; then
        echo "error: sublime text executable not found."
        return 1
    fi

    local file="$1"

    if [ -z "$file" ]; then
        echo "Usage: edit <file>"
        return 1
    fi

    if [ ! -f "$file" ]; then
        echo "error: file not found: $file"
        return 1
    fi

    subl "$file"
}

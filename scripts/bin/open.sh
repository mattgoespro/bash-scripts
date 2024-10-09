#!/bin/bash

if ! command -v subl &>/dev/null; then
    echo "error: sublime text executable not available on 'PATH'."
    exit 1
fi

arg_path="$1"

if [ -z "$arg_path" ]; then
    echo "Usage: open <path>"
    exit 1
fi

absolute_path=$(realpath "$arg_path")

if [ -d "$absolute_path" ]; then
    read -t 0.5 -rp "Opening '$absolute_path' in explorer..."
    explorer "$absolute_path"
    exit 0
fi

if [ ! -f "$absolute_path" ]; then
    read -rp "Path '$absolute_path' not found, open a new file at this directory? [y/n] (default: n) " response

    if [ "$response" != "y" ]; then
        exit 1
    fi
fi

read -t 0.5 -rp "Opening '$absolute_path'..."

subl "$absolute_path"

exit 0

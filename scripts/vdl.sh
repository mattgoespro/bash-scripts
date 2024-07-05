#!/bin/bash

function vdl () {
    if [ -z "$1" ]; then
        echo "Usage: vdl <url>"
        return 1
    fi

    local url="$1"
    local filename="$2"
    local path="$HOME/Downloads/$filename"

    youtube-dl -o "$path" "$url"
}
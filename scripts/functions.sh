#!/bin/bash

function vdl() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
        echo "Usage: vdl <url> [-a|--audio] [output_filename]"
        return 1
    fi

    # parse the --audio,-a flag from anywhere in the arguments
    local audio_flag=""
    for arg in "$@"; do
        if [ "$arg" == "--audio" ] || [ "$arg" == "-a" ]; then
        echo "Adding audio flag..."
            audio_flag="-x --audio-format mp3 --audio-quality 0"
            # remove the flag from the arguments
            set -- "${@/$arg/}"
            break
        fi
    done

    local url="$1"
    local output_filename="$2"

    if [ -z "$output_filename" ]; then
        output_filename="%(title)s.%(ext)s"
    fi

    local path="$HOME/Downloads/$output_filename"

    eval "yt-dlp $audio_flag $url -o \"$path\""
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

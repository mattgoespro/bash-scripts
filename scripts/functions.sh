#!/bin/bash

function vdl() {
    if [ $# -eq 0 ] || [ -z "$1" ]; then
        echo "Usage: vdl <url> [-a|--audio] [output_filename]"
        return 1
    fi

    # parse the --audio,-a flag from anywhere in the arguments
    local audio_flag=""

    OPTIND=1

    while getopts ":a:" opt; do
        case $opt in
        a)
            audio_flag="--extract-audio --audio-format mp3"
            ;;
        \?)
            echo "error: invalid option: -$OPTARG"
            return 1
            ;;
        esac
    done

    shift $((OPTIND - 1))

    local url="$1"
    local output_filename="$2"

    if [ -z "$output_filename" ]; then
        output_filename="%(title)s.%(ext)s"
    fi

    local path="$HOME/Downloads/$output_filename"

    eval "yt-dlp $audio_flag $url -o $path"
}

function open() {
    if ! command -v subl &>/dev/null; then
        echo "error: sublime text executable not found."
        return 1
    fi

    local path="$1"

    if [ -z "$path" ]; then
        echo "Usage: open <path>"
        return 1
    fi

    if [ ! -f "$path" ]; then
        read -rp "Path '$path' not found, open a new file at this directory? [y/n] (default: n) " response

        if [ "$response" != "y" ]; then
            return 1
        fi
    fi

    subl "$path"
}

function goto-desktop() {
    cd "$HOME/Desktop" || echo "error: could not change directory to $HOME/Desktop"
}

function goto-code() {
    cd "$HOME/Desktop/Code" || echo "error: could not change directory to $HOME/Desktop/Code"
}

function goto-js-scripts() {
    cd "$HOME/Desktop/Code/Node/repositories/js-scripts" || echo "error: could not change directory to $HOME/Desktop/Code/Node/js-scripts"
}

function edit-env() {
    open "$HOME/.bashrc"
}

function reload() {
    # shellcheck disable=SC1091
    source "$HOME/.bashrc"
}

#!/bin/bash

desktop_dir="$HOME/Desktop"
code_dir="$desktop_dir/Code"

function goto-desktop() {
    cd "$desktop_dir" || echo "error: failed to change directory to '$desktop_dir'"
}

function goto-code() {
    cd "$code_dir" || echo "error: failed to change directory to '$code_dir'"
}

function goto-js-scripts() {
    cd "$code_dir/Node/js-scripts" || echo "error: failed to change directory to '$code_dir/Node/js-scripts'"
}

function goto-bash-scripts() {
    cd "$code_dir/Node/js-scripts" || echo "error: failed to change directory to '$code_dir/Node/js-scripts'"
}

function goto() {
    dirmap=(
        [desktop]="$HOME/Desktop"
        [code]="$HOME/Desktop/Code"
        ["js-scripts"]="$HOME/Desktop/Code/Node/js-scripts"
        ["bash-scripts"]="$HOME/Desktop/Code/Node/bash-scripts"
        [icons]="$LOCALAPPDATA/Icons"
    )

    function usage() {
        echo "Usage: goto <directory-alias>"
        echo "Available directory aliases:"
        for alias in "${!dirmap[@]}"; do
            echo "  $alias -> ${dirmap[$alias]}"
        done
    }

    if [[ $# -eq 0 ]]; then
        usage
        return 1
    fi

    alias="$1"
    target_dir="${dirmap[$alias]}"

    if [[ -z "$target_dir" ]]; then
        echo "Error: Unknown directory alias '$alias'."
        usage
        exit 1
    fi

    if [[ ! -d "$target_dir" ]]; then
        echo "error: alias '$alias' target directory '$target_dir' does not yet exist."
        exit 1
    fi

    cd "$target_dir" || {
        echo "error: could not change directory to '$target_dir'."
        exit 1
    }

    echo "navigated to directory alias '$alias'."
    return 0
}

function home() {
    echo "navigating home..."
    cd "$HOME" || {
        echo "error: could not change directory to $HOME"
        return 1
    }
}

function edit-env() {
    # shellcheck disable=SC2154
    # open the .bashrc file at the project's root
    code "$BASH_SCRIPTS/.bashrc"
}

function reload() {
    # shellcheck source=/dev/null
    . "$HOME/.bashrc" && {
        echo "reloaded $HOME/.bashrc"
    }
}

function update-else-append-file() {
    if [[ ! -f "$1" ]]; then
        echo "[update-else-append-file] error: file '$1' not found."
        return 1
    fi

    local append_message="$3"

    if ! grep -q "$2" "$1"; then
        echo "$2" >>"$1"

        if [[ -z "$append_message" ]]; then
            echo "[update-else-append-file] appended '$2' to '$1'."
        else
            log "$append_message"
        fi
    fi

    echo "[update-else-append-file] line '$2' already exists in '$1'."

    return 0
}

function chrome-debug() {
    "/c/Program Files/Google/Chrome/Application/chrome.exe" --remote-debugging-port=9222
}

function find-file() {
    local file_name="$1"

    if [[ -z "$file_name" ]]; then
        echo "Usage: find-file <file-name> [search-dir]"
        echo "  file-name: the name of the file to search for"
        echo "  search-dir: the directory to search in (default: current directory)"
        return 1
    fi

    local search_dir="$2"

    if [[ -z "$search_dir" ]]; then
        search_dir="."
    fi

    if [[ ! -d "$search_dir" ]]; then
        echo "[find-file: error] search directory does not exist: $search_dir"
        return 1
    fi

    find "$search_dir" -type f -name "$file_name"
}

function find-dir() {
    local dir_name="$1"

    if [[ -z "$dir_name" ]]; then
        echo "Usage: find-dir <dir-name> [search-dir]"
        echo "  dir-name: the name of the directory to search for"
        echo "  search-dir: the directory to search in (default: current directory)"
        return 1
    fi

    local search_dir="$2"

    if [[ -z "$search_dir" ]]; then
        search_dir="."
    fi

    if [[ ! -d "$search_dir" ]]; then
        echo "[find-dir: error] search directory does not exist: $search_dir"
        return 1
    fi

    find "$search_dir" -type d -name "$dir_name"
}

function color-text() {
    if [[ "$#" -ne 2 ]]; then
        echo "Usage: color-text <color> <message>"
        return 1
    fi

    message="$1"
    color="$2"

    case "$2" in
    green)
        echo -e "\033[0;32m$message\033[0m"
        ;;
    grey)
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

function get-last-url-segment() {
    local url="$1"
    # Strip query parameters and fragments
    url="${url%%[\?#]*}"
    # Strip trailing slash if any
    url="${url%/}"
    # Extract last segment after the final slash
    echo "${url##*/}"
}


function lux-video-download() {
    if [[ -z "$1" ]]; then
        echo "Usage: lux-video-download <video-url> [output-file-name]"
        return 1
    fi

    local video_url="$1"
    local output_file_name="$2"

    if [[ -z "$output_file_name" ]]; then
        output_file_name=$(get-last-url-segment "$video_url")
    fi

    echo "Downloading video from $video_url to $output_file_name..."
    # Add your download command here
}
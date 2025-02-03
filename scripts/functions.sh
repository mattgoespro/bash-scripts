#!/bin/bash

function goto-desktop() {
    cd "$HOME/Desktop" || echo "error: could not change directory to $HOME/Desktop"
}

function goto-code() {
    cd "$HOME/Desktop/Code" || echo "error: could not change directory to $HOME/Desktop/Code"
}

function goto-js-scripts() {
    cd "$HOME/Desktop/Code/Node/js-scripts" || echo "error: could not change directory to $HOME/Desktop/Code/Node/js-scripts"
}

function home() {
    echo "navigating home..."
}

function edit-env() {
    # shellcheck disable=SC2154
    # open the .bashrc file at the project's root
    code "$BASH_SCRIPTS/.bashrc"
}

function reload() {
    # shellcheck disable=SC1091
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

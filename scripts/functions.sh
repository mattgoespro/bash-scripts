#!/bin/bash

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

function update-else-append-file() {
    if [ ! -f "$1" ]; then
        echo "[update-else-append-file] error: file '$1' not found."
        return 1
    fi

    local append_message="$3"

    if ! grep -q "$2" "$1"; then
        echo "$2" >>"$1"

        if [ -z "$append_message" ]; then
            echo "[update-else-append-file] appended '$2' to '$1'."
        else
            log "$append_message"
        fi
    fi

    echo "[update-else-append-file] line '$2' already exists in '$1'."

    return 0
}

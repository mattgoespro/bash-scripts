#!/bin/bash

function log() {
    echo "update-else-append-file: $*"
}

function update-else-append-file() {
    if [ ! -f "$1" ]; then
        log "error: file '$1' not found."
        return 1
    fi

    local append_message="$3"

    if ! grep -q "$2" "$1"; then
        echo "$2" >>"$1"

        if [ -z "$append_message" ]; then
            log "Appended '$2' to '$1'."
        else
            log "$append_message"
        fi
    fi

    log "Line '$2' already exists in '$1'."

    return 0
}

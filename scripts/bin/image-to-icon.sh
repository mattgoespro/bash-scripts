#!/bin/bash

function log() {
    echo "[vdl] $1"
}

function show_usage() {
    echo "usage: image-to-icon <image_file_path> [output_filename]"
}

# if yt-dlp executable is not on PATH, check common locations
imagemagick_executable="C:\Program Files\ImageMagick\magick.exe"

if [[ ! -f "$imagemagick_executable" ]]; then
    log "error: imagemagick executable not found: $imagemagick_executable"
    log "download the latest executable version from ImageMagick: https://imagemagick.org/script/download.php#windows"
    exit 1
fi

if [[ $# -eq 0 ]] || [[ -z "$1" ]]; then
    show_usage
    exit 1
fi

image_file_path="$1"
icon_filename="$2"

if [[ -z "$2" ]]; then
    image_file_extension="${image_file_path##*.}"
    icon_filename="$(basename "$image_file_path" "$image_file_extension").ico"
fi

"$imagemagick_executable" "$image_file_path" "$icon_filename"

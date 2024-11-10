#!/bin/bash

function log() {
    echo "[vdl] $1"
}

function show_usage() {
    echo "usage: vdl \"<url>\" [-a|--audio] [output_filename]"
}

yt_dlp_executable="C:\\ProgramData\\chocoportable\\bin\\yt-dlp.exe"

if [ ! -f "$yt_dlp_executable" ]; then
    log "error: yt-dlp executable not found: '$yt_dlp_executable'"
    exit 1
fi

if [ $# -eq 0 ] || [ -z "$1" ]; then
    show_usage
    exit 1
fi

# the URL must be quoted if it contains an ampersand
# if [[ "$1" == *"&"* ]]; then
#     log "error: url must be quoted."
#     exit 1
# fi

audio_flag=""

OPTIND=1

while getopts ":a:" opt; do
    case $opt in
    a)
        audio_flag="--extract-audio --audio-format mp3"
        ;;
    \?)
        show_usage
        exit 1
        ;;
    esac
done

shift $((OPTIND - 1))

url="$1"

output_filename=""

if [ -z "$2" ]; then
    output_filename="%(title)s.%(ext)s"
else
    output_filename="$2_%(title)s.%(ext)s"
fi

download_path="$HOME\\Downloads\\$output_filename"

read -r -t 1 -p "downloading video $url ..." -n 1

$yt_dlp_executable "$audio_flag" "$url" -o "$download_path"

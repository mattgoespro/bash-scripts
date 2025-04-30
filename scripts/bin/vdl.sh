#!/bin/bash

function log() {
    echo "[vdl] $1"
}

function show_usage() {
    echo "usage: vdl \"<url>\" [-a|--audio] [output_filename]"
}

yt_dlp_executable=""

if command -v yt-dlp &>/dev/null; then
    yt_dlp_executable="yt-dlp"
else
    for exe_location in $(
        "$HOME/scoop/shim/yt-dlp.exe"
        "${LOCALAPPDATA:?}/Microsoft/WinGet/Links/yt-dlp.exe"
    ); do
        if [[ -f "$exe_location" ]]; then
            yt_dlp_executable="$exe_location"
            break
        fi
    done
fi

if [[ -z "$yt_dlp_executable" ]]; then
    log "error: download yt-dlp before using this script."
    exit 1
fi

audio_flag=""

OPTIND=1

while getopts ":a:" opt; do
    case $opt in
    a)
        audio_flag="--extract-audio --audio-format mp3"
        ;;
    *)
        show_usage
        exit 1
        ;;
    esac
done

shift $((OPTIND - 1))

url="$1"

output_filename=""

if [[ -z "$2" ]]; then
    output_filename="%(title)s.%(ext)s"
else
    output_filename="$2_%(title)s.%(ext)s"
fi

download_path="$HOME\\Downloads\\$output_filename"

read -r -t 1 -p "downloading video $url ..." -n 1

yt-dlp "$audio_flag" "$url" -o "$download_path"

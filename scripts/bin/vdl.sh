#!/bin/bash

if [ -z "$BASH_SCRIPTS" ]; then
    echo "error: BASH_SCRIPTS environment variable not set"
    exit 1
fi

yt_dlp_executable="$BASH_SCRIPTS\\bin\\yt-dlp.exe"

if [ ! -f "$yt_dlp_executable" ]; then
    echo "error: yt-dlp executable not found"
    exit 1
fi

if [ $# -eq 0 ] || [ -z "$1" ]; then
    echo "Usage: vdl <url> [-a|--audio] [output_filename]"
    exit 1
fi

audio_flag=""

OPTIND=1

while getopts ":a:" opt; do
    case $opt in
    a)
        audio_flag="--extract-audio --audio-format mp3"
        ;;
    \?)
        echo "error: invalid option: -$OPTARG"
        exit 1
        ;;
    esac
done

shift $((OPTIND - 1))

url="$1"
echo "Downloading video from: $url"
output_filename="$2"

if [ -z "$output_filename" ]; then
    output_filename="%(title)s.%(ext)s"
fi

path="$HOME\\Downloads\\$output_filename"
eval "\"$yt_dlp_executable\" $audio_flag $url -o \"$path\""

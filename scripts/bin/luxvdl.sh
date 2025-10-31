#!/bin/bash

cwd="$(dirname "$0")/"

# shellcheck source=../functions.sh
source "$cwd/../functions.sh"

if ! command -v lux; then
    echo "error: 'lux' command not found. install \`lux\` using \`scoop install lux\`."
    exit 1 >>/dev/null
fi

if [[ -z "$1" ]]; then
    echo "Usage: lux-video-download <video-url> [output-file-name]"
    exit 1 >>/dev/null
fi

video_url="$1"
output_file_name="$2"

if [[ -z "$output_file_name" ]]; then
    output_file_name=$(get-last-url-segment "$video_url")
fi

echo "Downloading video: to $output_file_name..."
echo -e "\tURL: $video_url"echo -e "\tFilename: $output_file_name"

if ! lux -m -O "$HOME/Downloads/$output_file_name" "$video_url"; then
    color-text red "error: failed to download video from $video_url"
    exit 1 >>/dev/null
fi

color-text green "success: video downloaded to $HOME/Downloads/$output_file_name"
exit 0 >>/dev/null

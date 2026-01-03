#!/bin/bash

cwd="$(dirname "$0")/"

# shellcheck source=../functions.sh
source "$cwd/../functions.sh"

if ! command -v lux; then
    echo "error: 'lux' command not found. install \`lux\` using \`scoop install lux\`."
    exit 1 >>/dev/null
fi

if [[ -z "$1" ]]; then
    echo "Usage: luxvdl <video-url> [output-file-name]"
    exit 1 >>/dev/null
fi

video_url="$1"
output_file_name="$2"

if [[ -z "$output_file_name" ]]; then
    output_file_name=$(get-last-url-segment "$video_url")
fi

output_file_destination="$(cygpath -w "$HOME/Downloads/$output_file_name")"

echo "Downloading video with file name '$output_file_name'..."
echo -e "\tURL: $video_url"
echo -e "\tFilename: $output_file_name"
echo -e "\tDestination: $output_file_destination"

if ! lux -m -O "$output_file_destination" "$video_url"; then
    "$(color-text "error: failed to download video from $video_url" red)"
    exit 1 >>/dev/null
fi

"$(color-text "success: video downloaded -> $output_file_destination" green)"
exit 0 >>/dev/null

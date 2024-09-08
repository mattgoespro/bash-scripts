#!/bin/bash

# Function to display help message
usage() {
  echo "Usage: $0 <youtube_url> -ts <start_timestamp> -te <end_timestamp> -o <mp3_download_file>"
  exit 1
}

# Check if required programs are installed
if ! command -v yt-dlp &>/dev/null || ! command -v ffmpeg &>/dev/null; then
  echo "yt-dlp and ffmpeg are required to run this script."
  exit 1
fi

# Check if there are enough arguments
if [ "$#" -lt 7 ]; then
  usage
fi

# Parse arguments
url="$1"
start_time=""
end_time=""

shift
while [[ "$#" -gt 0 ]]; do
  case "$1" in
  -ts | --time-start)
    start_time="$2"
    shift 2
    ;;
  -te | --time-end)
    end_time="$2"
    shift 2
    ;;
  -o)
    output_file="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1"
    usage
    ;;
  esac
done

if [ -z "$start_time" ]; then
  # set to start of video
  start_time="00:00:00"
fi

if [ -z "$end_time" ]; then
  # set to end of video
  end_time=$(yt-dlp --get-duration "$url")
fi

if [ -z "$output_file" ]; then
  output_file="$HOME/Downloads/$(yt-dlp --get-title "$url").mp3"
fi

echo "Downloading audio to: $output_file"

# Download audio using yt-dlp
temp_file=$(mktemp).mp3
yt-dlp --extract-audio --audio-format mp3 "$url" -o "$temp_file"

# Trim audio using ffmpeg
echo "Trimming audio between '$start_time'-'$end_time'"
wait 1

ffmpeg -i "$temp_file" -ss "$start_time" -to "$end_time" -c copy "$output_file"

# Clean up
rm "$temp_file"

echo "Downloaded and trimmed audio saved to $output_file"

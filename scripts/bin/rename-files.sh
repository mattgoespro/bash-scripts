#!/bin/bash

dir=$1
name_substring=$2
replace_name_substring=$3

function usage() {
    echo "Usage: rename-files <directory> <name_substring> <replace_substring>"
    exit 1
}

if [[ -z "$dir" ]]; then
    echo "error: directory argument missing."
    usage
fi

if [[ -z "$name_substring" ]]; then
    echo "error: name_substring argument missing."
    usage
fi

if [[ -z "$replace_name_substring" ]]; then
    echo "error: replace_substring argument missing."
    usage
fi

IFS=$'\n' read -r -a file_list <<<"$(find "$dir" -name "*$name_substring*" -type f)"

if [[ ${#file_list[@]} -eq 0 ]]; then
    echo "No files matching '$name_substring' found in directory: '$dir'."
    exit 1
fi

for file in "${file_list[@]}"; do
    filename=$(basename "$file")
    file_dir=$(dirname "$file")
    new_file_name="${filename//$name_substring/$replace_name_substring}"
    mv "$file" "$file_dir/$new_file_name"
    echo "Renamed '$filename' -> '$new_file_name'"
done

exit 0

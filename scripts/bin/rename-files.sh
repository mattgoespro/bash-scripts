#!/bin/bash

dir=$1
name_substring=$2
replace_substring=$3

files_found="$(find "$dir" -name "*$name_substring*" -type f)"
# Store the results of the find command in an array
IFS=$'\n' read -r -a file_list <<<"$files_found"

if [[ ${#file_list[@]} -eq 0 ]]; then
    echo "No files matching '$name_substring' found in directory: '$dir'."
    exit 1
fi

for file in "${file_list[@]}"; do
    filename=$(basename "$file")
    file_dir=$(dirname "$file")
    new_file_name="${filename//$name_substring/$replace_substring}"
    mv "$file" "$file_dir/$new_file_name"
    echo "Renamed '$filename' -> '$new_file_name'"
done

exit 0

#!/bin/bash

while IFS= read -r -d '' file; do
    filename="$(basename "$file" .sh)"

    if ! grep -q "alias $filename=\"$file\"" "$HOME/.bash_aliases"; then
        echo "Adding alias for $filename"
        echo "alias $filename=\"$file\"" >> "$HOME/.bash_aliases"
    fi
done < <(find "$HOME/Desktop/Code/TypeScript/Repositories/bash-scripts/scripts" -maxdepth 1 -type f -print0)
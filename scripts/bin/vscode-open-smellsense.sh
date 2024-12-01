#!/bin/bash

smellsense_dir="/c/Users/Matt/Desktop/Code/SmellSense"

if [[ ! -d "$smellsense_dir" ]]; then
    echo "[vscode-open-bash-scripts: error] SmellSense directory does not exist: $smellsense_dir"
    exit 1 >>/dev/null
fi

code "$smellsense_dir"

#!/bin/bash

bash_scripts_dir="/c/Users/Matt/Desktop/Code/Other/bash-scripts"

if [[ ! -d "$bash_scripts_dir" ]]; then
    echo "[vscode-open-bash-scripts: error] bash scripts directory does not exist: $bash_scripts_dir"
    exit 1 >>/dev/null
fi

code "$bash_scripts_dir"

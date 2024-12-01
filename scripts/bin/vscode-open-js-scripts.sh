#!/bin/bash

js_scripts_dir="/c/Users/Matt/Desktop/Code/Node/js-scripts"

if [[ ! -d "$js_scripts_dir" ]]; then
    echo "[vscode-open-bash-scripts: error] js scripts directory does not exist: $js_scripts_dir"
    exit 1 >>/dev/null
fi

code "$js_scripts_dir"

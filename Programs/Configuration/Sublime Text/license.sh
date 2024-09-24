#!/bin/bash

subl_text_patcher_dir="$TEMP\\sublime-text-4-patcher"

if [ -d "$subl_text_patcher_dir" ]; then
    rm -rf "$subl_text_patcher_dir" || {
        echo "ERROR: failed to remove existing patcher directory: $subl_text_patcher_dir"
        exit 1
    }
fi

subl_text_patcher_repo="https://github.com/rainbowpigeon/sublime-text-4-patcher"

echo "Cloning repository source '$subl_text_patcher_repo'..."

git clone "$subl_text_patcher_repo" "$subl_text_patcher_dir" || {
    echo "ERROR: failed to clone 'sublime-text-4-patcher' repository: $subl_text_patcher_repo"
    exit 1
}

# cd "$subl_text_patcher_dir" || {
#     echo "ERROR: failed to enter patching directory: $subl_text_patcher_dir"
#     exit 1
# }

echo "Creating sublime-text-4-patcher Python virtual environment..."
python_environment_dir="$subl_text_patcher_dir\\.venv"

if ! python -m venv "$python_environment_dir"; then
    echo "ERROR: failed to create Python virtual environment in '$subl_text_patcher_dir'"
    exit 1
fi

# shellcheck source=/dev/null
source "$python_environment_dir\\Scripts\\activate"

echo "Installing sublime-text-4-patcher dependencies..."

if ! pip install -r "$subl_text_patcher_dir\\requirements.txt"; then
    echo "ERROR: failed to install Python dependencies"
    exit 1
fi

echo "Patching Sublime Text executable..."

sublime_text_exe="$PROGRAMFILES\\Sublime Text\\sublime_text.exe"

if [ ! -f "$sublime_text_exe" ]; then
    echo "ERROR: Sublime Text executable not found: $sublime_text_exe"
    exit 1
fi

python "$subl_text_patcher_dir\\sublime_text_patcher.py" "$sublime_text_exe" || {
    echo "ERROR: failed to patch Sublime Text 4"
    exit 1
}

# shellcheck source=/dev/null
. "$HOME/.bashrc"

if read -r -p "Hit [Enter] to open Sublime Text and enter the license code..."; then
    sample_license="----- BEGIN LICENSE -----
TwitterInc
200 User License
EA7E-890007
1D77F72E 390CDD93 4DCBA022 FAF60790
61AA12C0 A37081C5 D0316412 4584D136
94D7F7D4 95BC8C1C 527DA828 560BB037
D1EDDD8C AE7B379F 50C9D69D B35179EF
2FE898C4 8E4277A8 555CE714 E1FB0E43
D5D52613 C3D12E98 BC49967F 7652EED2
9D2D2E61 67610860 6D338B72 5CF95C69
E36B85CC 84991F19 7575D828 470A92AB
------ END LICENSE ------"

    echo "$sample_license" | clip.exe
    echo "copied license key to clipboard"

    if ! subl; then
        echo "ERROR: failed to open Sublime Text"
        exit 1
    fi

    echo "Opening Sublime Text..."
fi

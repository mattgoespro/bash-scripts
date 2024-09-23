#!/bin/bash

repository="https://github.com/rainbowpigeon/sublime-text-4-patcher"
repository_dir="./sublime-text-4-patcher"

echo "Cloning repository..."

git clone $repository $repository_dir || {
    echo "error: failed to clone 'sublime-text-4-patcher' repository: $repository"
    exit 1
}

cd repository_dir || {
    echo "error: failed to enter patching directory: $repository_dir"
    exit 1
}

echo "Creating virtual environment..."

# shellcheck disable=SC1091
if ! python -m venv .venv; then
    echo "error: failed to create virtual environment"
    exit 1
fi

# shellcheck disable=SC1091
source ./.venv/Scripts/activate

echo "Installing python dependencies..."

if ! pip install -r requirements.txt; then
    echo "error: failed to install python dependencies"
    exit 1
fi

echo "Patching Sublime Text 4..."

python sublime_text_4_patcher.py "C:\\Program Files\\Sublime Text\\sublime_text.exe" || {
    echo "error: failed to patch Sublime Text 4"
    exit 1
}

# shellcheck disable=SC1091
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
    echo "Copied license key to clipboard"

    if ! subl; then
        echo "error: failed to open Sublime Text 4"
        exit 1
    fi

    echo "Opening Sublime Text 4..."
fi

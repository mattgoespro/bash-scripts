#!/bin/bash

if ! command -v curl; then
    echo "info: first install curl to install nvm"
    exit 0
fi

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash || {
    echo "Failed to install nvm"
    exit 1
}

exit 0

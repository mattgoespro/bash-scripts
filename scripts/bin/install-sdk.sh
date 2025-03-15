#!/bin/bash

function usage() {
  echo "Usage: install-sdk.sh <sdk>"
  echo "    sdk    the name of the SDK to install. Available SDKs: nvm, docker"
  exit 1
}

# check that OS is linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo "This script is for Linux only."
  exit 1
fi

cwd=$(dirname "$0")

case "$1" in
nvm)
  echo "Installing nvm..."

  if ! "$cwd/nvm.sh"; then
    echo "Failed to install nvm."
    exit 1
  fi

  echo -e "\nnvm installation complete."
  ;;
docker)
  echo "Installing Docker..."

  if ! "$cwd/docker.sh"; then
    echo "Failed to install Docker."
    exit 1
  fi

  echo -e "\nDocker installation complete."
  ;;
*)
  usage
  ;;
esac

exit 0

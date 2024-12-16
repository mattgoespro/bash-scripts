#!/bin/bash

# shellcheck source=/dev/null
source "$HOME/Desktop/Code/Other/bash-scripts/scripts/functions.sh"

# shellcheck source=/dev/null
source "$HOME/Desktop/Code/Other/bash-scripts/.bash_aliases"

source "$HOME/Desktop/Code/Other/bash-scripts/.user-aliases"

# System
PROGRAMDATA="/c/ProgramData"
PROGRAMFILES="/c/Program Files"

LOCALAPPDATA="/c/Users/Matt/AppData/Local"

# System Programs
ANDROID_STUDIO="$PROGRAMFILES/Android/Android Studio"
CHOCOLATEY="$PROGRAMDATA/chocolatey"
GIT="$PROGRAMFILES/Git"
VOLTA="$PROGRAMFILES/Volta"
SUBLIME_TEXT="$PROGRAMFILES/Sublime Text"

USER_PATH="$CHOCOLATEY/bin:\
$GIT/bin:\
$GIT/cmd:\
$GIT/mingw64/bin:\
$GIT/usr/bin:\
$SUBLIME_TEXT:\
$VOLTA"

# User
export APPDATA="$HOME/AppData/Roaming"
export HOME="$USER"

# Repository Paths
export BASH_SCRIPTS="$HOME/Desktop/Code/Other/bash-scripts"

# Local Application Data
VOLTA_LOCAL="$LOCALAPPDATA/Volta"
PYTHON_LOCAL="$LOCALAPPDATA/Programs/Python"

USER_PATH="$USER_PATH:\
$VOLTA_LOCAL:\
$VOLTA_LOCAL/bin"

# Android Studio Paths
ANDROID_SDK_HOME="$LOCALAPPDATA/Android/Sdk"
ANDROID_SDK_CLI_TOOLS="$ANDROID_SDK_HOME/cmdline-tools/latest/bin"
ANDROID_SDK_PLATFORM_TOOLS="$ANDROID_SDK_HOME/platform-tools"
ANDROID_SDK_EMULATOR="$ANDROID_SDK_HOME/emulator"

USER_PATH="$USER_PATH:\
$ANDROID_SDK_CLI_TOOLS:\
$ANDROID_SDK_PLATFORM_TOOLS:\
$ANDROID_SDK_EMULATOR"

# Volta Packages
export NODE_LOCAL="$VOLTA_LOCAL/tools/image/node/20.17.0"

USER_PATH="$USER_PATH:\
$NODE_LOCAL"

# Application Configuration Paths
export JAVA_HOME="$HOME/.jdks/corretto-20.0.2.1"
export PYTHONPATH="$PYTHON_LOCAL/Python312"

USER_PATH="$USER_PATH:\
$JAVA_HOME/bin:\
$PYTHONPATH:\
$PYTHONPATH/Scripts:\
$LOCALAPPDATA/flutter/bin:\
/c/Users/Matt/.bun/bin"

# Final Path
export PATH="$USER_PATH:$PATH"

# `js-scripts` required environment variable values
export APP_DATA_DIR="$TEMP"
export VIDEO_CACHE_PATH="$APP_DATA_DIR/VideoCache"
export YOUTUBE_API_CLIENT="http"
export STEAMWEB_API_KEY="$STEAMWEB_API_KEY"
export STEAM_ID="[U:1:90260760]"

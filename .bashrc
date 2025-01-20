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
CHOCOLATEY="$PROGRAMDATA/chocolatey"
GIT="$PROGRAMFILES/Git"
VOLTA="$PROGRAMFILES/Volta"
SUBLIME_TEXT="$PROGRAMFILES/Sublime Text"
IMAGEMAGICK="$PROGRAMFILES/ImageMagick"

USER_PATH="$CHOCOLATEY/bin:\
$GIT/bin:\
$GIT/cmd:\
$GIT/mingw64/bin:\
$GIT/usr/bin:\
$SUBLIME_TEXT:\
$VOLTA:\
$IMAGEMAGICK"

# User
export APPDATA="$HOME/AppData/Roaming"
export HOME="$USER"

# Repository Paths
export BASH_SCRIPTS="$HOME/Desktop/Code/Other/bash-scripts"

# Local Application Data
CONDA_LOCAL="$LOCALAPPDATA/Programs/miniconda3"
VOLTA_LOCAL="$LOCALAPPDATA/Volta"
PYTHON_LOCAL="$LOCALAPPDATA/Programs/Python"
TINYTEXT_LOCAL="$LOCALAPPDATA/Programs/TinyTeX"

USER_PATH="$USER_PATH:\
$VOLTA_LOCAL:\
$VOLTA_LOCAL/bin:\
$CONDA_LOCAL/Scripts:\
$TINYTEXT_LOCAL/bin/windows"

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

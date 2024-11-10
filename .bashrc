#!/bin/bash

# shellcheck source=/dev/null
source "$HOME\\Desktop\\Code\\Other\\bash-scripts\\scripts\\functions.sh"

# shellcheck source=/dev/null
source "$HOME\\Desktop\\Code\\Other\\bash-scripts\\.bash_aliases"

# System
PROGRAMDATA="C:\\ProgramData"
export PROGRAMFILES="C:\\Program Files"

USER_PATH="$WINDOWS:\
$SYSTEM32:\
$SYSWOW64"

# System Programs
export ANDROID_STUDIO="$PROGRAMFILES\\Android\\Android Studio"
export CHOCOLATEY="$PROGRAMDATA\\chocolatey"
export GIT="$PROGRAMFILES\\Git"
export VOLTA="$PROGRAMFILES\\Volta"
SUBLIME_TEXT="$PROGRAMFILES\\Sublime Text"

USER_PATH="$USER_PATH:\
$CHOCOLATEY\\bin:\
$GIT\\bin:\
$GIT\\cmd:\
$GIT\\mingw64\\bin:\
$GIT\\usr\\bin:\
$SUBLIME_TEXT:\
$VOLTA"

# User
export APPDATA="$HOME\\AppData\\Roaming"
export HOME="$USER"

# Repository Paths
export BASH_SCRIPTS="$HOME\\Desktop\\Code\\Other\\bash-scripts"

# Local Application Data
export VOLTA_LOCAL="$LOCALAPPDATA\\Volta"
PYTHON_LOCAL="$LOCALAPPDATA\\Programs\\Python"

USER_PATH="$USER_PATH:\
$VOLTA_LOCAL:\
$VOLTA_LOCAL\\bin"

# Android Studio Paths
export ANDROID_SDK="$LOCALAPPDATA\\Android\\Sdk"
ANDROID_SDK_CLI_TOOLS="$ANDROID_SDK\\cmdline-tools\\latest\\bin"
ANDROID_SDK_PLATFORM_TOOLS="$ANDROID_SDK\\platform-tools"
ANDROID_SDK_EMULATOR="$ANDROID_SDK\\emulator"

USER_PATH="$USER_PATH:\
$ANDROID_SDK_CLI_TOOLS:\
$ANDROID_SDK_PLATFORM_TOOLS:\
$ANDROID_SDK_EMULATOR"

# Volta Packages
export NODE_LOCAL="$VOLTA_LOCAL\\tools\\image\\node\\20.17.0"

USER_PATH="$USER_PATH:\
$NODE_LOCAL"

# Application Configuration Paths
export JAVA_HOME="$ANDROID_STUDIO\\jbr"
export PYTHONPATH="$PYTHON_LOCAL\\Python312"

USER_PATH="$USER_PATH:\
$JAVA_HOME\\bin:\
$PYTHONPATH:\
$PYTHONPATH\\Scripts:\
$HOME\\.bun\\bin"

# Final Path
export PATH="$PATH:$USER_PATH"

# Manual Variables
export APP_DATA_DIR="$TEMP"
export VIDEO_CACHE_PATH="$APP_DATA_DIR\\VideoCache"
export API_CLIENT_TYPE="http"

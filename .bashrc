#!/bin/bash

# System
export WINDOWS="C:\\Windows"
export SYSTEM32="$WINDOWS\\System32"
export SYSWOW64="$WINDOWS\\SysWOW64"
export PROGRAMFILES="C:\\Program Files"
export PROGRAMFILESX86="C:\\Program Files (x86)"
export PROGRAMDATA="C:\\ProgramData"

# System Programs
export GIT="$PROGRAMFILES\\Git"
export VOLTA="$PROGRAMFILES\\Volta"
export CHOCOLATEY="$PROGRAMDATA\\chocolatey"

# User
export HOME="$USER"
export APPDATA="$HOME\\AppData\\Roaming"
export LOCALAPPDATA="$HOME\\AppData\\Local"

# Application Data
export VOLTA_LOCAL="$LOCALAPPDATA\\Volta"

# Volta Packages
export VOLTA_TOOLS="$VOLTA_LOCAL\\tools\\image"
export NODE_LOCAL="$VOLTA_TOOLS\\image\\node\\20.17.0"
export SHELLCHECK_LOCAL="$VOLTA_TOOLS\\shared\\shellcheck"

# Path
export PATH="$CHOCOLATEY\\bin:\
$GIT\\cmd:\
$GIT\\mingw64\\bin:\
$GIT\\usr\\bin:\
$LOCALAPPDATA\\Microsoft\\WinGet\\Links:\
$NODE_LOCAL:\
$SHELLCHECK_LOCAL\\bin:\
$SYSTEM32:\
$SYSWOW64:\
$VOLTA\\bin"

# shellcheck source=/dev/null
source "$HOME\\Desktop\\Code\\Other\\bash-scripts\\scripts\\functions.sh"

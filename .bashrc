#!/bin/bash

# shellcheck source=/dev/null
source "$HOME/Desktop/Code/Other/bash-scripts/scripts/functions.sh"

# shellcheck source=/dev/null
source "$HOME/Desktop/Code/Other/bash-scripts/.bash_aliases"

source "$HOME/Desktop/Code/Other/bash-scripts/.user-aliases"

#####################################################################
#                                                                   #
#                       SYSTEM DIRECTORIES                          #
#                                                                   #
#####################################################################

PROGRAMDATA=

if [[ -z "$PROGRAMDATA" ]]; then
    PROGRAMDATA="/c/ProgramData"
fi

PROGRAMFILES=

if [[ -z "$PROGRAMFILES" ]]; then
    PROGRAMFILES="/c/Program Files"
fi

#####################################################################
#                                                                   #
#                      SYSTEM APPLICATIONS                          #
#                                                                   #
#####################################################################
GIT="$PROGRAMFILES/Git"
SUBLIME_TEXT="$PROGRAMFILES/Sublime Text"

USER_PATH="$CHOCOLATEY/bin:\
$GIT/bin:\
$GIT/cmd:\
$GIT/mingw64/bin:\
$GIT/usr/bin:\
$SUBLIME_TEXT"

#####################################################################
#                                                                   #
#                       USER DIRECTORIES                            #
#                                                                   #
#####################################################################
LOCALAPPDATA="${LOCALAPPDATA:-}"

#####################################################################
#                                                                   #
#                      PACKAGE MANAGERS                             #
#                                                                   #
#####################################################################
SCOOP="$HOME/scoop"
CHOCOLATEY="$PROGRAMDATA/chocolatey"
VOLTA="$PROGRAMFILES/Volta"
PNPM="$LOCALAPPDATA/pnpm"

USER_PATH="$USER_PATH:\
$SCOOP/shims:\
$CHOCOLATEY/bin:\
$VOLTA:\
$PNPM"

#####################################################################
#                                                                   #
#                      VOLTA APPLICATIONS                           #
#                                                                   #
#####################################################################
NODE_LOCAL="$VOLTA_LOCAL/tools/image/node/22.14.0"

USER_PATH="$USER_PATH:\
$NODE_LOCAL"

#####################################################################
#                                                                   #
#                      LOCAL APPLICATIONS                           #
#                                                                   #
#####################################################################
VOLTA_LOCAL="$LOCALAPPDATA/Volta"
PYTHON_LOCAL="$LOCALAPPDATA/Programs/Python/Python312"
SCOOP_LOCAL="$HOME/scoop"
TINYTEXT_LOCAL="$LOCALAPPDATA/Programs/TinyTeX"

USER_PATH="$USER_PATH:\
$PYTHON_LOCAL:\
$PYTHON_LOCAL/Scripts:\
$VOLTA_LOCAL:\
$VOLTA_LOCAL/bin:\
$TINYTEXT_LOCAL/bin/windows"

#####################################################################
#                                                                   #
#                      ANDROID SDK DIRECTORIES                      #
#                                                                   #
#####################################################################
ANDROID_SDK_HOME="$LOCALAPPDATA/Android/Sdk"
ANDROID_SDK_CLI_TOOLS="$ANDROID_SDK_HOME/cmdline-tools/latest/bin"
ANDROID_SDK_PLATFORM_TOOLS="$ANDROID_SDK_HOME/platform-tools"
ANDROID_SDK_EMULATOR="$ANDROID_SDK_HOME/emulator"

USER_PATH="$USER_PATH:\
$ANDROID_SDK_CLI_TOOLS:\
$ANDROID_SDK_PLATFORM_TOOLS:\
$ANDROID_SDK_EMULATOR"

#####################################################################
#                                                                   #
#                    APPLICATION CONFIGURATION                      #
#                                                                   #
#####################################################################
export JAVA_HOME="$HOME/.jdks/corretto-20.0.2.1"
export TEXINPUTS="$SCOOP_LOCAL/apps/texlive/2025.02/texmf-dist"

USER_PATH="$USER_PATH:\
$JAVA_HOME/bin:\
$LOCALAPPDATA/flutter/bin:\
$HOME/.bun/bin"

#####################################################################
#                                                                   #
#                     REPORITORY DIRECTORIES                        #
#                                                                   #
#####################################################################
export BASH_SCRIPTS="$HOME/Desktop/Code/Other/bash-scripts"

# Final Path
export PATH="$USER_PATH:$PATH"

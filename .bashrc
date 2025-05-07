#!/bin/bash

# shellcheck source=/dev/null
source "$HOME/Desktop/Code/Other/bash-scripts/scripts/functions.sh"

# shellcheck source=/dev/null
source "$HOME/Desktop/Code/Other/bash-scripts/.bash_aliases"

source "$HOME/Desktop/Code/Other/bash-scripts/.user_aliases"

#####################################################################
#                                                                   #
#                       SYSTEM DIRECTORIES                          #
#                                                                   #
#####################################################################
PROGRAMFILES=$(cygpath "${PROGRAMFILES:-}")

#####################################################################
#                                                                   #
#                      SYSTEM APPLICATIONS                          #
#                                                                   #
#####################################################################
GIT="$PROGRAMFILES/Git"
SUBLIME_TEXT="$PROGRAMFILES/Sublime Text"

USER_PATH="$GIT/bin:\
$GIT/cmd:\
$GIT/mingw64/bin:\
$GIT/usr/bin:\
$SUBLIME_TEXT"

#####################################################################
#                                                                   #
#                       USER DIRECTORIES                            #
#                                                                   #
#####################################################################
LOCALAPPDATA=$(cygpath "${LOCALAPPDATA:-}")
export LOCALAPPDATA

#####################################################################
#                                                                   #
#                      PACKAGE MANAGERS                             #
#                                                                   #
#####################################################################
SCOOP="$HOME/scoop"

USER_PATH="$USER_PATH:\
$SCOOP/shims"

#####################################################################
#                                                                   #
#                      LOCAL APPLICATIONS                           #
#                                                                   #
#####################################################################
VOLTA_LOCAL="$LOCALAPPDATA/Volta"
PYTHON_LOCAL="$LOCALAPPDATA/Programs/Python/Python312"

USER_PATH="$USER_PATH:\
$PYTHON_LOCAL:\
$PYTHON_LOCAL/Scripts:\
$VOLTA_LOCAL:\
$VOLTA_LOCAL/bin"

#####################################################################
#                                                                   #
#                      VOLTA APPLICATIONS                           #
#                                                                   #
#####################################################################
NODE_VERSION="22.15.0"
NODE_LOCAL="$VOLTA_LOCAL/tools/image/node/$NODE_VERSION"

if [[ -d "$NODE_LOCAL" ]]; then
    USER_PATH="$USER_PATH:$NODE_LOCAL"

    BUN="$NODE_LOCAL/node_modules/bun/bin"

    if [[ -d "$BUN" ]]; then
        USER_PATH="$USER_PATH:$BUN"
    else
        echo "Skipping environment configuration for Bun because it is not installed."
    fi
else
    echo "Skipping environment configuration for Node because version $NODE_VERSION is not installed/active."
fi

#####################################################################
#                                                                   #
#                      ANDROID SDK DIRECTORIES                      #
#                                                                   #
#####################################################################
ANDROID_SDK_HOME="$LOCALAPPDATA/Android/Sdk"

if [[ -d "$ANDROID_SDK_HOME" ]]; then
    echo "Android SDK found at $ANDROID_SDK_HOME"
    echo "Configuring environment for Android SDK..."
    ANDROID_SDK_CLI_TOOLS="$ANDROID_SDK_HOME/cmdline-tools/latest/bin"
    ANDROID_SDK_PLATFORM_TOOLS="$ANDROID_SDK_HOME/platform-tools"
    ANDROID_SDK_EMULATOR="$ANDROID_SDK_HOME/emulator"

    USER_PATH="$USER_PATH:\
    $ANDROID_SDK_CLI_TOOLS:\
    $ANDROID_SDK_PLATFORM_TOOLS:\
    $ANDROID_SDK_EMULATOR"
fi

#####################################################################
#                                                                   #
#                    APPLICATION CONFIGURATION                      #
#                                                                   #
#####################################################################
JAVA_HOME="$HOME/.jdks/corretto-20.0.2.1"

if [[ -d "$JAVA_HOME" ]]; then
    echo "Java found at $JAVA_HOME"
    echo "Configuring environment for Java..."

    export JAVA_HOME

    USER_PATH="$USER_PATH:\
        $JAVA_HOME/bin:\
        $LOCALAPPDATA/flutter/bin"
fi

#####################################################################
#                                                                   #
#                     REPORITORY DIRECTORIES                        #
#                                                                   #
#####################################################################
export BASH_SCRIPTS="$HOME/Desktop/Code/Other/bash-scripts"

# Final Path
export PATH="$PATH:$USER_PATH"

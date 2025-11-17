#!/bin/bash

chrome_exe="${PROGRAMFILES:?}/Google/Chrome/Application/chrome.exe"

if [[ ! -f "${chrome_exe}" ]]; then
    echo "error: Chrome executable not found at '${chrome_exe}'"
    exit 1 >>/dev/null
fi

"${chrome_exe}" --remote-debugging-port=9222 --user-data-dir="${LOCALAPPDATA:?}/Google/Chome/User\ Data/RemoteDebuggingProfile"

exit $?

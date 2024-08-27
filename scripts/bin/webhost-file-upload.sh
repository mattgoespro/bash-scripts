#!/bin/bash

function check_env() {
    if [ -z "$1" ]; then
        echo "error: environment value '$2' not set"
        exit 1
    fi
}

remote_host="$WEBHOST"
remote_port="$WEBHOST_USER"

check_env "$remote_host" "WEBHOST"
check_env "$remote_port" "WEBHOST_USER"

remote_path="$WEBHOST_PATH"

if [ -z "$remote_path" ]; then
    echo "warn: remote path is not set, using default: /usr/src"
    remote_path="/usr/src"
fi

remote_url="$remote_port@$remote_host:$remote_path"

local_path="$LOCAL_UPLOAD_PATH"

# Check if the upload path exists
if ! stat "$local_path"; then
    echo "error: local path does not exist: $local_path"
    exit 1
fi

if [ -d "$local_path" ]; then
    sftp -r "$remote_url" <<EOF
put "$local_path"
EOF
else
    sftp "$remote_url" <<EOF
put "$local_path"
EOF
fi

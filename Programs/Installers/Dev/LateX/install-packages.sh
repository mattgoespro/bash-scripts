#!/bin/bash

if ! command -v tlmgr.bat &>/dev/null; then
    echo -e "\nTeX package installer 'tlmgr.bat' not found on system."
    echo "If TeX installed, ensure 'tlmgr.bat' is in PATH."
    exit 1
fi

eval "tlmgr.bat update --all"
eval "tlmgr.bat install latexmk latexindent chktex enumitem psnfss texcount"

function Install-Chocolatey () {
    $InstallDir = 'C:\ProgramData\chocoportable'
    $env:ChocolateyInstall = "$InstallDir"

    # Allow execution of scripts
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-WinGet-Package ($package) {
    # Check if `winget` is installed
    if (-not (Get-Command winget -ErrorAction Stop)) {
        Write-Host 'Please install App Installer from the Microsoft Store to continue.'
        Pause
    }

    winget install $package
}

function Install-Volta-Package ($package) {
    # check if volta is installed
    if (-not (Get-Command volta -ErrorAction Stop)) {
        Write-Host -ForegroundColor Blue 'Installing Volta package manager...'
        winget install Volta.Volta
    }

    volta install $package
}

function Install-Choco-Package ($package) {
    # check if choco is installed
    if (-not (Get-Command choco -ErrorAction Stop)) {
        Write-Host -ForegroundColor Blue 'Installing Chocolatey package manager...'
        Install-Chocolatey
    }

    choco install $package -y
}

function Install-Python-Package ($package) {
    # check if pip is installed
    if (-not (Get-Command pip -ErrorAction Stop)) {
        # Install latest version of Python
        Write-Host -ForegroundColor Blue 'Installing Python ...'
        choco install python -y
    }

    pip install --upgrade pip
    pip install $package
}

function Install-Bun () {
    # check if deno is installed
    if (-not (Get-Command bun -ErrorAction Stop)) {
        Write-Host -ForegroundColor Blue 'Installing Bun runtime for Node.JS ...'
        powershell -c 'irm bun.sh/install.ps1 | iex'
    }
}


# Chocolatey
Install-Choco-Package 'python'

# Winget
Install-WinGet-Package 'ffmpeg'
Install-WinGet-Package 'shfmt'
Install-WinGet-Package 'shellcheck'

# Volta
Install-Volta-Package 'node'

# Python Pip
Install-Python-Package 'pylint'
Install-Python-Package 'black'

# Bun for Node.JS
Install-Bun

Write-Host -ForegroundColor Green 'All tools installed successfully.'
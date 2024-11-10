function installChocolatey () {
    $InstallDir = 'C:\ProgramData\chocoportable'
    $env:ChocolateyInstall = "$InstallDir"

    # Allow execution of scripts
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function installWithWinget ($package) {
    # Check if `winget` is installed
    if (-not (Get-Command winget -ErrorAction Stop)) {
        Write-Host 'Please install App Installer from the Microsoft Store to continue.'
        Pause
    }

    winget install $package
}

function installWithVolta ($package) {
    # check if volta is installed
    if (-not (Get-Command volta -ErrorAction Stop)) {
        Write-Host 'Installing required Volta package manager...'
        winget install Volta.Volta
    }

    volta install $package
}

function installWithChocolatey ($package) {
    # check if choco is installed
    if (-not (Get-Command choco -ErrorAction Stop)) {
        Write-Host 'Installing Chocolatey package manager...'
        installChocolatey
    }

    choco install $package -y
}

function installWithPip ($package) {
    # check if pip is installed
    if (-not (Get-Command pip -ErrorAction Stop)) {
        # Install latest version of Python
        choco install python -y
    }

    pip install --upgrade pip
    pip install $package
}

function installNodeBun () {
    # check if deno is installed
    if (-not (Get-Command bun -ErrorAction Stop)) {
        Write-Host 'Installing Bun runtime for Node.JS ...'
        powershell -c 'irm bun.sh/install.ps1 | iex'
    }
}


# Chocolatey
installWithChocolatey 'python'

# Winget
installWithWinget 'ffmpeg'
installWithWinget 'shfmt'
installWithWinget 'shellcheck'

# Volta
installWithVolta 'node'

# Python Pip
installWithPip 'pylint'
installWithPip 'black'

installNodeBun
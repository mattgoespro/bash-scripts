function installChocolatey () {
    # Set directory for installation - Chocolatey does not lock
    # down the directory if not the default
    $InstallDir = 'C:\ProgramData\chocoportable'
    $env:ChocolateyInstall = "$InstallDir"

    # If your PowerShell Execution policy is restrictive, you may
    # not be able to get around that. Try setting your session to
    # Bypass.
    Set-ExecutionPolicy Bypass -Scope Process -Force

    # All install options - offline, proxy, etc at
    # https://chocolatey.org/install
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function installWithWinget ($package) {
    # check if winget is installed
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host 'Please install App Installer from the Microsoft Store to continue.'
        exit 1
    }

    winget install $package
}

function installWithVolta ($package) {
    # check if volta is installed
    if (-not (Get-Command volta -ErrorAction SilentlyContinue)) {
        Write-Host 'Please install Volta from https://volta.sh to continue.'
        exit 1
    }

    volta install $package
}



installChocolatey

installWithWinget 'ffmpeg'
installWithWinget 'shfmt'
installWithVolta 'node'
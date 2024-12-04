function Install-Chocolatey () {
    $InstallDir = 'C:\ProgramData\chocoportable'
    $env:ChocolateyInstall = "$InstallDir"

    # Allow execution of scripts
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

function Install-WinGet-qBittorrent-Enhanced ($package) {
    # Check if `winget` is installed
    if (-not (Get-Command winget -ErrorAction Stop)) {
        Write-Host 'Please install App Installer from the Microsoft Store to continue.'
        Pause
    }

    winget install c0re100.qBittorrent-Enhanced-Edition -ErrorAction Error
}

Write-Host @'
========================================================================
           qBittorrent Enhanced Installation Script

    GitHub: https://github.com/c0re100/qBittorrent-Enhanced-Edition
========================================================================
'@

Write-Host 'Installing qBittorrent Enhanced...'
# Chocolatey
Install-WinGet-qBittorrent-Enhanced

Write-Host -ForegroundColor Green 'qBittorrent Enhanced installed successfully.'
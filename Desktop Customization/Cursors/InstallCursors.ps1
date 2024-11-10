# Ensure the script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'This script requires administrative privileges. Please run as administrator.'
    Pause
    exit 1
}

$scriptDir = $PSScriptRoot
$cursor_pack_dir = Join-Path -Path $scriptDir -ChildPath 'Archives'

if (-not (Test-Path $cursor_pack_dir)) {
    Write-Host "Installation directory does not exist: $cursor_pack_dir"
    Pause
    exit 1
}

try {
    $archives = Get-ChildItem -Path $cursor_pack_dir -Filter '*.zip' -ErrorAction Stop

    if ($archives.Count -eq 0) {
        Write-Host 'No cursor packs to install. Place the cursor packs in the `Archives` directory to install.'
        Pause
        exit 1
    }

    Write-Host "Found $($archives.Count) cursor packs to install:"
    $archives | ForEach-Object { Write-Host "  - $( $_.BaseName)" }

    # Read-Host -Prompt `n'Press [Enter] to install the cursor packs...'

    $tempDir = New-Item -ItemType Directory -Path "$env:TEMP\InstallCursors" -Force

    foreach ($archive in $archives) {
        Write-Host "Installing cursor pack '$($archive.Name)'..."

        # Extract the archive
        Expand-Archive -Path $archive.FullName -DestinationPath $tempDir.FullName -Force -ErrorAction Stop

        # Get the extracted directory
        $extractedDir = Get-ChildItem -Path $tempDir.FullName -Directory | Select-Object -First 1

        # Execute `install.inf`
        $infFile = Join-Path -Path $extractedDir.FullName -ChildPath 'install.inf'

        Write-Host "Found installation file: $($infFile.Name)"
        if (-not $infFile) {
            Write-Host "Installation file not found: $infFile"
            Write-Host "Create an installation file with the extension `.inf` then rerun this script."
            continue
        }

        # Use Start-Process to run the .inf file with the correct command
        # TODO: Fix
        Write-Host "Running installation file: $($infFile)"
        # RUNDLL32.EXE SETUPAPI.DLL, InstallHinfSection DefaultInstall 132 `"$infFile`"

        Write-Host "Successfully installed $($archive.Name)"
    }

    Remove-Item -Path $tempDir.FullName -Recurse -Force

    Write-Host `nInstallation complete.

    Read-Host -Prompt `n'Press [Enter] to exit...'
    exit 0
} catch {
    Write-Host "An error occurred: $_"
    Pause
    exit 1
}

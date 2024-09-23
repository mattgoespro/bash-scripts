# Ensure the script is run with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'This script requires administrative privileges. Please run as administrator.'
    Pause
    exit 1
}

# Extract the archives found in `Archives` directory relative to this script, then
# execute the `.inf` installation file to install the cursor pack.

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

    Write-Host "Found $($archives.Count) cursor packs to install."

    $tempDir = New-Item -ItemType Directory -Path "$env:TEMP\InstallCursors" -Force

    Write-Host "Created temporary directory $tempDir"

    Pause
    foreach ($archive in $archives) {
        Write-Host "Installing $($archive.Name)..."
        # Add the rest of your installation logic here

        # Extract the archive
        Expand-Archive -Path $archive.FullName -DestinationPath $tempDir.FullName -Force

        # Get the extracted directory
        $extractedDir = Get-ChildItem -Path $tempDir.FullName -Directory | Select-Object -First 1

        # Get the `.inf` file
        $infFile = Join-Path -Path $extractedDir.FullName -ChildPath '*.inf' | Get-Item

        if (-not $infFile) {
            Write-Host "Installation file not found: $infFile"
            Write-Host "Create an installation file with the extension `.inf` then rerun this script."
            continue
        }

        # Install the cursor pack
        Write-Host "Installing $($infFile.Name)..."
        Start-Process -FilePath 'cmd.exe' -ArgumentList "/c ${infFile.FullName}" -Wait -NoNewWindow

        Write-Host "Successfully installed $($archive.Name)"
    }

    Write-Host 'Cleaning up...'
    Remove-Item -Path $tempDir.FullName -Recurse -Force

    Write-Host 'Installation complete.'
    Read-Host -Prompt 'Press [Enter] to exit...'
    exit 0
} catch {
    Write-Host "An error occurred: $_"
    Pause
    exit 1
}

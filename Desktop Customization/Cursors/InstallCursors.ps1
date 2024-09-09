<#
 # Script to install fonts from an archive containing ZIPs of fonts for different font families.
 #>

# Admin rights are required to install fonts to the system
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'This script requires administrative privileges. Please run as administrator.'
    Pause
    exit
}

# Function to install fonts from a given directory
function Install-FontsFromDir {
    param (
        [string]$directory,
        [bool]$shouldInstall
    )
    Get-ChildItem -Path $directory -Filter *.ttf -Recurse | ForEach-Object {
        $destinationPath = "$env:SystemRoot\Fonts\$($_.Name)"

        if ($shouldInstall) {
            if ( -not (Test-Path -Path $destinationPath)) {
                Copy-Item -Path $_.FullName -Destination $destinationPath

                $fontRegPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
                $fontName = $_.BaseName

                try {
                    New-ItemProperty -Path $fontRegPath -Name "$fontName (TrueType)" -PropertyType String -Value $_.Name -Force
                    Write-Host "Installed font: $($_.Name)"
                    continue
                } catch {
                    Write-Host "Failed to register font: $fontName"
                    continue
                }
            }

            Write-Host "Font already exists: $($_.Name)"
        }

        if (!($shouldInstall)) {
            try {
                if (Test-Path -Path $destinationPath) {
                    Remove-Item -Path $destinationPath -Force
                    Write-Output "Removed font file: $($_.Name)"
                }

                # remove registry entry if it exists
                if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts\$($_.BaseName) (TrueType)") {
                    Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name "$($_.BaseName) (TrueType)" -Force
                    Write-Output "Removed font registry entry: $($_.BaseName)"
                }

                Write-Output "Uninstalled font: $($_.Name)"
            } catch {
                Write-Host "Failed to uninstall font: $($_.Name)"
            }
        }
    }
}

function Main {
    try {
        # Temporary extraction directory
        $tempDir = "$env:TEMP\Fonts"
        Write-Host "Creating temporary directory: $tempDir"
        New-Item -ItemType Directory -Path $tempDir -Force

        $fontsZipPath = $args[0]

        if (-not $fontsZipPath) {
            $fontsZipPath = Read-Host 'Enter the path to the font ZIP archive...'
        }

        if (-not (Test-Path -Path $fontsZipPath)) {
            Write-Host "The specified zip file does not exist at path: $fontsZipPath."
            Pause
            exit 1
        }

        # Extract Fonts.zip to the temporary directory
        Write-Host "Extracting fonts from: $fontsZipPath to $tempDir"
        Expand-Archive -Path $fontsZipPath -DestinationPath $tempDir -Force

        $installPrompt = Read-Host 'Font installer. Uninstall/Install fonts? (U/I)'
        Write-Output "Prompt: $installPrompt"
        $shouldInstallFonts = $false

        if ( $installPrompt -eq '' -or $installPrompt -eq 'I' -or $installPrompt -eq 'i') {
            $shouldInstallFonts = $true
            Write-Output 'Installing fonts...'
        }

        # Iterate through each ZF (zip files) in the temporary directory
        Get-ChildItem -Path $tempDir -Filter *.zip | ForEach-Object {
            $zfPath = $_.FullName
            $zfExtractDir = "$tempDir\$($_.BaseName)"
            Write-Host "Processing zip file: $zfPath"

            if ($shouldInstallFonts) {
                # Extract ZF
                Write-Host "Extracting zip file: $zfPath to $zfExtractDir"
                Expand-Archive -Path $zfPath -DestinationPath $zfExtractDir -Force
            }

            # Install fonts from the root of ZF
            Install-FontsFromDir -directory $zfExtractDir  -shouldInstall:$shouldInstallFonts

            # Check and install fonts from the static directory if it exists
            $staticDir = "$zfExtractDir\static"
            if (Test-Path -Path $staticDir) {
                Install-FontsFromDir -directory $staticDir   -shouldInstall:$shouldInstallFonts
            }

            # Clean up extracted ZF directory
            Write-Host "Cleaning up extracted directory: $zfExtractDir"
            Remove-Item -Path $zfExtractDir -Recurse -Force
        }

        # Clean up the temporary directory
        Write-Host "Cleaning up temporary directory: $tempDir"
        Remove-Item -Path $tempDir -Recurse -Force
    } catch {
        Write-Host "An error occurred: $_"
    } finally {
        Pause
    }
}

Main
exit 0
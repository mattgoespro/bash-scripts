# Prompt 'Enter' to continue
$continue = Read-Host 'Press Enter to download and install Flutter, or Ctrl+C to cancel.'

# Check if the user cancelled
if ([string]::IsNullOrWhiteSpace($continue)) {
    Write-Host 'Downloading and installing Flutter...'
} else {
    Write-Host 'Cancelled.'
    exit
}

function Get-FlutterArchiveDownloadUrl {
    # Define the URLs and paths
    $flutterReleasesEndpoint = 'https://storage.googleapis.com/flutter_infra_release/releases/releases_windows.json'
    $defaultExtractPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Programs')

    # Fetch the list of releases
    $flutterReleases = Invoke-RestMethod -Uri $flutterReleasesEndpoint

    # Locate the URL to the archive for the latest stable release
    $baseUrl = $flutterReleases.base_url
    $latestStableRelease = $flutterReleases.releases | Where-Object { $_.hash -eq $flutterReleases.current_release.stable }

    # Check that flutter is not already installed
    $flutterPath = [System.IO.Path]::Combine($defaultExtractPath, 'flutter')

    if (Test-Path -Path $flutterPath) {
        Write-Host 'Flutter is already installed.'
        exit
    }

    $archivePath = $latestStableRelease.archive

    return "$baseUrl/$archivePath"
}

$flutterArchiveDownloadUrl = Get-FlutterArchiveDownloadUrl
$flutterArchiveDownloadDest = [System.IO.Path]::Combine([System.IO.Path]::Combine([Environment]::GetFolderPath('UserProfile'), 'Downloads'), [System.IO.Path]::GetFileName($archivePath))

# Download the archive from remote URL
$flutterDownloadArchiveExists = Test-Path -Path $flutterArchiveDownloadDest
$shouldDownload = $true

<#
    Check if the file should be downloaded based on the following conditions:
    1. The archive does not exist locally
    2. The existing archive is incomplete
    3. The existing archive is outdated
#>
if ($flutterDownloadArchiveExists) {
    $existingFileSize = (Get-Item $flutterArchiveDownloadDest).length
    $webRequest = Invoke-WebRequest -Uri $flutterArchiveDownloadUrl -Method Head
    $remoteFileSize = [int64]$webRequest.Headers['Content-Length'][0]

    # Download the archive if the existing file is incomplete or outdated
    if ($existingFileSize -lt $remoteFileSize) {
        Write-Host 'Existing Flutter archive is incomplete. Removing and downloading again.'
        Remove-Item -Path $flutterArchiveDownloadDest
    } elseif ($existingFileSize -eq $remoteFileSize) {
        Write-Host 'Existing Flutter archive is up-to-date. Skipping download.'
        $shouldDownload = $false
    }
}

# Perform the download if necessary
if ($shouldDownload) {
    Write-Host 'Downloading Flutter archive...'
    $httpClient = New-Object System.Net.Http.HttpClient
    $response = $httpClient.GetAsync($flutterArchiveDownloadUrl, [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
    $response.EnsureSuccessStatusCode()

    $totalBytes = $response.Content.Headers.ContentLength
    $stream = $response.Content.ReadAsStreamAsync().Result
    $fileStream = [System.IO.File]::Create($flutterArchiveDownloadDest)
    $buffer = New-Object byte[] 8192
    $totalRead = 0
    $bytesRead = 0

    while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $fileStream.Write($buffer, 0, $bytesRead)
        $totalRead += $bytesRead
        $progress = [math]::Round(($totalRead / $totalBytes) * 100, 2)
        Write-Progress -Activity 'Downloading Flutter' -Status "$progress% Complete" -PercentComplete $progress
    }

    $fileStream.Close()
    $stream.Close()
}

# Extract and install the Flutter archive
$extractPath = Read-Host -Prompt "Enter directory to extract the Flutter archive to (default is $defaultExtractPath)"
if ([string]::IsNullOrWhiteSpace($extractPath)) {
    $extractPath = $defaultExtractPath
}

if (-Not (Test-Path -Path $extractPath)) {
    New-Item -ItemType Directory -Path $extractPath | Out-Null
}

# Step 5: Extract the archive with a progress bar using Expand-Archive
Write-Host "Extracting Flutter archive to $extractPath..."
Expand-Archive -Path $flutterArchiveDownloadDest -DestinationPath $extractPath -Force -Verbose -ErrorAction Stop

Write-Host "Flutter has been successfully downloaded and extracted to $extractPath."

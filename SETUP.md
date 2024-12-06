# Windows 10 Desktop Setup

## Visual Studio Code

## Setting NPM script integrated terminal

In orderto execute the scripts defined in the _npm scripts_ side panel view, set the default _npm_ terminal: `npm config set script-shell <terminal_executable_path>`

Example shell Executables:

- **Bash for Windows**:_C:\Program Files\git\bin\bash.exe_
- **Windows Subsystem for Linux**: _C:\Windows\System32\bash.exe_

### Configuring _bash_ as the default project terminal profile

Sometimes, terminal-specific environment values aren't being set as expected within the default profile settings, due to environment conflicts when Visual Studio Code opens the terminal.

To fix this, specific configuration in the `settings.json` in the **profile** settings for specific variables need to be set. Let's extend the **_PATH_**:

Unset the **_PATH_** environment value inherited by all terminal profiles:

```bash
  "terminal.integrated.env.windows": {
    "PATH": null
  }
```

Next, extend the **_PATH_** value in the new default terminal profile:

```bash
  "terminal.integrated.profiles.windows": {
    "bash-node": {
      "path": "C:\\Program Files\\Git\\bin\\bash.exe",
      ...
      "env": {
        "PATH": "${workspaceFolder}\\node_modules\\.bin"
      }
    }
  }
```

If a custom _**bashrc**_ file `$HOME\\.bashrc` exists:

- Ensure that the **PATH** is being exported: `export PATH="$PATH"`

### Fixing Visual Studio Code editor corruption

If the editor has been corrupted or has other issues that can't be solved otherwise, clearing the cache may help.

To clear the cache, run the following command to delete the cache folders:

```bash
rm -rf "$APPDATA\\Code\\Cache" && \
rm -rf "$APPDATA\\Code\\CachedData" && \
rm -rf "$APPDATA\\Code\\CachedExtensions" && \
rm -rf "$APPDATA\\Code\\CachedExtensionsVSIXs" && \
rm -rf "$APPDATA\\Code\\Code Cache"
```

## Enabling Windows Subsystem for Linux (WSL)

- In _Start Menu_, type `Turn Windows features on or off`
- Toggle the `Windows Subsystem for Linux` checkbox.
- **Reboot**
- Install _Ubuntu_ (default) from _Powershell_: `wsl --install` to
- Ensure the _Ubuntu_ is using _WSL2_: `wsl -l -v`
  - If not, configure the distribution to use WSL2 using `wsl --set-version Ubuntu 2`

## Setting up Docker Desktop

- Download [Docker Desktop](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe).
- Run the installer
- Select _Use WSL 2 instead of Hyper-V_ when configuring the installation

## Turning on Developer Mode

Developer Mode is required to install Volta binaries through the command line.

To enable developer mode:

- Open _Settings -> Update and security -> For developers_
- Enable the _Developer mode_ toggle button

## Running Powershell Scripts

To enable running scripts in Powershell:

- Open _Powershell_ as Administrator
- Execute command: `Set-ExecutionPolicy unrestricted`

## Windows Desktop Optimizations

### Increasing the Virtual Memory Paging Size

- In _Start Menu_, type `View advanced system settings`
- Navigate to the _Advanced_ tab
- Under the **_Performance_** card, click _Settings_
- Navigate to the _Advanced_ tab
- Under the **_Virtual memory_** card, click _Change_
- Uncheck _Automatically manage paging file size for all drives_
  - For each mounted drive:
    - Select the **_Custom size_** checkbox
    - Enter the new size for **Initial size (MB)** and **Maximum size (MB)**
    - Click **Set**
      - Note: it's probably best to use the closest size (mb), a multiple of 2, which is nearest in size to the **_Recommended_** size in the _**Total page file sizes for all drives**_ card at the bottom of the dialog
      - Example: if **`Recommended`**_=2949mb_, then use size _4096_
    - Click **OK**
  - Click **Apply**
  - Restart the computer for the changes to take effect.

## Trusted Torrents

- [[PreActivated] Windows 10 Pro x64 v1511, July 2016](https://1337x.to/torrent/1663604/Windows-10-Pro-v-1511-En-us-x64-July2016-Pre-Activated-TEAM-OS) _(1337x.to)_

## Windows Help

**Cannot uninstall program from Control Panel:** [Fix problems that block programs from being installed or removed](https://support.microsoft.com/en-us/topic/fix-problems-that-block-programs-from-being-installed-or-removed-cca7d1b6-65a9-3d98-426b-e9f927e1eb4d)

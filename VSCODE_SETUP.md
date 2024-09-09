# Setting up Visual Studio Code

## Setting NPM script integrated terminal

Set the terminal that NPM scripts execute on when started from the VSCode's `npm scripts` sidepanel window:

- `npm config set script-shell <terminal_executable_path>`

Example shell executables

- **Bash for Windows**
  - `npm config set script-shell "C:\Program Files\git\bin\bash.exe"`
- **Windows Subsystem for Linux**
  - `npm config set script-shell "C:\Windows\System32\bash.exe`

## Clearing VSCode cache

To clear the VSCode cache in case of corruption, delete the following folders:

- _%USERPROFILE%\\AppData\\Roaming\\Code\\Cache_
- _%USERPROFILE%\\AppData\\Roaming\\Code\\CachedData_
- _%USERPROFILE%\\AppData\\Roaming\\Code\\CachedExtensions_
- _%USERPROFILE%\\AppData\\Roaming\\Code\\CachedExtensionVSIXs_
- _%USERPROFILE%\\AppData\\Roaming\\Code\\Code Cache_

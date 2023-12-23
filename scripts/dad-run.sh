#!/bin/sh
set -e

winebin="/app/opt/wine/bin"
wineprefix="$XDG_DATA_HOME"/prefix
blacksmith_path="$wineprefix/drive_c/Program Files/IRONMACE/Blacksmith"
blacksmith_launcher_exe_path="$blacksmith_path/BlacksmithBootstrap.exe"
blacksmith_launcher_installer_url="https://webdown.darkanddarker.com/Blacksmith%20Installer.exe"

if [ ! -f "$XDG_DATA_HOME"/BLACKSMITH ] || [ $(cat "$XDG_DATA_HOME"/BLACKSMITH) != $(cat /app/BLACKSMITH) ]; then
    echo "DIGESTS DO NOT MATCH. UPDATING $(cat "$XDG_DATA_HOME"/BLACKSMITH) -> $(cat /app/BLACKSMITH)"
    cp /app/BLACKSMITH "$XDG_DATA_HOME"/BLACKSMITH # This digest is used to tell if an update is needed.
    WINEDEBUG="-all" WINEPREFIX="$wineprefix" "$winebin/wineboot" -u
    
    # Move installation files into wineprefix
    cp -r /app/extra/IRONMACE "$wineprefix/drive_c/Program Files/IRONMACE"

    # Make sure dxvk is in place in our prefix
    cp -r /app/opt/dxvk/x64/*.dll "$wineprefix/drive_c/windows/system32/"
    cp -r /app/opt/dxvk/x32/*.dll "$wineprefix/drive_c/windows/syswow64/"
    WINEDEBUG="-all" WINEPREFIX="$wineprefix" winetricks --unattended wininet urlmon
    WINEDEBUG="-all" WINEPREFIX="$wineprefix" wineserver -k

    WINEPREFIX="$wineprefix" "$winebin/wine" "$blacksmith_path"/VC_redist.x64.exe /silent
fi

# Run with overrides for dxvk
WINEPREFIX="$wineprefix" WINEDLLOVERRIDES="d3d11=n;d3d10core=n;dxgi=n;d3d9=n" "$winebin/wine" "$blacksmith_launcher_exe_path"
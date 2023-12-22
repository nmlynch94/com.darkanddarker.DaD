#!/bin/sh
# set -e

winebin="/app/opt/wine/bin"
wineprefix="$XDG_DATA_HOME"/prefix
blacksmith_launcher_exe_path="/app/extra/IRONMACE/Blacksmith/BlacksmithBootstrap.exe"
blacksmith_launcher_installer_url="https://webdown.darkanddarker.com/Blacksmith%20Installer.exe"

if ! [ -f "$wineprefix" ]; then
    WINEDEBUG="-all" WINEPREFIX="$wineprefix" "$winebin/wineboot" -u
    # Make sure dxvk is in place in our prefix
    cp -r /app/opt/dxvk/x64/*.dll "$wineprefix/drive_c/windows/system32/"
    cp -r /app/opt/dxvk/x32/*.dll "$wineprefix/drive_c/windows/syswow64/"
    WINEDEBUG="-all" WINEPREFIX="$wineprefix" winetricks --unattended wininet urlmon
    WINEDEBUG="-all" WINEPREFIX="$wineprefix" wineserver -k

    WINEPREFIX="$wineprefix" "$winebin/wine" /app/vc_redist.x86.exe
    WINEPREFIX="$wineprefix" "$winebin/wine" /app/vc_redist.x64.exe
fi

# Run with overrides for dxvk
WINEPREFIX="$wineprefix" DXVK_HUD=1 WINEDLLOVERRIDES="d3d11=n;d3d10core=n;dxgi=n;d3d9=n" "$winebin/wine" "$blacksmith_launcher_exe_path"
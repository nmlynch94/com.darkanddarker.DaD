#!/bin/sh
set -e
set -x

winebin="/app/opt/wine/bin"
wineprefix="$XDG_DATA_HOME"/prefix
blacksmith_launcher_exe_path="$wineprefix/drive_c/Program Files/IRONMACE/Blacksmith/BlacksmithBootstrap.exe"

if ! [ -f "$blacksmith_launcher_exe_path" ]; then
    WINEPREFIX="$wineprefix" "$winebin/wineboot"
    WINEPREFIX="$wineprefix" winetricks wininet urlmon
    WINEPREFIX="$wineprefix" wineserver -k
    WINEPREFIX="$wineprefix" "$winebin/wine" /app/BlacksmithInstaller.exe
fi  

# Make sure the registry has the installation location for runelite.
WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine" reg.exe add "HKEY_CURRENT_USER\Software\Wine\AppDefaults\DungeonCrawler.exe\DllOverrides" /v "urlmon" /t REG_SZ /d "builtin" /f

# Make sure the registry has the installation location for hdos
WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine" reg.exe add "HKEY_CURRENT_USER\Software\Wine\AppDefaults\DungeonCrawler.exe\DllOverrides" /v "wininet" /t REG_SZ /d "builtin" /f

# Make sure dxvk is in place in our prefix
cp -r /app/opt/dxvk/x64/*.dll "$wineprefix/drive_c/windows/system32/"
cp -r /app/opt/dxvk/x32/*.dll "$wineprefix/drive_c/windows/syswow64/"

# Run with overrides for dxvk
WINEPREFIX="$wineprefix" DXVK_HUD=1 WINEDLLOVERRIDES="d3d11=n;d3d10core=n;dxgi=n;d3d9=n" "$winebin/wine" "$blacksmith_launcher_exe_path"
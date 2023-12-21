#!/bin/sh
# set -e

winebin="/app/opt/wine/bin"
wineprefix="$XDG_DATA_HOME"/prefix
blacksmith_launcher_exe_path="/app/extra/IRONMACE/Blacksmith/BlacksmithBootstrap.exe"
blacksmith_launcher_installer_url="https://webdown.darkanddarker.com/Blacksmith%20Installer.exe"

if ! [ -f "$blacksmith_launcher_exe_path" ]; then
    WINEDEBUG="-all" WINEPREFIX="$wineprefix" "$winebin/wineboot" -u
    # Make sure dxvk is in place in our prefix
    cp -r /app/opt/dxvk/x64/*.dll "$wineprefix/drive_c/windows/system32/"
    cp -r /app/opt/dxvk/x32/*.dll "$wineprefix/drive_c/windows/syswow64/"
    # WINEDEBUG="-all" WINEPREFIX="$wineprefix" winetricks --unattended wininet urlmon
    # WINEDEBUG="-all" WINEPREFIX="$wineprefix" wineserver -k

    WINEPREFIX="$wineprefix" DXVK_HUD=1 WINEDLLOVERRIDES="d3d11=n;d3d10core=n;dxgi=n;d3d9=n" "$winebin/wine" "$blacksmith_launcher_exe_path"
    # mkdir sources
    # mv /app/sources/blacksmith_sources.json
    # mv /app/sources/cpprest_sources.json

    # mv /app/sources/blacksmith_sources.json
    # mv /app/sources/blacksmith_sources.json

    # /app/dad-install "$wineprefix/drive_c/Program Files/IRONMACE/"
    
    # # Make sure the registry has the installation location for runelite.
    # WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine" reg.exe add "HKEY_CURRENT_USER\Software\Wine\AppDefaults\DungeonCrawler.exe\DllOverrides" /v "urlmon" /t REG_SZ /d "builtin" /f

    # # Make sure the registry has the installation location for hdos
    # WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine" reg.exe add "HKEY_CURRENT_USER\Software\Wine\AppDefaults\DungeonCrawler.exe\DllOverrides" /v "wininet" /t REG_SZ /d "builtin" /f
        
    # WINEPREFIX="$wineprefix" "$winebin/wine" /app/vc_redist.x86.exe
    # WINEPREFIX="$wineprefix" "$winebin/wine" /app/vc_redist.x64.exe
fi

WINEPREFIX="$wineprefix" WINEDEBUG="-all" "$winebin/wine" regedit "$XDG_DATA_HOME"/out.reg
# Make sure dxvk is in place in our prefix
cp -r /app/opt/dxvk/x64/*.dll "$wineprefix/drive_c/windows/system32/"
cp -r /app/opt/dxvk/x32/*.dll "$wineprefix/drive_c/windows/syswow64/"

# Run with overrides for dxvk
WINEPREFIX="$wineprefix" DXVK_HUD=1 WINEDLLOVERRIDES="d3d11=n;d3d10core=n;dxgi=n;d3d9=n" "$winebin/wine" "$blacksmith_launcher_exe_path"
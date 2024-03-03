#!/bin/sh
curl -L https://github.com/nmlynch94/com.darkanddarker.DaD/releases/latest/download/com.darkanddarker.DaD.flatpak > com.darkanddarker.DaD.flatpak
echo "Installing......"
flatpak install -y --user --noninteractive com.darkanddarker.DaD.flatpak && flatpak run com.darkanddarker.DaD
echo "DONE"

# Disclaimer
I am in no way affiliated with IRONMACE and running the launcher through linux is unsupported by them. Any issues should be reported here as tickets. Use at your own risk.

# What is it?
Dark and Darker - in a flatpak!

# Installation Methods. Choose one. (This is not available on Flathub due to them not allowing Wine applications)
### Release Bundle (easiest)
- Here is a one liner to make sure all dependencies are installed and also install the latest release. This will likely take several minutes if flatpak is newly installed NOTE: The first launch will take a long time and appear to be doing nothing. Winetricks is installing dependencies and it's installing the dependencies from the blacksmith installer exe.
- Known Issues (these are all generic wine + blacksmith issues, not unique to this flatpak):
  - Closing the launcher only works if you right click -> exit on the task bar, and then wait several seconds. Clicking the 'x' freezes the client. Even this sometimes does not work and will have to be killed. Launching from steam will help this because then clicking "stop" in steam will kill all processes.
    - This can be worked around by adding it as a non-steam shortcut.
    - In steam, choose "Games" -> "Add Non-steam shortcut"
    - Choose any program and choose Add, just to create an entry
    - Right click on the new entry -> Properties
    - Set Set target = "/usr/bin/flatpak", Launch Options = "run com.darkanddarker.DaD", "start in" should be empty.
    - Also feel free to edit the name of the shortcut
  - During installation after the launcher is open, the installer never finishes when the progress bar is full. Once it's full, closing and reopening resolves this.
  - Minimize the blacksmith launcher after game launch, or your clicks will bleed through the client when you try to swing.
  - You may need to alt tab out and in once after launch for clicks to register.
  - Credentials don't save on login, so you need to enter username and password every launch.
  - Update doesn't always work. In these cases, I click the cog -> scan and repair -> close after the progress bar fills and open again.
```
curl -fSsL https://raw.githubusercontent.com/nmlynch94/com.darkanddarker.DaD/main/install-dad-launcher.sh | bash
```
For the first run, winetricks dependencies will need to install. I recommend running via the cli one time in order to make sure nothing is frozen. You can launch from the application menu going forward.
```
flatpak run com.darkanddarker.DaD
```
### Build and Install Locally

1. Only use this next command if it has already been installed and you want to run from scratch. This will wipe out all saved settings.
```
flatpak remove --delete-data com.darkanddarker.DaD
```

2. Use these to build and run - you will need to install flatpak-builder from your package manager.
```
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak-builder --install-deps-from=flathub --user --install --force-clean build-dir --disable-cache com.darkanddarker.DaD.yml
flatpak install --user flathub org.gnome.Platform.Compat.i386//45
```
4. NOTE: The additional flatpak install command above is to make sure Compat.i386 is installed due to https://github.com/flathub/net.lutris.Lutris/issues/53
5. Now, you can run the launcher from your application menu

### If you have a steam deck (NOTE: This only works in desktop mode right now)
- Follow one of the methods above, then simply right click on the icon in the Application Menu and choose to create a steam shortcut. Then, you will be able to launch it in Game Mode.
- You may want to rename your shortcut to DarkandDarker because the way the deck searches community control schemes is by matching your game's name.
- I recommend the release bundle method especially, because the flatpak-builder method will require you to disable your Read Only partition in order to install flatpak-builder https://steamdecki.org/SteamOS/Read-only_Filesystem. I don't recommend doing this unless you are familiar enough with Linux to know you can ignore this warning.
- For RuneLite users, there is a steamdeck-config.properties file placed in the data directory (usually in /var or ~/.var depening on if it's a user or system install). It will show in your file browser if you look for a folder called "data".

### Updates
To update, you can simply follow one of the above installation instructions on the latest code/release. Most updates will be self-updates from the launcher. Choose repair when you are presented the C++ installation prompt.

### Future Improvements
- Resolve the known issues (Contributions Welcome).
- Game mode support on steam deck. Right now, the login page shows but the launcher transition does not work after login.
- Use github pages to distribute via a flatmanager repo instead of using a single-file bundle.

#!/bin/bash
BASE_URL="http://cdn.darkanddarker.com/launcher"
FILE_LIST_URL="$BASE_URL/launcherinfo.json"
BLACKSMITH_BOOTSTRAP_EXE_NAME="BlacksmithBootstrap.exe"
BLACKSMITH_BOOTSTRAP_DIGEST="$(curl -fSsL http://cdn.darkanddarker.com/launcher/launcherinfo.json | jq -r --arg BLACKSMITH_BOOTSTRAP_EXE "$BLACKSMITH_BOOTSTRAP_EXE" '.files[] | select(.name=="$BLACKSMITH_BOOTSTRAP_EXE_NAME") | .hash')"

curl -L "$BASE_URL/$BLACKSMITH_BOOTSTRAP_EXE_NAME" > "$BLACKSMITH_BOOTSTRAP_EXE_NAME"

wrestool -x --output=icon.ico -t14 "$BLACKSMITH_BOOTSTRAP_EXE_NAME"
convert icon.ico 512.png
mkdir -p 512
mv 512.png 512/512.png

# Cleanup
rm -f "icon.ico"
rm -f "$BLACKSMITH_BOOTSTRAP_EXE"
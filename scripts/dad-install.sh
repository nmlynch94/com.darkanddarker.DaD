#!/bin/sh
set -e

CPPREST_SKIP=67816596
CPPREST_BYTES=965632
BASE_LAUNCHER_URL="http://cdn.darkanddarker.com/launcher"
BASE_DAD_URL="http://cdn.darkanddarker.com/Dark%20and%20Darker"
if [ -z "$1" ]; then
    PREFIX="$(pwd)/IRONMACE/"
else
    PREFIX="$1"
fi
BLACKSMITH="$PREFIX"Blacksmith/
DARK_AND_DARKER="$PREFIX""Dark and Darker/"

# Logging functions
function log_output {
  echo `date "+%Y/%m/%d %H:%M:%S"`" $1"
  echo `date "+%Y/%m/%d %H:%M:%S"`" $1" >> $LOGFILE
}

function log_debug {
  if [[ "$LOGLEVEL" =~ ^(DEBUG)$ ]]; then
    log_output "DEBUG $1"
  fi
}

function log_info {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO)$ ]]; then
    log_output "INFO $1"
  fi
}

function log_warn {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO|WARN)$ ]]; then
    log_output "WARN $1"
  fi
}

function log_error {
  if [[ "$LOGLEVEL" =~ ^(DEBUG|INFO|WARN|ERROR)$ ]]; then
    log_output "ERROR $1"
  fi
}

function install_blacksmith() {
    json="$(curl -fSsL $BASE_LAUNCHER_URL/launcherinfo.json | jq)"
    mkdir -p "$BLACKSMITH"
    echo "$json" | jq '.files[].dir' | xargs -I '{}' mkdir -p $BLACKSMITH'{}'

    echo "$json" | jq -r '.files[] | ("/" + .dir + "/" + .name)' | sed 's|//|/|g' | xargs -I '{}' wget "$BASE_LAUNCHER_URL{}" -O "$BLACKSMITH{}"

    curl -fSs -L https://webdown.darkanddarker.com/Blacksmith%20Installer.exe > "$BLACKSMITH"bsi.exe

    dd bs=1 skip=$CPPREST_SKIP count=$CPPREST_BYTES if="$BLACKSMITH"bsi.exe of="$BLACKSMITH"cpprest_2_10.dll

    rm "$BLACKSMITH"bsi.exe
}

function install_dungeon_crawler() {
    file_list="$(curl -fSsL $BASE_DAD_URL/PatchFileList.txt)"
    mkdir -p "$DARK_AND_DARKER"
    
    file_list=$(echo "$file_list" | awk -F',' '{printf("{\"path\":\"%s\",\"digest\":\"%s\"},", $1, $2)}' | sed 's|\\|/|g')
    file_list_json=$(echo "[$file_list]" | sed 's|,]$|]|g')
    echo "$file_list_json" | jq -c '.[]' | while read i; do
        digest=$(echo "$i" | jq -r '.digest')
        path=$(echo "$i" | jq -r '.path' | sed 's|^/||g')
        mkdir -p "$(dirname "$DARK_AND_DARKER$path")" || echo "File already exists"
	      curl -fSs -L "$BASE_DAD_URL/Patch/$path" > "$DARK_AND_DARKER""$path"
        
        actual_digest=$(sha256sum "$DARK_AND_DARKER""$path" | awk -F' ' '{print $1}')
        log_info "Expecting $DARK_AND_DARKER$path to have a digest of $digest and it was $actual_digest"
        if [ "$digest" != "$actual_digest" ]; then
            log_error "Digest didn't match! Exiting"
            exit 1
        fi
    done
}

install_blacksmith
install_dungeon_crawler

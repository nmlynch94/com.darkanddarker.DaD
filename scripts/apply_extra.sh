CPPREST_SKIP=67816596
CPPREST_BYTES=965632

for f in *; do
  cat /app/blacksmith_sources.yaml | grep -i "/$f" | awk -F':' '{ print $2}' | tail -n 1
  file_dest="$(cat /app/blacksmith_sources.yaml | grep -i "/$f" | awk -F': ' '{ print $2 }' | tail -n 1)"
  mkdir -p "$(dirname "$file_dest")"
  mv "$f" "$file_dest"
done

dd bs=1 skip=$CPPREST_SKIP count=$CPPREST_BYTES if="$(pwd)"/bsi.exe of="IRONMACE/Blacksmith/cpprest_2_10.dll"
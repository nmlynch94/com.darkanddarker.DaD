CPPREST_SKIP=68510356 
CPPREST_BYTES=965632

for f in *; do
  file_dest="$(cat /app/blacksmith_sources.yaml | grep -i "dest:.*$f" | awk -F': ' '{ print $2 }')"
  mkdir -p "$(dirname "$file_dest")"
  mv "$f" "$file_dest"
done

dd bs=1 skip=$CPPREST_SKIP count=$CPPREST_BYTES if="$(pwd)"/bsi.exe of="IRONMACE/Blacksmith/cpprest_2_10.dll"
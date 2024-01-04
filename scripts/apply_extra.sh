set -e

for f in *; do
  file_dest="$(cat /app/blacksmith_sources.yaml | grep -i "dest:.*$f" | awk -F': ' '{ print $2 }')"
  mkdir -p "$(dirname "$file_dest")"
  mv "$f" "$file_dest" || echo "$f"" had no destination"
done

files="$(python ./pecheck.py -l P bsi.exe)"

cpprest_dll_file_name="$(echo "$files" | grep -i "cpprest" | awk -F"'" '{ print $4 }')"
vcredist_dll_file_name="$(echo "$files" | grep -i "VC_redist" | awk -F"'" '{ print $2 }')"

start_bytes_cpprest="$(echo "$files" | grep -i "cpprest" | awk '{ print $2}')"
end_bytes_cpprest="$(echo "$files" | grep -i "cpprest" | awk '{ print $5}')"

dd if=bsi.exe of="$cpprest_dll_file_name" bs=1 skip=$(($start_bytes_cpprest)) count=$(($end_bytes_cpprest - $start_bytes_cpprest)) status=progress
mv "$cpprest_dll_file_name" IRONMACE/Blacksmith/"$cpprest_dll_file_name"

start_bytes_vcredist="$(echo "$files" | grep -i "$vcredist_dll_file_name" | awk '{ print $2}')"
end_bytes_vcredist="$(echo "$files" | grep -i "$vcredist_dll_file_name" | awk '{ print $5}')"

dd if=bsi.exe of="$vcredist_dll_file_name" bs=1 skip=$(($start_bytes_vcredist)) count=$(($end_bytes_vcredist - $start_bytes_vcredist)) status=progress
mv "$vcredist_dll_file_name" IRONMACE/Blacksmith/"$vcredist_dll_file_name"

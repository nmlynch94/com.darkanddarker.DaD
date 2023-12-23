set -e

for f in *; do
  file_dest="$(cat /app/blacksmith_sources.yaml | grep -i "dest:.*$f" | awk -F': ' '{ print $2 }')"
  mkdir -p "$(dirname "$file_dest")"
  mv "$f" "$file_dest" || echo "$f"" had no destination"
done

files="$(python ./pecheck.py -l P bsi.exe)"

start_bytes_cpprest="$(echo "$files" | grep -i "cpprest" | awk '{ print $2}')"
end_bytes_cpprest="$(echo "$files" | grep -i "cpprest" | awk '{ print $5}')"

dd if=bsi.exe of=cpprest_2_10.dll bs=1 skip=$(($start_bytes_cpprest)) count=$(($end_bytes_cpprest - $start_bytes_cpprest))
mv cpprest_2_10.dll IRONMACE/Blacksmith/cpprest_2_10.dll

start_bytes_vcredist="$(echo "$files" | grep -i "VC_redist.x64.exe" | awk '{ print $2}')"
end_bytes_vcredist="$(echo "$files" | grep -i "VC_redist.x64.exe" | awk '{ print $5}')"

dd if=bsi.exe of=VC_redist.x64.exe bs=1 skip=$(($start_bytes_vcredist)) count=$(($end_bytes_vcredist - $start_bytes_vcredist))
mv VC_redist.x64.exe IRONMACE/Blacksmith/VC_redist.x64.exe
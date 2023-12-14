from urllib.request import urlopen, Request
import yaml
import os
from pathlib import Path

base_url = "http://cdn.darkanddarker.com/Dark%20and%20Darker"
patch_list = "{}/PatchFileList.txt".format(base_url)
patch_url_template = "{}/Patch{}"

def http_get(url):
    if not url.startswith("https"):
        print ("WARNING: not https")
        # raise Exception("Only HTTPS is supported.")
    with urlopen(Request(url)) as response:
        return {
            "status_code": response.status,
            "content": response.read()
        }

def fetch_patchfile():
	response = http_get(patch_list)
	if response["status_code"] == 200:
		return response["content"]
	else:
		raise Exception(f"Failed to fetch patch file")
      
def main():
    source_data = []
    patch_file = fetch_patchfile().decode('UTF-8')
    for line in patch_file.splitlines():
        line_info = line.split(",")

        file_path = line_info[0].replace("\\", "/")
        digest = line_info[1]

        source = {}
        source["type"] = "file"
        source["dest"] = "/app/IRONMACE{}".format(file_path)
        source["sha256"] = digest
        source["url"] = patch_url_template.format(base_url, file_path)
        
        x_checker_data = {}
        x_checker_data["type"] = "html"
        x_checker_data["url"] = patch_url_template.format(base_url, file_path)
        x_checker_data["pattern"] = patch_url_template.format(base_url, file_path)

        source["x-checker-data"] = x_checker_data
        source_data.append(source)

    with open('dnd-sources.yaml', 'w') as file:
        yaml.dump(source_data, file, sort_keys=False)
main()
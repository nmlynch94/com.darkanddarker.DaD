import logging
import requests
import urllib.request
import yaml
import json
from urllib.parse import quote
import hashlib
import os

# create logger
logger = logging.getLogger('simple_example')
logger.setLevel(logging.DEBUG)

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# create formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

# add formatter to ch
ch.setFormatter(formatter)

# add ch to logger
logger.addHandler(ch)

# 'application' code
logger.info('info message')

base_url="http://cdn.darkanddarker.com/launcher"
base_dad_url="/Dark%20and%20Darker"

base_output_dir="IRONMACE"
base_blacksmith_dir="Blacksmith"
base_dungeoncrawler_dir="Dark and Darker"

CPPREST_SKIP=67816596
CPPREST_BYTES=965632

def sha256sum(filename):
    with open(filename, 'rb', buffering=0) as f:
        return hashlib.file_digest(f, 'sha256').hexdigest()

def http_get(url):
    logger.info("Requesting file from {}".format(url))
    try:
        r = requests.get(url)
        if r.status_code == 200:
            return r.content
        else:
            logger.error("Non 200 response.", r)
    except requests.exceptions.RequestException as e:  # This is the correct syntax
        raise SystemExit(e)

def write_launcher_sources():
    response_text = http_get("{}/launcherinfo.json".format(base_url))
    response_json = json.loads(response_text)
    sources = []
    for item in response_json["files"]:
        file_name = item["name"]
        digest = item["hash"].lower()
        dir = None
        if "dir" in item:
            dir = item["dir"]
        size = item["size"]

        path = ""
        if dir:
            path = "{}/{}".format(path, dir)
        quoted_path = "{}/{}".format(path, quote(file_name))
        path = "{}/{}".format(path, file_name)

        source = {
            "type": "extra-data",
            "filename": file_name,
            "url": "{}{}".format(base_url, quoted_path),
            "dest": "{}/{}/{}".format(base_output_dir, base_blacksmith_dir, path).replace("//", "/"),
            "sha256": digest,
            "size": size
        }
        sources.append(source)
    with open("blacksmith_sources.yaml", "w") as f:
        f.write(yaml.dump(sources, sort_keys=False))
    logger.info("Source generation complete for blacksmith")

def write_installer_source():
    blacksmith_url = "https://webdown.darkanddarker.com/Blacksmith%20Installer.exe"
    urllib.request.urlretrieve(blacksmith_url, 'bsi.exe')
    digest = sha256sum("bsi.exe")
    file_stats = os.stat("bsi.exe")
    source = {
        "type": "extra-data",
        "filename": 'bsi.exe',
        "url": blacksmith_url,
        "sha256": digest,
        "size": file_stats.st_size
    }
    with open("bs_installer_sources.yaml", "w") as f:
        f.write(yaml.dump(source, sort_keys=False))

def main() :
    write_launcher_sources()
    write_installer_source()

main()
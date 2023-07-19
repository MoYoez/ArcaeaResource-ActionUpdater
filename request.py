import sys
from pathlib import Path
from tqdm import tqdm
import requests


url = "https://webapi.lowiro.com/webapi/serve/static/bin/arcaea/apk"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 "
    "Safari/537.36",
    "Referer": "https://arcaea.lowiro.com",
    "Set-Cookie": "ctrcode=CN; domain=lowiro.com",
    "Access-Control-Allow-Origin": "https://arcaea.lowiro.com",
}

if len(sys.argv) > 1:
    get_url = sys.argv[1]
    get_version = sys.argv[2]
else:
    data = requests.get(url, headers=headers)
    rawdata = data.json()

    get_url = rawdata["value"]["url"]
    get_version = rawdata["value"]["version"]


output_dir = Path().absolute() / "arcaea"
song_dir = Path().absolute() / "arcaea" / "assets" / "songs"

apk_file = "arcaea_" + get_version + ".apk"
version = Path().absolute() / "version.txt"

print(f"get url value,try to download.\n" + get_url + "\n")

response = requests.get(get_url, stream=True)
# get length.
total = int(response.headers.get("content-length", 0))

with open(apk_file, "wb") as file, tqdm(
    desc=apk_file,
    total=total,
    unit="iB",
    unit_scale=True,
    unit_divisor=1024,
) as bar:
    for data in response.iter_content(chunk_size=1024):
        size = file.write(data)
        bar.update(size)

    print("downloaded,version: ", get_version)

with open(version, "w") as file:
    file.write(get_version)

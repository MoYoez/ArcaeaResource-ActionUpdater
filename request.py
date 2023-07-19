from pathlib import Path
from tqdm import tqdm
import requests


url = "https://webapi.lowiro.com/webapi/serve/static/bin/arcaea/apk"


data = requests.get(url)

data = data.json()

get_url = data["value"]["url"]
get_version = data["value"]["version"]

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

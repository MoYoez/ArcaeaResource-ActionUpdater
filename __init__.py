import os
from pathlib import Path
import zipfile
import requests
from tqdm import tqdm

url = "https://webapi.lowiro.com/webapi/serve/static/bin/arcaea/apk"

data = requests.get(url).json()

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

with zipfile.ZipFile(apk_file, "r") as zip_ref:
    for file_info in zip_ref.infolist():
        if file_info.filename.startswith(
            "assets/songs/"
        ) or file_info.filename.startswith("assets/char/"):
            zip_ref.extract(file_info, output_dir)

# delete all *.ogg || *.aff || Handle Process

for root, dirs, files in os.walk(song_dir):
    for dir in dirs:
        for file in os.listdir(os.path.join(root, dir)):
            file_path = os.path.join(root, dir, file)
            file_name, file_ext = os.path.splitext(file)
            if file_ext in [".aff", ".ogg"]:
                os.remove(file_path)

with open(version, "w") as file:
    file.write(get_version)

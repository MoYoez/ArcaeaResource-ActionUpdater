from pathlib import Path
from tqdm import tqdm
import requests
import os

with open("temp.txt", "w") as temp:
    get_temp = temp.read()

get_temp_list = get_temp.split("\n")

get_version = get_temp_list[1]
get_url = get_temp_list[0]

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

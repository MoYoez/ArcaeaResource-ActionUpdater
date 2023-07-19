import os
from pathlib import Path
import zipfile

version = Path().absolute() / "version.txt"
get_version = open(version, "r").read()

output_dir = Path().absolute() / "arcaea"
song_dir = Path().absolute() / "arcaea" / "assets" / "songs"

apk_file = "arcaea_" + get_version + ".apk"
version = Path().absolute() / "version.txt"

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

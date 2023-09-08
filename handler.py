import os
from pathlib import Path
import zipfile
import time

temp = Path().absolute() / "temp.txt"

get_temp = open(temp, "r").read()
get_version = get_temp.split("\n")[1]

output_dir = Path().absolute() / "arcaea"
song_dir = Path().absolute() / "arcaea" / "assets" / "songs"
update_time = time.now().strftime("%Y-%m-%d %H:%M:%S")

apk_file = "arcaea_" + get_version + ".apk"
# Handle raw resources

with zipfile.ZipFile(apk_file, "r") as zip_ref:
    for file_info in zip_ref.infolist():
        if (
            file_info.filename.startswith("assets/songs/")
            or file_info.filename.startswith("assets/char/")
            or file_info.filename.startswith("assets/img/")
        ):
            zip_ref.extract(file_info, output_dir)

# delete all *.ogg || *.aff || Handle Process

for root, dirs, files in os.walk(song_dir):
    for dir in dirs:
        for file in os.listdir(os.path.join(root, dir)):
            file_path = os.path.join(root, dir, file)
            file_name, file_ext = os.path.splitext(file)
            if file_ext in [".aff", ".ogg"]:
                os.remove(file_path)


# modify readme file

readme = open("README.Template", "r")
readme_content = readme.read()

readme_content = (
    readme_content
    + "\n\n"
    + "## Update Log:\n\n"
    + "\n"
    + "* Last Update: "
    + update_time
    + "   "
    + "Version: "
    + get_version
)

## remove old readme file.
os.remove("README.md")

## create new readme file.
with open("README.md", "w") as new_readme:
    new_readme.write(readme_content)

readme.close()

import sys
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

# init a temp file to save.
with open("temp.txt", "w") as temp:
    temp.write(get_url + "\n")
    temp.write(get_version + "\n")

with open("version.txt", "w") as version:
    version.write(get_version)

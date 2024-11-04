FROM ubuntu:24.04
ENV URL_="https://docs.python.org/3.12/archives/python-3.12-docs-html.zip"

RUN apt update && apt upgrade -y && \
apt install python3 -y && \
echo "#!/bin/python3" > get.py && \
echo "import urllib" >> get.py && \
echo "import urllib.parse" >> get.py && \
echo "import urllib.request" >> get.py && \
echo "from os import getenv" >> get.py && \
echo "from zipfile import ZipFile" >> get.py && \
echo "from sys import argv" >> get.py && \
echo "link = getenv('URL_') if getenv('URL_') is not None else argv[-1] if argv[-1] is not None else None" >> get.py && \
echo "if link and link != \"get.py\":" >> get.py && \
echo "    with urllib.request.urlopen(link, timeout=180) as zip:" >> get.py && \
echo "        if zip.status == 200:" >> get.py && \
echo "            blob = urllib.parse.urlsplit(link).path.split(\"/\")[-1]" >> get.py && \
echo "            with open(blob, 'wb') as fp:" >> get.py && \
echo "                fp.write(zip.read())" >> get.py && \
echo "                ZipFile(blob).extractall()" >> get.py && \
echo "else: " >> get.py && \
echo "    from pprint import pprint" >> get.py && \
echo "    pprint({\"Usage\": \"python3 get.py [ TYPE ]\", \"types\": [{  \"URL\": \"eg: https://host/file.zip\", \"EXPORT\": \"eg: export URL_='https://host/file.zip'\" }], \"INFO\": \"export must be URL_\" })" >> get.py && \
chmod +x get.py && ./get.py
  
USER www-data

ENTRYPOINT python3 -m http.server -d /python-3.12-docs-html/
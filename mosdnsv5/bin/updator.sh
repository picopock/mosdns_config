#!/bin/bash

mosdnsDir="/volume1/docker/mosdns"
# create tmp directory
mkdir -p ${mosdnsDir}/tmp
echo "########################### start download files ###########################"
# download related files to tmp directory
fileList="direct-list proxy-list reject-list apple-cn google-cn gfw greatfire"
for filename in $fileList; do
  newFilename=(${filename//-/_})
  echo -e "\n downloading ${newFilename}.txt ... \n"
  curl -C - --retry 10 https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/${filename}.txt >>${mosdnsDir}/tmp/${newFilename}.txt
done
echo "########################### all files download successfully! ###########################"
# move all tmp directory files to rules directory
mv -f ${mosdnsDir}/tmp/* ${mosdnsDir}/online_rules
# force delete tmp directory
rm -rf ${mosdnsDir}/tmp
# 重启 mosdns
docker restart mosdns
echo "mosdns restarted"

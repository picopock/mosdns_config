#!/bin/bash

mosdnsDir="/volume1/docker/mosdns"
# create tmp directory
mkdir -p ${mosdnsDir}/tmp
echo "########################### start download files ###########################"
# download related files to tmp directory
fileList="geoip geosite"
for filename in $fileList;
do
  newFilename=(${filename//-/_})
  echo -e "\n downloading https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/${newFilename}.dat ... \n"
  curl -C - --retry 10 https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/${filename}.dat >> ${mosdnsDir}/tmp/${newFilename}.dat
done
echo "########################### all files download successfully! ###########################"
# move all tmp directory files to rules directory
mv -f ${mosdnsDir}/tmp/* ${mosdnsDir}/
# force delete tmp directory
rm -rf ${mosdnsDir}/tmp
# 重启 mosdns
docker restart mosdns
echo "mosdns restarted"

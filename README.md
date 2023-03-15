# Mosdns Config
Mosdns config and auto update shell script.

## V4 Config

### Directory Structure

```sh
.
├── bin
│   └── updator.sh          # auto update bash script
├── config.yaml             # main config
├── geoip.dat               # from repo https://github.com/Loyalsoldier/v2ray-rules-dat
├── geosite.dat             # from repo https://github.com/Loyalsoldier/v2ray-rules-dat
└── rules                   # custom rules
    ├── block.txt           # block rule, referrer https://irine-sistiana.gitbook.io/mosdns-wiki/mosdns-v4/cha-jian-ji-qi-can-shu#yu-ming-pi-pei-qi
    ├── direct.txt          # forward local rule, referrer https://irine-sistiana.gitbook.io/mosdns-wiki/mosdns-v4/cha-jian-ji-qi-can-shu#yu-ming-pi-pei-qi
    ├── host.txt            # host rule, referrer https://irine-sistiana.gitbook.io/mosdns-wiki/mosdns-v4/cha-jian-ji-qi-can-shu#hosts-yu-ming-ying-she-ip
    ├── proxy.txt           # forward remote rule, referrer https://irine-sistiana.gitbook.io/mosdns-wiki/mosdns-v4/cha-jian-ji-qi-can-shu#yu-ming-pi-pei-qi
    └── redirect.txt        # redirect rule, referrer https://irine-sistiana.gitbook.io/mosdns-wiki/mosdns-v4/cha-jian-ji-qi-can-shu#redirect-ti-huan-qing-qiu-de-yu-ming-shi-yan-xing
```

### Auto Update

- `updator.sh`

  ```sh
  #!/bin/bash

  mosdnsDir="/volume1/docker/mosdns"         # mosdns dir
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
  docker restart mosdns                      # restart mosdns container
  echo "mosdns restarted"
  ```

- Auto Config

  ```sh
  chmod +x <mosdnsDir>/bin/updator.sh
  ```

  Edit crontab config, (the follow operate based on Debian 11):

  ```sh
  vi /etc/crontab
  ```

  Add config as follow:
  
  ```sh
  30 1    * * *   root    /volume1/docker/mosdns/bin/updator.sh
  ```

  The config will auto execute `/volume1/docker/mosdns/bin/updator.sh` as root role at 1:30 (local time) daily.

## V5 Config

### Directory Structure

```sh
.
├── bin
│   └── updator.sh                # auto update bash script
├── config.yaml                   # main config
├── custom_rules                  # user custon rule, has higher priority
│   ├── block.txt                 # block rule
│   ├── direct.txt                # forward local rule
│   ├── host.txt                  # host rule
│   ├── proxy.txt                 # forward remote rule
│   └── redirect.txt              # redirect rule
└── online_rules                  # rules from https://github.com/Loyalsoldier/v2ray-rules-dat
    ├── apple_cn.txt              # forward local rule
    ├── direct_list.txt           # forward local rule
    ├── gfw.txt                   # forward remote rule
    ├── google_cn.txt             # forward local rule
    ├── greatfire.txt             # forward remote rule
    ├── proxy_list.txt            # forward remote rule
    └── reject_list.txt           # ad rule
```

### Auto Update

- `updator.sh`

  ```sh
  #!/bin/bash

  mosdnsDir="/volume1/docker/mosdns"        # mosdns dir
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
  ```

- Auto Config

  ```sh
  chmod +x <mosdnsDir>/bin/updator.sh
  ```

  Edit crontab config, (the follow operate based on Debian 11):

  ```sh
  vi /etc/crontab
  ```

  Add config as follow:
  
  ```sh
  30 1    * * *   root    /volume1/docker/mosdns/bin/updator.sh
  ```

  The config will auto execute `/volume1/docker/mosdns/bin/updator.sh` as root role at 1:30 (local time) daily.

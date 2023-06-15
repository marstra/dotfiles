#!/usr/bin/env bash

set -e

cd $(dirname $(readlink -f $0))

DRIVES_FILE=drives.txt

# example drives.txt
# //my-net-drive/share,/mnt/share
# //my-net-drive/other,/mnt/other

if [ ! -f $DRIVES_FILE ]; then
  echo "no drive specification file found"
  exit 1
fi

echo "mount drives"

cat $DRIVES_FILE | grep -v "^$" | while read line; do
  arr=(${line//,/ })
  netDrive=${arr[0]}
  localMnt=${arr[1]}
  echo "mount $netDrive to $localMnt"
  sudo mkdir -p $localMnt
  sudo mount -t drvfs $netDrive $localMnt
done

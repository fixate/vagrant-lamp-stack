#!/usr/bin/env bash

if [[ $EUID -ne 0  ]]; then
  echo "This script must be run as root"
  exit 1
fi

which vagrant > /dev/null 2>/dev/null
if [[ $? -ne 0 ]]; then
  TEMPDIR=$(mktmp -d)
  TEMP="$TEMPDIR/vagrant.deb"
  curl -o $TEMP $VAGRANT_DEB
  dpkg -i $TEMP
  rm -rf $TEMPDIR
else
  echo "----> Vagrant already installed!"
  exit 0
fi


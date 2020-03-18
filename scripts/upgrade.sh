#!/usr/bin/env bash

set -euo pipefail

nocache=false
list=false
reboot=false
shutdown=false

usage() { echo "Usage: $0 [-h] [-c] [-l] [-r|-s]"; }

while getopts "hclrs" opt; do
  case $opt in
    c)
      nocache=true
      ;;
    l)
      list=true
      ;;
    r)
      reboot=true
      ;;
    s)
      shutdown=true
      ;;
    h)
      echo "Upgrade your system."
      usage
      echo "Arguments:"
      echo "  -c  Do NOT update apt cache."
      echo "  -l  List upgradable packages."
      echo "  -r  Reboot after upgrade."
      echo "  -s  Shutdown after upgrade."
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage 1>&2
      exit 1
      ;;
  esac
done

if ! [ "$nocache" = true ] ; then
    sudo apt update
fi

if [ "$list" = true ] ; then
    apt list --upgradable

    if [ "$shutdown" = true ] || [ "$reboot" = true ] ; then
        read -p "Press enter to continue"
    else
        exit 0
    fi
fi

sudo apt dist-upgrade -y
sudo apt autoremove -y

if [ "$shutdown" = true ] ; then
    shutdown -h now
    exit 0
fi

if [ "$reboot" = true ] ; then
    reboot
    exit 0
fi

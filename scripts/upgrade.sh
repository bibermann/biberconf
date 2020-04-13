#!/usr/bin/env bash

set -euo pipefail

yes=false
reboot=false
shutdown=false
nocache=false

usage() { echo "Usage: $0 [-h] [-y] [-r|-s] [-c]"; }

while getopts "hyrsc" opt; do
  case $opt in
    y)
      yes=true
      ;;
    r)
      reboot=true
      ;;
    s)
      shutdown=true
      ;;
    c)
      nocache=true
      ;;
    h)
      echo "List upgradable packages and upgrade your system."
      usage
      echo "Arguments:"
      echo "  -y  Upgrade without confirmation."
      echo "  -r  Reboot after upgrade."
      echo "  -s  Shutdown after upgrade."
      echo "  -c  Do NOT update apt cache."
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage 1>&2
      exit 1
      ;;
  esac
done

if [ "$shutdown" = true ] && [ "$reboot" = true ] ; then
    echo "Invalid options: -r and -s are mutually exclusive." >&2
    usage 1>&2
    exit 1
fi

if ! [ "$nocache" = true ] ; then
    sudo apt update
fi

apt list --upgradable

if ! [ "$yes" = true ] ; then
    more_text=""
    if [ "$shutdown" = true ] ; then
        more_text=" and shutdown"
    elif [ "$reboot" = true ] ; then
        more_text=" and reboot"
    fi
    read -p "Press enter to upgrade$more_text..."
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

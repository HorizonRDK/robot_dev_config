#!/bin/bash

# Check whether version of bsp is match with tros

if [ $# -lt 1 ];then
   echo "Please input BSP version"
   exit
fi

# tros_version=`dpkg --list tros | tail -1 | awk '{print $3}'`
# echo "tros_version: $tros_version"

# Depends=`apt show tros | grep -w -E "^Depends"`
# Depends=`echo "$Depends" | tr ',' '\n' | grep hobot`
# echo -e "hobot Depends:\n$Depends"

depend_bsp_version=$1
sys_bsp_version=`cat /etc/version`

if [ ${depend_bsp_version} != ${sys_bsp_version} ]; then
  echo -e "tros depends bsp_version [${depend_bsp_version}] is unmatched with system [${sys_bsp_version}], please update bsp with commands: \n\n\t sudo apt-get update && sudo apt-get upgrade\n"
  exit
# else
#   echo "tros depends bsp_version [${depend_bsp_version}] is matched with system [${sys_bsp_version}]"
fi
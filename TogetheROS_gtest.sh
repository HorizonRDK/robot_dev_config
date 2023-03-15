#!/bin/bash

function show_usage() {
cat <<EOF

Usage: bash -e $0 <options>
available options:
-s|--selction: select package to launch
-h|--help
EOF
exit

}

PACKAGE_SELECTION=""

GETOPT_ARGS=`getopt -o s:h -al selction:,help -- "$@"`
eval set -- "$GETOPT_ARGS"

while [ -n "$1" ]
do
 case "$1" in
    -s|--selction)
      selction=$2
      shift 2
      PACKAGE_SELECTION="$selction"
      ;;
    -h|--help) show_usage; break;;
     --) break ;;
     *) echo $1,$2 show_usage; break;;
  esac
done

python3 ./robot_dev_config/gtest_report.py ./build/${PACKAGE_SELECTION}

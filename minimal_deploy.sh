#!/bin/bash

INSTALL_DIR=""
echo "usage: ./minimal_deploy.sh -d install_path"
#get original install directory
while getopts "d:" opt; do
    case $opt in
        d)
        echo "original install directory is: $OPTARG"
        INSTALL_DIR=$OPTARG
        ;;
        \?)
        echo "Unknow input"
        exit 1
        ;;
    esac
done

#check install directory
if [ -z "$INSTALL_DIR" ]; then
    echo "INSTALL_DIR is NULL, exit!"
    exit 1
fi

if [ ! -d "$INSTALL_DIR/lib" ];then
    echo "$INSTALL_DIR/lib not exist!"
    exit 1
fi

if [ -d "./deploy" ];then
    echo "./deploy dictory exist, please remove it!"
    exit 1
fi

mkdir -p ./deploy
cp -r $INSTALL_DIR/lib  ./deploy
cd ./deploy
rm -rf "rosidl*"
rm -rf "python3.8"
find . -name "*introspection*" | xargs rm -rf

echo "done!"

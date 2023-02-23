#!/bin/bash

#*******************
platform=X3
#*******************

function show_usage() {
cat <<EOF

Usage: bash -e $0 <options>
available options:
-p|--platform: set platform ([X3|J5|X86])
-s|--selction: add colcon build --packages-select [PKG_NAME]
-h|--help
EOF
exit
}


if [ $# -lt 1 ];then
   show_usage
fi

PACKAGE_SELECTION=""

PLATFORM_OPTS=(X3 J5 X86)
GETOPT_ARGS=`getopt -o p:s:h -al platform:,selction:,help -- "$@"`
eval set -- "$GETOPT_ARGS"

while [ -n "$1" ]
do
  case "$1" in
    -p|--platform)
      platform=$2
      shift 2
      if [[ ! "${PLATFORM_OPTS[@]}" =~ $platform ]] ; then
        echo "invalid platform: $platform"
        show_usage
      fi
      ;;
    -s|--selction)
      selction=$2
      shift 2
      echo "colcon build selction: $selction"
      PACKAGE_SELECTION="--packages-select $selction"
      ;;
    -h|--help) show_usage; break;;
    --) break ;;
    *) echo $1,$2 show_usage; break;;
  esac
done

rm `pwd`/../sysroot_docker/usr

export ROS_VERSION=2
## 清除配置选项
./robot_dev_config/clear_COLCON_IGNORE.sh
## 配置编译选项，若需要最小化部署包则使用minimal_build.sh
./robot_dev_config/all_build.sh

echo "build platform " $platform
if [ $platform == "X86" ]; then
  echo "build X86"
  ln -s `pwd`/../sysroot_docker/usr_x86 `pwd`/../sysroot_docker/usr
  # 只编译x86平台的package
  ./robot_dev_config/x86_build.sh
  echo "PACKAGE_SELECTION: $PACKAGE_SELECTION"

  ## 开始编译
  colcon build $PACKAGE_SELECTION \
    --merge-install \
    --cmake-force-configure \
    --cmake-args \
      --no-warn-unused-cli \
      -DTHIRDPARTY=ON \
      -DBUILD_TESTING:BOOL=OFF \
      -DPLATFORM_X86=ON \
      -DBUILD_HBMEM=ON \
      -DTHIRD_PARTY=`pwd`/../sysroot_docker

else
  ## 配置交叉编译工具链
  export TARGET_ARCH=aarch64
  export TARGET_TRIPLE=aarch64-linux-gnu
  export CROSS_COMPILE=/usr/bin/$TARGET_TRIPLE-
  if [ $platform == "X3" ]; then
    echo "build X3"
    ln -s `pwd`/../sysroot_docker/usr_x3 `pwd`/../sysroot_docker/usr
  elif [ $platform == "J5" ]; then
    echo "build J5"
    ln -s `pwd`/../sysroot_docker/usr_j5 `pwd`/../sysroot_docker/usr
    # 只编译J5平台的package
    ./robot_dev_config/j5_build.sh
  fi
  
  echo "PACKAGE_SELECTION: $PACKAGE_SELECTION"
  
  ## 开始交叉编译
  colcon build $PACKAGE_SELECTION \
    --merge-install \
    --cmake-force-configure \
    --cmake-args \
      --no-warn-unused-cli \
      -DCMAKE_TOOLCHAIN_FILE=`pwd`/robot_dev_config/aarch64_toolchainfile.cmake \
      -DPLATFORM_${platform}=ON \
      -DTHIRDPARTY=ON \
      -DBUILD_TESTING:BOOL=OFF \
      -DCMAKE_BUILD_RPATH="`pwd`/build/poco_vendor/poco_external_project_install/lib/;`pwd`/build/libyaml_vendor/libyaml_install/lib/"

fi

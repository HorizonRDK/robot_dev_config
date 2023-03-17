#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please specify package name as argument (tros_hobot_audio, tros_performance_test, or tros_orb_slam3)'
    exit 1
fi

package_name=$1

case $package_name in
    "tros_hobot_audio")
        install_dir="install_audio"
        ;;
    "tros_performance_test")
        install_dir="install_performance_test"
        ;;
    "tros_orb_slam3")
        install_dir="install_orb-slam3"
        ;;
    *)
        echo "Invalid package name. Please specify one of the following: tros_hobot_audio, tros_performance_test, tros_orb_slam3"
        exit 1
        ;;
esac

version=1.1.6
architecture=arm64

tmp_dir=../tmp
backup_dir=../backup
bash_dir=`dirname ${BASH_SOURCE[0]}`

if [ -e ${tmp_dir}/${package_name} ]; then
  echo "backup file ${tmp_dir}/${package_name}"
  mkdir -p ${backup_dir}
  mv ${tmp_dir}/${package_name} ${backup_dir}/${package_name}_`date +%Y-%m-%d_%H-%M-%S`
fi

mkdir -p ${tmp_dir}
cp -rf ${bash_dir}/${package_name} ${tmp_dir}/

rm `find ${tmp_dir}/${package_name} -name .gitkeep`

mkdir -p ${tmp_dir}/${package_name}/opt/tros

cp -rf ${install_dir}/bin ${tmp_dir}/${package_name}/opt/tros
cp -rf ${install_dir}/lib ${tmp_dir}/${package_name}/opt/tros
cp -rf ${install_dir}/share ${tmp_dir}/${package_name}/opt/tros
cp -rf ${install_dir}/include ${tmp_dir}/${package_name}/opt/tros

dpkg -b ${tmp_dir}/${package_name} ${package_name}_${version}_${architecture}.deb

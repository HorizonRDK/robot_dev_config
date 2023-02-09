#!/bin/bash


function show_usage() {
    echo -e "\nUsage: bash $0 [tros install path]\n"
}

# find cmake files in ${tros_install_path}/share and the ${replaced_prefix_path} in cmake files will be replaced with ${CMAKE_SYSROOT}
# tros_install_path can be default or set by user
tros_install_path=/opt/tros
# replaced_prefix_path is set automatily in cmake files during tros build
# replaced_prefix_path will be parsed from file ${tros_install_path}/setup.sh
replaced_prefix_path=""

function parse_sysroot_path() {
    parse_file=setup.sh
    echo -e "Parse sysroot path automaticaly from file [${parse_file}] under path [${tros_install_path}]"
    build_install_path=`grep "_colcon_prefix_chain_sh_COLCON_CURRENT_PREFIX" ${tros_install_path}/${parse_file} | awk -F '=' '{print $2}' | head -1`
    build_install_dir_path=`dirname ${build_install_path}`
    build_sysroot_docker_dir_path=`dirname ${build_install_dir_path}`
    echo "Parsed build_sysroot_docker_dir_path [${build_sysroot_docker_dir_path}]"

    if [ ${#build_sysroot_docker_dir_path} -lt 1 ];then
        echo "Error! Parse build_sysroot_docker_dir_path fail!"
        exit
    fi

    replaced_prefix_path=${build_sysroot_docker_dir_path}/sysroot_docker
}

if [ $# -lt 1 ];then
    show_usage
    echo "Using default tros install path [${tros_install_path}]}"
else
    tros_install_path=$1
    echo "Set tros install path [${tros_install_path}]"
fi

if [ ! -d ${tros_install_path} ];then
    echo "Error! TROS install path [${tros_install_path}] unexist!"
    exit
fi


cmake_files=`find ${tros_install_path}/share -name "*\.cmake"`
if [ ${#cmake_files} -lt 1 ];then
    echo "Error! Find cmake file fail in path [${tros_install_path}/share]"
    exit
else
    echo "Find cmake file success in path [${tros_install_path}/share]"
fi

parse_sysroot_path
echo -e "Replace path [${replaced_prefix_path}] with [\${CMAKE_SYSROOT}] in cmake files.\n"

parsed_cmake_files=`grep "${replaced_prefix_path}" ${cmake_files}`
if [ ${#parsed_cmake_files} -lt 1 ];then
    echo "Cmake files do not have key words [${replaced_prefix_path}]"
    exit
fi
grep "${replaced_prefix_path}" ${cmake_files} | awk -F ':' '{print $1}' | xargs -t -i sed -i "s#${replaced_prefix_path}#\${CMAKE_SYSROOT}#g" {}

echo -e "\nReplace success"

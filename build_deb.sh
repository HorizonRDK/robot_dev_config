#!/bin/bash

# set -x

platform=X3
build_testing=OFF

tros_package_name="tros"
tros_package_version="2.1.3"

ros_base_package_name="${tros_package_name}-ros-base"
ros_base_package_version="2.1.0"
tros_distro=foxy
tros_install_prefix=""

# 打印脚本使用方法
usage() {
    echo "Usage: $0 platform package_name"
    echo "  platform: One of x3, rdkultra, or x86"
    echo "  package_name: ros-base, tros, others, all, or select package name"
}

# 确保输入参数正确
if [ $# -ne 2 ]; then
    echo "params num [$#] is invalid, which should 2"
    usage
    exit 1
fi

# 获取输入参数
platform=$1
package_build_name=$2

pwd_dir=$PWD
tmp_dir=${pwd_dir}/../tmp/${platform}
deb_dir=${pwd_dir}/../deb/${platform}

rm "${pwd_dir}/../sysroot_docker/usr"

# 根据platform设置环境变量
if [ "$platform" == "x3" ]; then
    platform=X3
    ln -s "${pwd_dir}/../sysroot_docker/usr_x3" "${pwd_dir}/../sysroot_docker/usr"
elif [ "$platform" == "rdkultra" ]; then
    platform=Rdkultra
    ln -s "${pwd_dir}/../sysroot_docker/usr_rdkultra" "${pwd_dir}/../sysroot_docker/usr"
elif [ "$platform" == "x86" ]; then
    platform=X86
    ln -s "${pwd_dir}/../sysroot_docker/usr_x86" "${pwd_dir}/../sysroot_docker/usr"
else
    echo "Invalid platform."
    usage
    exit 1
fi

export ROS_VERSION=2
if [ "$platform" == "X3" ] || [ "$platform" == "Rdkultra" ]; then
    export TARGET_ARCH=aarch64
    export TARGET_TRIPLE=aarch64-linux-gnu
    export CROSS_COMPILE=/usr/bin/$TARGET_TRIPLE-
fi

# ros_base_packages一般固定，从文件中读取
ros_base_packages=()
deb_build_packages=()
deb_build_packages_path=()
tros_package_exclude=("orb_slam3" "orb_slam3_example_ros2" "performance_test" "agent_node")
depended_bsp_packages=("hobot-multimedia-dev" "hobot-multimedia" "hobot-dnn" "hobot-camera")
ros_package_prefix="ros-${tros_distro}"

# 更新列表信息
readarray -t ros_base_packages <"${pwd_dir}/robot_dev_config/ros_base_packages_${platform}.list"

# 函数：判断字符串是否在字符串列表中
# 参数：
#   $1: 待判断的字符串
#   $2: 字符串列表
# 返回值：
#   0: 字符串存在于列表中
#   1: 字符串不存在于列表中
function is_string_in_list() {
    local search_str="$1"
    shift
    local list=("$@")

    for item in "${list[@]}"; do
        if [[ "$item" == "$search_str" ]]; then
            return 0
        fi
    done

    return 1
}

function clear_colcon_ignore {
    find "${pwd_dir}/src" -name "COLCON_IGNORE" -print0 | xargs -0 rm
}

function ros_base_colcon_ignore {
    if [ "$platform" == "X3" ] || [ "$platform" == "Rdkultra" ]; then
        touch \
            ./src/tros/performance_test_fixture/COLCON_IGNORE \
            ./src/tros/rviz/COLCON_IGNORE \
            ./src/tools/benchmark/performance_test_ros1_msgs/COLCON_IGNORE \
            ./src/tools/benchmark/performance_test_ros1_publisher/COLCON_IGNORE \
            ./src/ros/ros_tutorials/COLCON_IGNORE \
            ./src/tros/ros1_bridge/COLCON_IGNORE \
            ./src/eProsima/compatibility/COLCON_IGNORE \
            ./src/app/COLCON_IGNORE \
            ./src/box/hobot_audio/COLCON_IGNORE \
            ./src/box/hobot_codec/COLCON_IGNORE \
            ./src/box/hobot_cv/COLCON_IGNORE \
            ./src/box/hobot_dnn/COLCON_IGNORE \
            ./src/box/hobot_hdmi/COLCON_IGNORE \
            ./src/box/hobot_interactions/COLCON_IGNORE \
            ./src/box/hobot_msgs/COLCON_IGNORE \
            ./src/box/hobot_perception/COLCON_IGNORE \
            ./src/box/hobot_sensor/COLCON_IGNORE \
            ./src/box/hobot_slam/COLCON_IGNORE \
            ./src/box/hobot_websocket/COLCON_IGNORE \
            ./src/box/hobot_trigger/COLCON_IGNORE \
            ./src/tools/hobot_image_publisher/COLCON_IGNORE \
            ./src/tools/hobot_visualization/COLCON_IGNORE \
            ./src/tools/benchmark/performance_test/COLCON_IGNORE
    elif [ "$platform" == "X86" ]; then
        touch \
            ./src/tros/performance_test_fixture/COLCON_IGNORE \
            ./src/tros/rviz/COLCON_IGNORE \
            ./src/tools/benchmark/performance_test_ros1_msgs/COLCON_IGNORE \
            ./src/tools/benchmark/performance_test_ros1_publisher/COLCON_IGNORE \
            ./src/ros/ros_tutorials/COLCON_IGNORE \
            ./src/tros/ros1_bridge/COLCON_IGNORE \
            ./src/eProsima/compatibility/COLCON_IGNORE \
            ./src/app/COLCON_IGNORE \
            ./src/box/hobot_audio/COLCON_IGNORE \
            ./src/box/hobot_codec/COLCON_IGNORE \
            ./src/box/hobot_cv/COLCON_IGNORE \
            ./src/box/hobot_dnn/COLCON_IGNORE \
            ./src/box/hobot_hdmi/COLCON_IGNORE \
            ./src/box/hobot_interactions/COLCON_IGNORE \
            ./src/box/hobot_msgs/COLCON_IGNORE \
            ./src/box/hobot_perception/COLCON_IGNORE \
            ./src/box/hobot_sensor/COLCON_IGNORE \
            ./src/box/hobot_slam/COLCON_IGNORE \
            ./src/box/hobot_websocket/COLCON_IGNORE \
            ./src/box/hobot_trigger/COLCON_IGNORE \
            ./src/tools/hobot_image_publisher/COLCON_IGNORE \
            ./src/tools/hobot_visualization/COLCON_IGNORE \
            ./src/tools/benchmark/COLCON_IGNORE \
            ./src/tools/benchmark/performance_test/COLCON_IGNORE
    fi
}

function update_deb_build_packages {
    cd "$pwd_dir" || exit
    clear_colcon_ignore
    if [ "$platform" == "X3" ]; then
        "${pwd_dir}"/robot_dev_config/all_build.sh
    elif [ "$platform" == "X86" ]; then
        "${pwd_dir}"/robot_dev_config/x86_build.sh
    elif [ "$platform" == "Rdkultra" ]; then
        "${pwd_dir}"/robot_dev_config/rdkultra_build.sh
    fi

    # 定义工作目录和deb包目录
    pkg_dir="${pwd_dir}/src"

    cd "$pkg_dir" || exit
    # 查找所有存在package.xml的包
    readarray -t pkg_list < <(colcon list)
    cd "$pwd_dir" || exit

    # 遍历所有包
    for i in "${!pkg_list[@]}"; do
        # 将行按空格分割成数组
        row=(${pkg_list[i]//  / })
        pkg_name=${row[0]}
        pkg_path=${row[1]}
        pkg_path="${pkg_dir}/${pkg_path}"

        if is_string_in_list "$pkg_name" "${ros_base_packages[@]}"; then
            continue
        fi

        deb_build_packages+=("$pkg_name")
        deb_build_packages_path+=("$pkg_path")
    done
}

update_deb_build_packages

function build_ros_base() {
    cd "$pwd_dir" || exit

    clear_colcon_ignore

    # 删除原有编译目录，重新编译
    if [ -d install ]; then
        rm -rf install
    fi

    if [ -d build ]; then
        rm -rf build
    fi

    pkg_dir="${pwd_dir}/src"

    cd "$pkg_dir" || exit
    # 查找所有存在package.xml的包
    readarray -t pkg_all_list < <(colcon list)

    # 遍历所有包
    for i in "${!pkg_all_list[@]}"; do
        # 将行按空格分割成数组
        row=(${pkg_all_list[i]//  / })
        pkg_name=${row[0]}
        pkg_path=${row[1]}

        if is_string_in_list "$pkg_name" "${ros_base_packages[@]}"; then
            continue
        fi

        touch "$pkg_path"/COLCON_IGNORE
    done

    cd "$pwd_dir" || exit

    if [ "$platform" == "X3" ] || [ "$platform" == "Rdkultra" ]; then
        colcon build \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DCMAKE_TOOLCHAIN_FILE="$(pwd)/robot_dev_config/aarch64_toolchainfile.cmake" \
            -DPLATFORM_${platform}=ON \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING=$build_testing \
            -DCMAKE_BUILD_RPATH="$(pwd)/build/poco_vendor/poco_external_project_install/lib/;$(pwd)/build/libyaml_vendor/libyaml_install/lib/"
    elif [ "$platform" == "X86" ]; then
        colcon build \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING:BOOL=OFF \
            -DPLATFORM_X86=ON \
            -DBUILD_HBMEM=ON \
            -DTHIRD_PARTY="$(pwd)/../sysroot_docker"
    fi
}

function create_ros_base_deb_package {
    version_date=$(date +'%Y%m%d%H%M%S')
    ros_base_package_version="$ros_base_package_version-$version_date"
    ros_base_temporary_directory_name=${ros_base_package_name}_${ros_base_package_version}

    cd "$pwd_dir" || exit
    mkdir -p "${tmp_dir}/${ros_base_temporary_directory_name}/opt"

    cp -rf "${pwd_dir}"/install "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt
    mv "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/install "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros

    bash "${pwd_dir}"/robot_dev_config/deploy/install_deps_setup.sh "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros
    # 只有1.0版本tros才需要此脚本
    # if [ "$platform" == "X3" ]; then
    #     cp "${pwd_dir}"/robot_dev_config/deploy/check_version.sh "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros
    # fi
    # cp "${pwd_dir}"/robot_dev_config/create_soft_link.py "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros

    rm "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros/COLCON_IGNORE

    sed -i '19i \ \
# source ros2 prefixes \
# setting COLCON_CURRENT_PREFIX avoids determining the prefix in the sourced script \
COLCON_CURRENT_PREFIX="/opt/ros/${tros_install_prefix}" \
if [ -f "$COLCON_CURRENT_PREFIX/local_setup.bash" ]; then \
    _colcon_prefix_chain_bash_source_script "$COLCON_CURRENT_PREFIX/local_setup.bash"\
fi
' "${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros/setup.bash

    # 将root权限检查和切换脚本添加到启动脚本中
    # Adds the distribution information to the startup script
    tros_env_script="${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros/setup.bash
    echo -e "$(cat ${pwd_dir}/robot_dev_config/deploy/check_uid.sh)\n\n$(cat ${tros_env_script})" >${tros_env_script}
    echo -e "\nexport TROS_DISTRO=${tros_install_prefix}\n" >>${tros_env_script}
    tros_env_script="${tmp_dir}"/"${ros_base_temporary_directory_name}"/opt/tros/local_setup.bash
    echo -e "$(cat ${pwd_dir}/robot_dev_config/deploy/check_uid.sh)\n\n$(cat ${tros_env_script})" >${tros_env_script}
    echo -e "\nexport TROS_DISTRO=${tros_install_prefix}\n" >>${tros_env_script}

    mkdir -p "${tmp_dir}/${ros_base_temporary_directory_name}/DEBIAN"
    cd "${tmp_dir}/${ros_base_temporary_directory_name}/" || exit

    install_size=$(du -sk opt | cut -f1)

    if [ "$platform" == "X3" ]; then
        deb_dependencies="hobot-multimedia-dev"

        # 创建control文件
        cat >DEBIAN/control <<EOF
Package: $ros_base_package_name
Version: $ros_base_package_version
Architecture: arm64
Depends: ${deb_dependencies}
Maintainer: kairui.wang <kairui.wang@horizon.ai>
Description: TogetheROS Bot Base
Installed-Size: $install_size
EOF

    elif [ "$platform" == "Rdkultra" ]; then
        # 创建control文件
        cat >DEBIAN/control <<EOF
Package: $ros_base_package_name
Version: $ros_base_package_version
Architecture: arm64
Depends: ${deb_dependencies}
Maintainer: kairui.wang <kairui.wang@horizon.ai>
Description: TogetheROS Bot Base
EOF

    elif [ "$platform" == "X86" ]; then
        deb_dependencies="libtinyxml2-dev, libyaml-dev, libzstd-dev, libeigen3-dev, libxml2-utils, libtinyxml-dev, libssl-dev, python3-numpy, libconsole-bridge-dev, pydocstyle, libgtest-dev, cppcheck, python3-lark, libspdlog-dev, google-mock, python3-flake8, python3-pydot, python3-psutil, libfreetype6-dev, libxaw7-dev, libxrandr-dev, python3-pytest-mock, python3-mypy, default-jdk, libcunit1-dev, libopencv-dev, python3-ifcfg, python3-matplotlib, graphviz, uncrustify, python3-lxml, libcppunit-dev, libcurl4-openssl-dev, python3-mock, python3-nose, libsqlite3-dev, pyflakes3, clang-tidy, python3-lttng, liblog4cxx-dev, python3-babeltrace, python3-pycodestyle, libboost-dev, libboost-python-dev, python3-opencv, libboost-python1.71.0"

        # 创建control文件
        cat >DEBIAN/control <<EOF
Package: $ros_base_package_name
Version: $ros_base_package_version
Architecture: amd64
Depends: ${deb_dependencies}
Maintainer: kairui.wang <kairui.wang@horizon.ai>
Description: TogetheROS Bot Base
Installed-Size: $install_size
EOF

    fi

    mkdir -p "$deb_dir"
    fakeroot dpkg-deb --build "${tmp_dir}/${ros_base_temporary_directory_name}" "${deb_dir}"

    echo "已打包完成 $ros_base_package_name"
}

function create_tros_deb_package {
    if [ "$platform" == "X3" ] || [ "$platform" == "Rdkultra" ]; then
        arch=arm64
    elif [ "$platform" == "X86" ]; then
        arch=amd64
    fi

    version_date=$(date +'%Y%m%d%H%M%S')
    tros_package_version="$tros_package_version-$version_date"

    tros_temporary_directory_name=${tros_package_name}_${tros_package_version}
    mkdir -p "${tmp_dir}/${tros_temporary_directory_name}/DEBIAN"

    # 进入编译后的目录，复制文件到deb目录下
    cd "${tmp_dir}/${tros_temporary_directory_name}/" || exit

    deb_dependencies="hobot-models-basic, ${ros_base_package_name}"
    for package in "${deb_build_packages[@]}"; do
        if is_string_in_list "$package" "${tros_package_exclude[@]}"; then
            continue
        fi

        package_name_deb="${tros_package_name}-${package//_/\-}"
        deb_dependencies+=", "$package_name_deb
    done

    # 创建control文件
    cat >DEBIAN/control <<EOF
Package: $tros_package_name
Version: $tros_package_version
Architecture: $arch
Depends: ${deb_dependencies}
Maintainer: kairui.wang <kairui.wang@horizon.ai>
Description: TogetheROS Bot
Installed-Size: 0
EOF

    mkdir -p "${tmp_dir}/${tros_temporary_directory_name}/usr/share/keyrings/"
    mkdir -p "${tmp_dir}/${tros_temporary_directory_name}/etc/apt/sources.list.d/"

    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o ./usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=arm64 signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu focal main" | tee ./etc/apt/sources.list.d/ros2.list >/dev/null

    mkdir -p "$deb_dir"
    fakeroot dpkg-deb --build "${tmp_dir}/${tros_temporary_directory_name}" "${deb_dir}"
}

function build_all() {
    cd "$pwd_dir" || exit

    clear_colcon_ignore

    if [ "$platform" == "X3" ]; then
        "${pwd_dir}"/robot_dev_config/all_build.sh

        colcon build \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DCMAKE_TOOLCHAIN_FILE="$(pwd)/robot_dev_config/aarch64_toolchainfile.cmake" \
            -DPLATFORM_${platform}=ON \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING=$build_testing \
            -DCMAKE_BUILD_RPATH="$(pwd)/build/poco_vendor/poco_external_project_install/lib/;$(pwd)/build/libyaml_vendor/libyaml_install/lib/"
    elif [ "$platform" == "Rdkultra" ]; then
        "${pwd_dir}"/robot_dev_config/rdkultra_build.sh

        colcon build \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DCMAKE_TOOLCHAIN_FILE="$(pwd)/robot_dev_config/aarch64_toolchainfile.cmake" \
            -DPLATFORM_${platform}=ON \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING=$build_testing \
            -DCMAKE_BUILD_RPATH="$(pwd)/build/poco_vendor/poco_external_project_install/lib/;$(pwd)/build/libyaml_vendor/libyaml_install/lib/"
    elif [ "$platform" == "X86" ]; then
        "${pwd_dir}"/robot_dev_config/x86_build.sh

        colcon build \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING:BOOL=OFF \
            -DPLATFORM_X86=ON \
            -DBUILD_HBMEM=ON \
            -DTHIRD_PARTY="$(pwd)/../sysroot_docker"
    fi
}

function all_build_deb_package() {
    local pkg="$1"

    cd "$pwd_dir" || exit
    source install/setup.bash

    # 解析包名
    package_name=$(xmllint --xpath 'string(/package/name/text())' "${pkg}/package.xml")

    if [ "$platform" == "X3" ] || [ "$platform" == "Rdkultra" ]; then
        colcon build \
            --packages-select="$package_name" \
            --build-base=build_temp_${platform}/build_"${package_name}" \
            --install-base=install_temp_${platform}/install_"${package_name}" \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DCMAKE_TOOLCHAIN_FILE="$(pwd)/robot_dev_config/aarch64_toolchainfile.cmake" \
            -DPLATFORM_${platform}=ON \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING=$build_testing \
            -DCMAKE_BUILD_RPATH="$(pwd)/build/poco_vendor/poco_external_project_install/lib/;$(pwd)/build/libyaml_vendor/libyaml_install/lib/"
    elif [ "$platform" == "X86" ]; then
        colcon build \
            --packages-select="$package_name" \
            --build-base=build_temp_${platform}/build_"${package_name}" \
            --install-base=install_temp_${platform}/install_"${package_name}" \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING:BOOL=OFF \
            -DPLATFORM_X86=ON \
            -DBUILD_HBMEM=ON \
            -DTHIRD_PARTY="$(pwd)/../sysroot_docker"
    fi
}

function build_deb_package() {
    local pkg="$1"

    cd "$pwd_dir" || exit

    # 解析包名
    package_name=$(xmllint --xpath 'string(/package/name/text())' "${pkg}/package.xml")

    if [ "$platform" == "X3" ] || [ "$platform" == "Rdkultra" ]; then
        colcon build \
            --packages-select="$package_name" \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DCMAKE_TOOLCHAIN_FILE="$(pwd)/robot_dev_config/aarch64_toolchainfile.cmake" \
            -DPLATFORM_${platform}=ON \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING=$build_testing \
            -DCMAKE_BUILD_RPATH="$(pwd)/build/poco_vendor/poco_external_project_install/lib/;$(pwd)/build/libyaml_vendor/libyaml_install/lib/"

        # shellcheck source=install/setup.bash
        source install/setup.bash

        colcon build \
            --packages-select="$package_name" \
            --build-base=build_temp_${platform}/build_"${package_name}" \
            --install-base=install_temp_${platform}/install_"${package_name}" \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DCMAKE_TOOLCHAIN_FILE="$(pwd)/robot_dev_config/aarch64_toolchainfile.cmake" \
            -DPLATFORM_${platform}=ON \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING=$build_testing \
            -DCMAKE_BUILD_RPATH="$(pwd)/build/poco_vendor/poco_external_project_install/lib/;$(pwd)/build/libyaml_vendor/libyaml_install/lib/"
    elif [ "$platform" == "X86" ]; then
        colcon build \
            --packages-select="$package_name" \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING:BOOL=OFF \
            -DPLATFORM_X86=ON \
            -DBUILD_HBMEM=ON \
            -DTHIRD_PARTY="$(pwd)/../sysroot_docker"

        # shellcheck source=install/setup.bash
        source install/setup.bash

        colcon build \
            --packages-select="$package_name" \
            --build-base=build_temp_${platform}/build_"${package_name}" \
            --install-base=install_temp_${platform}/install_"${package_name}" \
            --merge-install \
            --cmake-force-configure \
            --cmake-args \
            --no-warn-unused-cli \
            -DTHIRDPARTY=ON \
            -DBUILD_TESTING:BOOL=OFF \
            -DPLATFORM_X86=ON \
            -DBUILD_HBMEM=ON \
            -DTHIRD_PARTY="$(pwd)/../sysroot_docker"
    fi
}

function create_deb_package() {
    local pkg="$1"
    local arch=""
    if [ "$platform" == "X3" ] || [ "$platform" == "Rdkultra" ]; then
        arch=arm64
    elif [ "$platform" == "X86" ]; then
        arch=amd64
    fi

    # 解析包名
    package_name=$(xmllint --xpath 'string(/package/name/text())' "${pkg}/package.xml")
    # 解析版本号
    package_version=$(xmllint --xpath 'string(/package/version/text())' "${pkg}/package.xml")
    package_description=$(xmllint --xpath 'string(/package/description/text())' "${pkg}/package.xml")
    package_maintainer_content=$(xmllint --xpath 'string(/package/maintainer/text())' "${pkg}/package.xml")
    package_maintainer_email=$(xmllint --xpath 'string(/package/maintainer/@email)' "${pkg}/package.xml")
    package_maintainer="$package_maintainer_content <$package_maintainer_email>"

    package_description=$(echo "$package_description" | sed '/^\s*$/d')

    depend_list=""
    build_depend_list=""
    exec_depend_list=""
    # 解析依赖
    if [ "$(xmllint --xpath 'count(//depend)' "${pkg}/package.xml")" -gt 0 ]; then
        depend_list=$(xmllint --nowarning --xpath '//depend[not(@condition) or @condition="$PLATFORM == '$platform'"]/text()' "${pkg}/package.xml")
    fi

    if [ "$(xmllint --xpath 'count(//build_depend)' "${pkg}/package.xml")" -gt 0 ]; then
        build_depend_list=$(xmllint --nowarning --xpath '//build_depend[not(@condition) or @condition="$PLATFORM == '$platform'"]/text()' "${pkg}/package.xml")
    fi

    if [ "$(xmllint --xpath 'count(//exec_depend)' "${pkg}/package.xml")" -gt 0 ]; then
        exec_depend_list=$(xmllint --nowarning --xpath '//exec_depend[not(@condition) or @condition="$PLATFORM == '$platform'"]/text()' "${pkg}/package.xml")
    fi

    # 将依赖放入一个数组
    dependencies=()
    for dependency in $depend_list $build_depend_list $exec_depend_list; do
        dependencies+=("$dependency")
    done
    # 去重并排序
    mapfile -t dependencies < <(printf '%s\n' "${dependencies[@]}" | sort -u)

    ros_base_added=false
    deb_dependencies=""
    for depend_package in "${dependencies[@]}"; do
        if is_string_in_list "$depend_package" "${ros_base_packages[@]}"; then
            if ! $ros_base_added; then
                deb_dependencies+=" ${ros_base_package_name},"
                ros_base_added=true
            fi
        elif is_string_in_list "$depend_package" "${deb_build_packages[@]}"; then
            # 替换包名中的 '_' 为 '-'
            depend_package=${depend_package//_/\-}
            deb_dependencies+=" ${tros_package_name}-${depend_package},"
        elif is_string_in_list "$depend_package" "${depended_bsp_packages[@]}"; then
            # 替换包名中的 '_' 为 '-'
            depend_package=${depend_package//_/\-}
            deb_dependencies+=" ${depend_package},"
        elif [[ $depend_package == $ros_package_prefix* ]]; then
            deb_dependencies+=" ${depend_package},"
        fi
    done

    deb_dependencies=${deb_dependencies%,} # 去掉最后一个逗号
    deb_dependencies=${deb_dependencies# } # 去掉第一个空格

    echo "deb_dependencies: ${deb_dependencies}"

    package_name_deb="${tros_package_name}-${package_name//_/\-}"

    version_date=$(date +'%Y%m%d%H%M%S')
    package_version="$package_version-$version_date"

    cd "$pwd_dir" || exit
    package_temporary_directory_name=${package_name_deb}_${package_version}
    package_install_directory="${tmp_dir}/${package_temporary_directory_name}/opt/tros"
    mkdir -p "$package_install_directory"
    install_dir=install_temp_${platform}
    if [ -d ${install_dir}/install_"${package_name}"/bin ]; then
        cp -rf ${install_dir}/install_"${package_name}"/bin "$package_install_directory"
    fi

    if [ -d ${install_dir}/install_"${package_name}"/lib ]; then
        cp -rf ${install_dir}/install_"${package_name}"/lib "$package_install_directory"
    fi

    if [ -d ${install_dir}/install_"${package_name}"/share ]; then
        cp -rf ${install_dir}/install_"${package_name}"/share "$package_install_directory"
    fi

    if [ -d ${install_dir}/install_"${package_name}"/include ]; then
        cp -rf ${install_dir}/install_"${package_name}"/include "$package_install_directory"
    fi

    cp -rf ${install_dir}/install_"${package_name}"/setup.sh "$package_install_directory"
    bash "${pwd_dir}"/robot_dev_config/deploy/install_deps_setup.sh "$package_install_directory"
    rm "$package_install_directory/setup.sh"

    mkdir -p "${tmp_dir}/${package_temporary_directory_name}/DEBIAN"
    cd "${tmp_dir}/${package_temporary_directory_name}/" || exit

    install_size=$(du -sk opt | cut -f1)

    # 创建control文件
    cat >DEBIAN/control <<EOF
Package: $package_name_deb
Version: $package_version
Architecture: $arch
Depends: ${deb_dependencies}
Maintainer: $package_maintainer
Description: $package_description
Installed-Size: $install_size
EOF

    mkdir -p "$deb_dir"
    # 打包成deb包
    fakeroot dpkg-deb --build "${tmp_dir}/${package_temporary_directory_name}" "${deb_dir}"
}

function pack_tros_packages {
    # 先全量编译
    build_all

    for pkg in "${deb_build_packages_path[@]}"; do
        echo "处理包: $pkg"
        all_build_deb_package "$pkg"
        create_deb_package "$pkg"
        count=$((count + 1))
    done

    echo "所有包已打包完成 $count"
}

function pack_tros_package_select {
    clear_colcon_ignore
    if [ "$platform" == "X3" ]; then
        "${pwd_dir}"/robot_dev_config/all_build.sh
    elif [ "$platform" == "Rdkultra" ]; then
        "${pwd_dir}"/robot_dev_config/rdkultra_build.sh
    elif [ "$platform" == "X86" ]; then
        "${pwd_dir}"/robot_dev_config/x86_build.sh
    fi

    # 获取$deb_build_packages_path列表相同位置的结果
    index=0
    for i in "${!deb_build_packages[@]}"; do
        if [[ "${deb_build_packages[$i]}" = "$package_build_name" ]]; then
            index=$i
            break
        fi
    done
    pkg="${deb_build_packages_path[$index]}"
    echo "处理包: $pkg"
    build_deb_package "$pkg"
    create_deb_package "$pkg"
    echo "已打包完成 $package_build_name"
}

# 更新ros_base_packages前，需要先更新ros_base_colcon_ignore
function update_ros_base_packages {
    clear_colcon_ignore
    ros_base_colcon_ignore

    cd "${pwd_dir}"/src || exit
    colcon list --names-only >"$pwd_dir/robot_dev_config/ros_base_packages_${platform}.list"
    cd "$pwd_dir" || exit
}

if [ "$package_build_name" == "update_ros_base_packages" ]; then
    update_ros_base_packages
    exit
fi

# 根据platform设置环境变量
if [ "$package_build_name" == "ros-base" ]; then
    build_ros_base
    create_ros_base_deb_package
elif [ "$package_build_name" == "others" ]; then
    pack_tros_packages
elif [ "$package_build_name" == "tros" ]; then
    create_tros_deb_package
elif [ "$package_build_name" == "all" ]; then
    build_ros_base
    create_ros_base_deb_package
    pack_tros_packages
    create_tros_deb_package
else
    if is_string_in_list "$package_build_name" "${deb_build_packages[@]}"; then
        pack_tros_package_select
    else
        echo "Invalid package_name."
        usage
        exit 1
    fi
fi

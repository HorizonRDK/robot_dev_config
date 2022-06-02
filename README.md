# robot_dev_config
## 文件说明
aarch64_toolchainfile.cmake 用于TROS交叉编译

all_build.sh 编译配置脚本，完整编译

clear_COLCON_IGNORE.sh 重制编译配置脚本

Dockerfile_ubuntu20.04_pc 用于制作ubuntu20.04 PC docker镜像

minimal_build.sh 编译配置脚本，最小化编译

minimal_deploy.sh 部署剪裁脚本，用于最小化部署

## 交叉编译说明
### 基于ubuntu20.04 docker
1. 本地创建开发目录结构，获取源码。这里以/mnt/data/kairui.wang/test为例
```
## 创建目录
cd /mnt/data/kairui.wang/test
mkdir -p cc_ws/tros_ws/src
cd cc_ws/tros_ws
## 获取配置文件
git clone http://gitlab.hobot.cc/robot_dev_platform/robot_dev_config.git -b develop
## 安装vcs工具
sudo pip install -U vcstool 
## 拉取代码
vcs-import src < ./robot_dev_config/ros2.repos 
## 拷贝sysroot
cd ../
cp tros_ws/robot_dev_config/sysroot_docker.tar.gz .
tar -xvf sysroot_docker.tar.gz
```
整个工程目录结构如下
```
├── cc_ws
│   ├── sysroot_docker
│   │   ├── etc
│   │   ├── lib -> usr/lib
│   │   ├── opt
│   │   └── usr
│   └── tros_ws
│       ├── robot_dev_config
│       └── src
```
**注意：目录结构需要保持一致**

**注意：vcs import过程中打印.表示成功拉取repo，如果打印E表示该repo拉取失败可以通过执行后的log看到具体失败的repo，碰到这种情况可以尝试删除src里面的内容重新vcs import或者手动拉取失败的repo**

2. 使用docker镜像
```
## 加载docker镜像
docker load --input ubuntu20.04_tros.tar
## 查看对应的image ID
docker images
## 启动docker挂载目录
docker run -it --rm --entrypoint="/bin/bash" -v PC本地目录:docker目录 imageID，这里以docker run -it --rm --entrypoint="/bin/bash" -v /mnt/data/kairui.wang/test:/mnt/test 725ec5a56ede 为例
```

3. 交叉编译。该步骤均在docker中完成
```
## 配置交叉编译工具链
export TARGET_ARCH=aarch64
export TARGET_TRIPLE=aarch64-linux-gnu
export CROSS_COMPILE=/usr/bin/$TARGET_TRIPLE-
cd /mnt/test/cc_ws/tros_ws
## 清除配置选项
./robot_dev_config/clear_COLCON_IGNORE.sh
## 配置编译选项，若需要最小化部署包则使用minimal_build.sh
./robot_dev_config/all_build.sh
## 开始编译
colcon build \
  --merge-install \
  --cmake-force-configure \
  --cmake-args \
    --no-warn-unused-cli \
    -DCMAKE_TOOLCHAIN_FILE=`pwd`/robot_dev_config/aarch64_toolchainfile.cmake \
    -DTHIRDPARTY=ON \
    -DBUILD_TESTING:BOOL=OFF \
    -DCMAKE_BUILD_RPATH="`pwd`/build/poco_vendor/poco_external_project_install/lib/;`pwd`/build/libyaml_vendor/libyaml_install/lib/"
```

**注意：编译过程中，要确保同一个终端中执行olcon build命令之前已执行执行export环境变量命令**

编译成功后会提示总计N packages编译通过

4. 简单验证

将编译生成的install目录放入开发板中（开发板ubuntu20.04环境）

打开一个terminator
```
source ./local_setup.bash
ros2 run examples_rclcpp_minimal_publisher publisher_member_function
```
打开另一个terminator
```
source ./local_setup.bash
ros2 run examples_rclcpp_minimal_subscriber subscriber_member_function
```
可以看到subscriber已经收到了消息

5. 最小部署包

量产环节为了节省ROM和RAM空间，需要对TROS进行最小化剪裁

这里分为两个步骤：

  第4步配置编译选项，使用minimal_build.sh；

  第4步编译完成后得到install目录，执行./minimal_deploy.sh -d install_path

6. FAQ
Q: git获取代码重复提示输入账户、密码
A: 
```
apt install ssh
ssh-keygen -t rsa -C 'xxx@e-mail.com'
gitlab添加pub key
git config --global credential.helper store
```
尝试拉一个repo，输入账户密码，后面不再需要重复输入密码

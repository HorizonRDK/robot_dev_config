# robot_dev_config
## 文件说明

build.sh 编译脚本

aarch64_toolchainfile.cmake 用于TROS交叉编译

all_build.sh x3编译配置脚本，完整编译

j5_build.sh j5编译配置脚本，完整编译

x86_build.sh x86编译配置脚本，完整编译

clear_COLCON_IGNORE.sh 重制编译配置脚本

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
git clone https://c-gitlab.horizon.ai/HHP/robot_dev_config.git -b develop
## 安装vcs工具
sudo pip install -U vcstool 
## 拉取代码
vcs-import src < ./robot_dev_config/ros2.repos 
```
整个工程目录结构如下
```
├── cc_ws
│   ├── sysroot_docker
│   │   ├── etc
│   │   ├── lib -> usr/lib
│   │   ├── opt
│   │   ├── usr_j5
│   │   ├── usr_x3
│   │   └── usr_x86
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
## 切到编译路径下
cd /mnt/test/cc_ws/tros_ws

## 使用build.sh脚本编译，通过-p选项指定编译平台[X3|J5|X86]
## 例如编译X3平台TROS的命令为
bash robot_dev_config/build.sh -p X3

**注意：编译过程中，要确保同一个终端中执行colcon build命令之前已执行执行export环境变量命令**

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

6. 编译deb安装包

交叉编译完成后，在tros_ws路径下编译deb安装包。

前置条件：编译环境已安装jq（`sudo apt-get install jq`）

编译X3平台deb安装包：

```shell

bash robot_dev_config/deploy/build_binary.sh -p X3 -t tros -b install

```

编译X3平台hobbot_audio deb安装包:

```shell

bash robot_dev_config/build.sh -p X3 -s hobot_audio

更新deploy/tros_hobot_audio/DEBIAN/control和deploy/build_extern_binary.sh中的版本信息

bash robot_dev_config/deploy/build_extern_binary.sh tros_hobot_audio

```

编译X3平台orb_slam3 deb安装包:

```shell

bash robot_dev_config/build.sh -p X3 -s orb_slam3_example_ros2

更新deploy/tros_orb_slam3/DEBIAN/control和deploy/build_extern_binary.sh中的版本信息

bash robot_dev_config/deploy/build_extern_binary.sh tros_orb_slam3

```

编译X3平台performance_test deb安装包:

```shell

bash robot_dev_config/build.sh -p X3 -s performance_test

更新deploy/tros_performance_test/DEBIAN/control和deploy/build_extern_binary.sh中的版本信息

bash robot_dev_config/deploy/build_extern_binary.sh tros_performance_test

```


编译X86平台deb安装包：

```shell

bash robot_dev_config/deploy/build_binary.sh -p X86 -t tros -b install

```

7. FAQ
Q: git获取代码重复提示输入账户、密码
A: 
```
apt install ssh
ssh-keygen -t rsa -C 'xxx@e-mail.com'
gitlab添加pub key
git config --global credential.helper store
```
尝试拉一个repo，输入账户密码，后面不再需要重复输入密码

## 单元测试说明
1. 通过build.sh编译脚本的-g选项打开测试用例的编译，例如打开X3平台的测试用例编译
```
./robot_dev_config/build.sh -p X3 -g ON
```

2. 单元测试需要推送到开发板上运行，且推送到开发板上的路径需要与交叉编译的路径保持一致。

3. 使用run_gtest.sh脚本运行单元测试，默认进行所有package的单元测试。用户可通过选项-s选择单独的package进行测试。例如
```
./robot_dev_config/run_gtest.sh -s rclcpp
```
运行结束后，会统计测试结果，并输出出现错误的测试case以及错误信息。

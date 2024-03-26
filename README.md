English| [简体中文](./README_cn.md)

# robot_dev_config

## Overview

Introduce how to fetch the code for [TogetheROS.Bot](https://developer.horizon.ai/api/v1/fileData/documents_tros/index.html), requirements and setup of cross-compilation development environment, code compilation, and package deployment instructions.

## File Description

build.sh Compilation script

aarch64_toolchainfile.cmake Used for TROS cross-compilation

all_build.sh x3 compilation configuration script, complete compilation

rdkultra_build.sh rdkultra compilation configuration script, complete compilation

x86_build.sh x86 compilation configuration script, complete compilation

clear_COLCON_IGNORE.sh Reset compilation configuration script

minimal_build.sh Compilation configuration script, minimal compilation

minimal_deploy.sh Deployment clipping script, used for minimal deployment

build_deb.sh Application independent packaging script

## Cross-Compilation Instructions

### Based on ubuntu20.04 docker

1. Create a development directory structure locally, and fetch the source code. Here take /mnt/data/test as an example

```bash
## Create directory
cd /mnt/data/test
mkdir -p cc_ws/tros_ws/src
cd cc_ws/tros_ws
## Get configuration files
git clone https://github.com/HorizonRDK/robot_dev_config.git -b develop
## Install vcs tool
sudo pip install -U vcstool 
## Fetch code
vcs-import src  < ./robot_dev_config/ros2.repos 
```

The entire project directory structure is as follows

```text
├── cc_ws
│   ├── sysroot_docker```bash
│   │   ├── etc
│   │   ├── lib -> usr/lib
│   │   ├── opt
│   │   ├── usr_rdkultra
│   │   ├── usr_x3
│   │   └── usr_x86
│   └── tros_ws
│       ├── robot_dev_config
│       └── src
```
**Note: The directory structure needs to be consistent**

**Note: During the VCS import process, printing `.` indicates a successful pull of the repo. If printing E indicates a failed pull of the repo, the specific failed repo can be seen in the executed log. In this case, you can try deleting the content in the src to re import VCS or manually pull the failed repo**

2. Use docker image

```bash
## Get docker for cross compilation
wget http://sunrise.horizon.cc/TogetheROS/cross_compile_docker/pc_tros_v1.0.5.tar.gz
## Load docker image
docker load --input pc_tros_v1.0.5.tar.gz
## Check corresponding image ID
docker images
## Start docker with mounted directories, docker run -it --rm --entrypoint="/bin/bash" -v Local directory in PC:Directory in docker image imageID
docker run -it --rm --entrypoint="/bin/bash" -v /mnt/data/test:/mnt/test 725ec5a56ede
```

3. Cross compilation. This step is completed in the docker environment

```bash
## Navigate to the build path
cd /mnt/test/cc_ws/tros_ws

## Compile using build.sh script, specify the platform to compile for using the -p option [X3|Rdkultra|X86]
## For example, to compile TROS for X3 platform, execute the following command
bash robot_dev_config/build.sh -p X3
```

**Note: During the compilation process, make sure to export the environment variable in the same terminal before executing the colcon build command.**

Upon successful compilation, you will see a message indicating the total N packages have been successfully compiled.

4. Simple verification

Copy the generated install directory to the development board (Ubuntu 20.04 environment on the development board)

Open a terminator
```bash
source ./local_setup.bash
ros2 run examples_rclcpp_minimal_publisher publisher_member_function
```

Open another terminator

```bash

source ./local_setup.bash
ros2 run examples_rclcpp_minimal_subscriber subscriber_member_function

```

Subscriber has received the message successfully.

5. Minimum Deployment Package

In order to save ROM and RAM space during mass production, it is necessary to minimize the TROS deployment. This process consists of two steps:

Step 1: The configuration compilation option in step 4 uses minimal_build.sh;

Step 2: After the step 4 of compilation is completed, obtain the install directory and execute ./minimal_deploy.sh -d install_path

6. Compile Deb Installation Package

Use build_deb.sh to compile the deb installation package. It is recommended to do this in a separate project directory, rather than in the development debugging project directory. The packaging script will automatically compile the package, so there is no need to run the compilation script before packaging.

The script reads information such as name, version, description, maintainer, and dependencies from the source package.xml file. It is important to modify this information when submitting or updating the source code. Instructions for using the script:

```text
Usage: ./robot_dev_config/build_deb.sh platform package_name
  platform: One of x3, rdkultra, or x86
  package_name: ros-base, tros, others, all, or select package name
```

Where:

platform: the compilation platform, supports x3, rdkultra, and x86
package_name: supports the following options:
- ros-base: includes basic packages related to ros2
- tros: integrates all packages into one installation package, which depends on all installation packages generated on the current platform
- others: packages all installation packages except ros-base
- all: packages all installation packages on the current platform
- select package name: specific package to be packed, the source code of this package must be in the src directory, generally used to update software packages individually

Note:

- When packaging ros-base or tros, you need to modify the version number in build_deb.sh. The version number for tros is defined using the variable tros_package_version, while for ros-base it is ros_base_package_version.
- When packaging a single package individually, make sure that the package dependencies have been packaged. The script currently does not automatically package dependent packages.

7. FAQ

Q: Repeated prompts for username and password when fetching code from git

A:

```bash
git config --global credential.helper store
```

Try pulling a repo, input your Username and Password (the Password is not your GitHub account password but a personal access token). Afterwards, you won't need to repeatedly enter the password. Reference the GitHub official documentation [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) for guidance on creating a token.

## Unit Test Instructions

1. Use the -g option in the build.sh compilation script to enable the compilation of test cases, for example, to enable the compilation of test cases for the X3 platform:

```bash
./robot_dev_config/build.sh -p X3 -g ON
```

2. Unit tests need to be pushed to the development board for execution, and the path where they are pushed on the development board needs to be consistent with the cross-compiled path.

3. Use the run_gtest.sh script to run unit tests, by default it runs unit tests for all packages. Users can use the -s option to select a specific package for testing. For example:

```bash
./robot_dev_config/run_gtest.sh -s rclcpp
```

After completion, the test results will be summarized, and any failed test cases along with error information will be output.

## Version Information

- tros_1.1.6 and earlier versions in the 1.x series require the use of the corresponding 1.x version system image.
- tros_2.0.0 and other 2.x versions require the use of the matching 2.x version system image.

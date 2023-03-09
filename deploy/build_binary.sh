#!/bin/bash

# Build an archive with a template directory

#*******************
platform=X3
Architecture=arm64
Package=tros
template=""
binary=""
tmp_dir=./tmp
#*******************

function show_usage() {
cat <<EOF

Usage: bash -e $0 <options>
available options:
-p|--platform: set platform ([X3|J5|X86])
-t|--template: set template ([tros|hobot_audio|...])
-b|--binary: set binary directory ([./install/|./install_hobot_audio|...])
-h|--help
Example: bash -e $0 -p X3 -t tros -b install
EOF
exit
}

echo "input para num $#"
if [ $# -lt 6 ];then
   show_usage
fi

# 1. parse paras from inputs
PLATFORM_OPTS=(X3 J5 X86)
GETOPT_ARGS=`getopt -o p:t:b:h -al platform:,template:,binary:,help -- "$@"`
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
    -t|--template)
      template=$2
      shift 2
      ;;
    -b|--binary)
      binary=$2
      shift 2
      ;;
    -h|--help) show_usage; break;;
    --) break ;;
    *) echo $1,$2 show_usage; break;;
  esac
done

if [ $platform == "X86" ]; then
  echo "build X86"
  Architecture=amd64
else
  if [ $platform == "X3" ]; then
    echo "build X3"
    Architecture=arm64
  elif [ $platform == "J5" ]; then
    echo "build J5"
    Architecture=arm64
  fi
fi

bash_dir=`dirname ${BASH_SOURCE[0]}`

echo "template: $template"
echo "binary: $binary"
echo "bash_dir: $bash_dir"

# 2. parse paras from config file
Version=`jq .tros.Version ${bash_dir}/version_dsc.json | tr -d '"'`
Depends=`jq .tros.${platform}.Depends[] ${bash_dir}/version_dsc.json | sed ':x;N;s/\n/, /g;tx' | tr -d '"'`

echo "Version: $Version"
echo "Depends: $Depends"
echo "Architecture: $Architecture"

# set -x
# 3. backup files in tmp dir
if [ -e ${tmp_dir}/${template} ]; then
  echo "backup file ${tmp_dir}/${template}"
  mkdir -p backup
  mv ${tmp_dir}/${template} backup/${template}_`date +%Y-%m-%d_%H_%M_%S`
fi

# 4. copy template to tmp dir
mkdir -p ${tmp_dir}
cp -r ${bash_dir}/${template}_${platform} ${tmp_dir}/${template}

# 5. update infos in template
sed -i "s#^Version:.*#Version: ${Version}#g" ${tmp_dir}/${template}/DEBIAN/control
sed -i "s#^Depends:.*#Depends: ${Depends}#g" ${tmp_dir}/${template}/DEBIAN/control
sed -i "s#^Architecture:.*#Architecture: ${Architecture}#g" ${tmp_dir}/${template}/DEBIAN/control
sed -i "s#^Date:.*#Date: `date +%Y-%m-%d_%H_%M_%S`#g" ${tmp_dir}/${template}/DEBIAN/control

# 6. copy binary to template
cp -r $binary/* ${tmp_dir}/${template}/opt/${template}/
if [ $? != 0 ]; then
 exit
fi

# 7. update deps of binary in template
bash ${bash_dir}/install_deps_setup.sh ${tmp_dir}/${template}/opt/${template}

# 8. update BSP version checking script in binary
if [ `jq .tros.${platform} ${bash_dir}/version_dsc.json | jq 'has("BSP")'` == true ]; then
  cp ${bash_dir}/check_version.sh ${tmp_dir}/${template}/opt/${template}
  depend_bsp_version=`jq .tros.${platform}.BSP ${bash_dir}/version_dsc.json | tr -d '"'`
  echo "check BSP version: ${depend_bsp_version} for ${platform}"
  echo -e "\n# check bsp version\nbash \`dirname "\${BASH_SOURCE[0]}"\`/check_version.sh ${depend_bsp_version}" >> ${tmp_dir}/${template}/opt/${template}/setup.bash
else
  echo "version_dsc.json has no key of BSP for ${platform}"
fi

# 9. build package
dpkg -b ${tmp_dir}/${template} ${Package}_${Version}_${Architecture}.deb
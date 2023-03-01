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
      echo "launch $selction gtest cases"
      PACKAGE_SELECTION="$selction"
      ;;
    -h|--help) show_usage; break;;
     --) break ;;
     *) echo $1,$2 show_usage; break;;
  esac
done

total_gtest=0
fault_gtest_num=0
passed_gtest_num=0
fault_gtest_case=""

find_path=`find ./lib/${PACKAGE_SELECTION} -name gtest_*`
arr=(${find_path// / })

for i in ${arr[@]}
do
    total_gtest=$((total_gtest+1))
    echo ${i}
    $i
    if [ $? != 0 ]
    then
	    fault_gtest_num=$((fault_gtest_num+1))
	    fault_gtest_case="${fault_gtest_case}"$'\n'
	    fault_gtest_case="${fault_gtest_case}${i}"
    else
        passed_gtest_num=$((passed_gtest_num+1))
    fi
done

passed_rate=$(echo "scale=4; (${passed_gtest_num}/${total_gtest}) * 100" | bc)

echo "------------------------------------------------------------------------------"
echo "本次测试结果："
echo "总用例数: ${total_gtest}"
echo "通过用例：${passed_gtest_num}"
echo "失败用例：${fault_gtest_num}"
echo "通过率(%): ${passed_rate}"
if [ $fault_gtest_num != 0 ]
then
    echo "运行失败用例列举: ${fault_gtest_case}"
fi

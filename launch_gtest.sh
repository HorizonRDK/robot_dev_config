#!/bin/bash

source ./setup.bash
total_gtest=0
fault_gtest_num=0
passed_gtest_num=0
fault_gtest_case=""
error_info="error"

find_path=`find ./lib/ -name gtest_*`
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

echo "----------------------------------------"
echo "本次测试结果："
echo "总用例数: ${total_gtest}"
echo "通过用例：${passed_gtest_num}"
echo "失败用例：${fault_gtest_num}"
echo "通过率(%): ${passed_rate}"
if [ $fault_gtest_num != 0 ]
then
    echo "运行失败用例列举: ${fault_gtest_case}"
fi

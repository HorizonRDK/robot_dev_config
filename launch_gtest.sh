#!/bin/bash

source install/setup.bash
total_gtest=0
fault_gtest_num=0
fault_gtest_case=""
error_info="error"

find_path=`find install/lib/ -name gtest_*`
arr=(${find_path// / })

for i in ${arr[@]}
do
    total_gtest=$((total_gtest+1))
    echo ${i}
    $i
    if [ $? != 0 ]
    then
	fault_gtest_num=$((fault_gtest_num+1))
	fault_gtest_case="${fault_gtest_case}${i}\n"
    fi
done

echo "total gtest case num: ${total_gtest}"
echo "fault gtest case num: ${fault_gtest_num}"

if [ $fault_gtest_num != 0 ]
then
    echo "fault gtest case: ${fault_gtest_case}"
fi


#pwd_path=`pwd`

#result=`date`

#echo ${find_path}

#echo $pwd_path

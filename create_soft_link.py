from ast import arg
import os
from re import I
import shutil
import argparse
# 必须是绝对路径


def diff_file(path1, path2):
    fileName1 = set([_ for _ in os.listdir(path1)])
    fileName2 = set([_ for _ in os.listdir(path2)])
    sames = fileName1.intersection(fileName2)
    diffs = fileName1.difference(fileName2)
    for i in sames:
        filePath1 = os.path.join(path1, i)
        filePath2 = os.path.join(path2, i)
        sys_command = 'symlinks -d ' + filePath2
        if os.path.isdir(filePath1):
            os.system(sys_command)
            diff_file(filePath1, filePath2)
    for i in diffs:
        filePath1 = os.path.join(path1, i)
        filePath2 = os.path.join(path2, i)
        if not os.path.exists(filePath2):
            os.symlink(filePath1, filePath2)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Parse input parameters')
    parser.add_argument(
                        "--foxy", type=str, required=True,
                        help="Absolute path of ros2 foxy.\
                            Usually is /opt/ros/foxy")
    parser.add_argument("--tros", type=str, required=True,
                        help="Absolute path of tros. \
                            Usually is /opt/tros")
    args = parser.parse_args()

    ros_path = args.foxy
    tros_path = args.tros
    if not os.path.exists(ros_path):
        print('Ros2 foxy path no exist!')
        os._exit()
    if not os.path.exists(ros_path):
        print('Ros2 foxy path no exist!')
        os._exit()
    if ros_path[0] != '/':
        print('ros foxy path shoule be absoute path starting with /')
        os._exit()
    if tros_path[0] != '/':
        print('tros_path path shoule be absoute path starting with /')
        os._exit()
    print("ros2 foxy path is: "+ros_path)
    print("tros path is: "+tros_path)
    diff_file(ros_path, tros_path)

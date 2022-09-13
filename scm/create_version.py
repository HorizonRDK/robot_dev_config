#!/usr/bin/python

import os
import argparse
import json
import time
import platform
import subprocess


class CreateVersion(object):
    def __init__(self, name):
        self.version = dict()
        self.name = name
        self.version[self.name] = dict()
        self.version[self.name]['branch_name'] = None
        self.version[self.name]['commit_id'] = None
        self.version[self.name]['tag'] = None
        self.version[self.name]['tag_time'] = None

    def create(self):
        if 'GIT_BRANCH' in os.environ.keys():
            self.version[self.name]['branch_name'] = os.environ['GIT_BRANCH']
        if 'GIT_COMMIT' in os.environ.keys():
            self.version[self.name]['commit_id'] = os.environ['GIT_COMMIT']
        if 'TAG_NAME' in os.environ.keys():
            self.version[self.name]['tag'] = os.environ['TAG_NAME']
            cmd_git = subprocess.Popen([
                                        "git",
                                        "branch",
                                        "-a",
                                        "--contains",
                                        os.environ['TAG_NAME']
                                        ], stdout=subprocess.PIPE)
            cmd_git_output = cmd_git.communicate()[0].decode()
            self.version[self.name]['branch_name'] = cmd_git_output.split(
                                                     )[-1].split(
                                                     '/'
                                                     )[-1].strip()
        if 'TAG_DATE' in os.environ.keys():
            if platform.python_version() > '3':
                self.version[self.name]['tag_time'] = time.strftime(
                    "%Y%m%d",
                    time.strptime(os.environ['TAG_DATE'],
                                  "%a %b %d %H:%M:%S %Z %Y"))
            else:
                self.version[self.name]['tag_time'] = time.strftime(
                    "%Y%m%d",
                    time.strptime(os.environ['TAG_DATE'],
                                  "%a %b %d %H:%M:%S CST %Y"))
        print(self.version)
        f_obj = open('version', 'w')
        json.dump(self.version, f_obj)
        f_obj.close()
        open('version', 'a').write('\n')


def main():
    parser = argparse.ArgumentParser(description='create version file')
    parser.add_argument(
        '-n', '--name', metavar=str(), required=True,
        help="input module name", type=str)
    args = parser.parse_args()
    process = CreateVersion(args.name)
    process.create()

if __name__ == "__main__":
    main()

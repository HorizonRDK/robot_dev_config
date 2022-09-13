import gitlab
import yaml
import threading
import os
import subprocess
import shutil
import sys
import logging

logging.basicConfig(level=logging.INFO, format=' %(asctime)s - %(levelname)s - %(message)s')

try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper

class SyncBranch():
    def __init__(self):
        self.gl = gitlab.Gitlab.from_config('trigger', [os.path.expanduser("python-gitlab.cfg")])
        self.gl.auth()
        self.sync_conf = 'sync_conf.yml'
        self.sync_list = self.read_yaml()
        self.sync_thread_num = 5
        self.tmp_repo = 'tmp_repo'
        self.exec_result = True

    def read_yaml(self):
        f_obj = open(self.sync_conf, 'r')
        f_obj_data = f_obj.read()
        yaml_data = yaml.load(f_obj_data, Loader=Loader)
        f_obj.close()
        return yaml_data

    def remove_folder(self, folder):
        if os.path.exists(folder):
            shutil.rmtree(folder)

    def run_thread(self, name):
        repo_folder = self.tmp_repo + '/' + name
        while True:
            try:
                one_sync = self.sync_list.pop()
            except Exception as e:
                print(e)
                if len(self.sync_list) == 0:
                    break
                continue
            self.remove_folder(repo_folder)
            try:
                proposer = one_sync['sync']['proposer']
                project = one_sync['sync']['project']
                src_repo = one_sync['sync']['src_repo']
                src_branch = one_sync['sync']['src_branch']
                dst_repo = one_sync['sync']['dst_repo']
                dst_branch = one_sync['sync']['dst_branch']
            except Exception as e:
                print(e)
                self.exec_result = False
                continue
            # temp rule
            if dst_repo.find('gitlab.hobot.cc:ptd/') > 0:
                continue
            command_git_clone = 'git clone -b %s %s %s' % (src_branch, src_repo, repo_folder)
            logging.info("git clone -b {} {} {}".format(src_branch, src_repo, repo_folder))
            if not self.runcmd(command_git_clone, dst_repo, dst_branch):
                continue
            command_add_remote = 'cd %s;git remote add upstream %s' % (repo_folder, dst_repo)
            logging.info('cd {};git remote add upstream {}'.format(repo_folder, dst_repo))
            if not self.runcmd(command_add_remote, dst_repo, dst_branch):
                continue
            command_fetch_upstream = 'cd %s;git fetch upstream' % (repo_folder)
            logging.info('cd {};git fetch upstream'.format(repo_folder))
            if not self.runcmd(command_fetch_upstream, dst_repo, dst_branch):
                continue
            command_set_upstream = 'cd %s;git branch %s --set-upstream-to=upstream/%s' % (repo_folder, src_branch, dst_branch)
            logging.info('cd {};git branch {} --set-upstream-to=upstream/{}'.format(repo_folder, src_branch, dst_branch))
            if not self.runcmd(command_set_upstream, dst_repo, dst_branch):
                continue
            command_set_upstream = 'cd %s;git branch -m %s' % (repo_folder, dst_branch)
            logging.info('cd {};git branch -m {}'.format(repo_folder, dst_branch))
            if not self.runcmd(command_set_upstream, dst_repo, dst_branch):
                continue
            command_push_force = 'cd %s;git push -f upstream %s' % (repo_folder, dst_branch)
            logging.info('cd {};git push -f upstream {}'.format(repo_folder, dst_branch))
            if not self.runcmd(command_push_force, dst_repo, dst_branch):
                continue 

    def runcmd(self, command, dst_repo, dst_branch):
        #print('run cmd---- ', command)
        try:
            ret = subprocess.run(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        except Exception as e:
            print(e)
            self.exec_result = False
            return False
        if ret.returncode != 0:
            #print('error', command, ret.stdout)
            logging.error("error:",command, ret.returncode)
            logging.error("error: dst repo: {}, dst branch: {}, sync failed".format(dst_repo, dst_branch))
            #sys.exit(1)
            self.exec_result = False
            return False
        return True

    def parse_yaml_thread(self):
        self.remove_folder(self.tmp_repo)
        os.mkdir(self.tmp_repo)
        threadLock = threading.Lock()
        threads = list()
        for i in range(self.sync_thread_num):
            tr = threading.Thread(target=self.run_thread, args=(str(i)))
            threads.append(tr)
        for i in threads:
            i.start()
        for i in threads:
            i.join()

def main():
    sync_branch = SyncBranch()
    sync_branch.parse_yaml_thread()
    if not sync_branch.exec_result:
        print('exec fail')
        sys.exit(1)

if __name__ == "__main__":
    main()

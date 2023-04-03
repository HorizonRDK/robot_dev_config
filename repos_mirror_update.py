import json
import os

jsondata = [
  {
    "repo_name": "test_mirror",
    "github": "https://github.com/HorizonRoboticsRDK/test_mirror.git",
    "gitlab": "https://c-gitlab.horizon.ai/HHP/test_mirror.git"
  },
  {
    "repo_name": "test_mirror_1",
    "github": "https://github.com/HorizonRoboticsRDK/test_mirror_1.git",
    "gitlab": "https://c-gitlab.horizon.ai/HHP/test_mirror_1.git"
  },
  {
    "repo_name": "test_mirror_2",
    "github": "https://github.com/HorizonRoboticsRDK/test_mirror_2.git",
    "gitlab": "https://c-gitlab.horizon.ai/HHP/test_mirror_2.git"
  }
]

usrname="zhenwei.liu"
password="555666Ding"

if __name__ == '__main__':
  datalist = json.loads(str(jsondata).replace("\'","\""))
  mirror_failed=""
  os.mkdir("mirror_dir")
  current_path = os.getcwdb()
  mirror_dir=current_path + b"/mirror_dir"
  print(mirror_dir)
  os.chdir(mirror_dir)
  fo = open("mirroring.log", "w+")
  for data in datalist:
    repo_name=data['repo_name']
    github_url=data['github']
    gitlab_url=data['gitlab']
    os.chdir(mirror_dir)
    os.environ['HTTP_PROXY']='10.9.1.251:8838'
    os.environ['HTTPS_PROXY']='10.9.1.251:8838'
    pull_command="git clone --bare " + github_url
    print(pull_command)
    ret_pull=os.system(pull_command)
    if ret_pull != 0:
      continue
    repo_dir=repo_name + ".git"
    os.chdir(repo_dir)
    push_command="git push --mirror " + gitlab_url[:8] + usrname + ":" + password + "@" + gitlab_url[8:]
    print(push_command)
    os.unsetenv("HTTP_PROXY")
    os.unsetenv("HTTPS_PROXY")
    ret_push=os.system(push_command)
    if ret_push != 0:
      mirror_failed=mirror_failed+repo_name+"、"
  if mirror_failed != "":
    mirror_failed=mirror_failed.rstrip('、')
    print("同步失败的repo: %s"%(mirror_failed))
  fo.write(mirror_failed)
  fo.close()

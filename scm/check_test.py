import requests
import sys

data = dict()
data['api.token'] = 'cli-yikagulvgpkmb45qz2m6qs6qcmi7'
data['revisionIDs[0]'] = str(sys.argv[1])

data2 = dict()
data2['api.token'] = 'cli-yikagulvgpkmb45qz2m6qs6qcmi7'
data2['ids[0]'] = str(sys.argv[1])

url = 'https://cr.hobot.cc/api/differential.querydiffs'
result = requests.post(url, data=data)
result_data = result.json()

url2 = 'https://cr.hobot.cc/api/differential.query'
result2 = requests.post(url2, data=data2)
result_data2 = result2.json()

src = False
test = False
test_flag = False
for ph_id, diff in result_data['result'].items():
    print('ph_id', ph_id)
    for change in diff['changes']:
        change_type = int(change['type'])
        change_path = change['currentPath']
        print(change_type, change_path)
        if change_path.find('src/') == 0:
            src = True
            continue
        if change_path.find('test/') == 0:
            test = True
            continue
    if type(diff['properties']) is dict:
        for commit, commit_data in diff['properties']['local:commits'].items():
            print('sha-1', commit)
            index_start = commit_data['message'].find('Test Plan:')
            index_end = commit_data['message'].find('Reviewers:')
            if index_start < 1:
                print('cant find Test Plan,igonre check')
                continue
            if index_end > index_start:
                test_plan = commit_data['message'][index_start:index_end]
            else:
                test_plan = commit_data['message'][index_start:]
            print(test_plan)
            if test_plan.lower().find('notest') > 0:
                test_flag = True

if 'result' in result_data2.keys():
    for data in result_data2['result']:
        if 'testPlan' in data.keys():
            print(data['testPlan'])
            print(data['testPlan'].lower().find('notest'))
            if data['testPlan'].lower().find('notest') >= 0:
                test_flag = True

if test_flag:
    print('hiting notest flag, ignore src test check')
    sys.exit(0)

if src and not test:
    print('src changes,no change in test')
    sys.exit(1)
sys.exit(0)

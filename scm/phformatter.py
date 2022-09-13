import logging
from logging.handlers import RotatingFileHandler
import sys
import os
import argparse
import json

REAL_PATH = os.path.dirname(os.path.realpath(__file__))
# logger_level = logging.DEBUG
logger_level = logging.INFO

logger = logging.getLogger(__name__)
logger.setLevel(level=logger_level)
rHandler = RotatingFileHandler(os.path.join(REAL_PATH, 'log.txt'))
rHandler.setLevel(logger_level)
formatter = logging.Formatter(
    "%(asctime)s %(pathname)s func: %(funcName)s \
    line: %(lineno)s %(levelname)s - %(message)s",
    "%Y-%m-%d %H:%M:%S")
rHandler.setFormatter(formatter)

console = logging.StreamHandler()
console.setLevel(logger_level)
console.setFormatter(formatter)

logger.addHandler(rHandler)
logger.addHandler(console)


class PhabricatorFormatter(object):
    def __init__(self, cfg_file):
        self.cfg_file = cfg_file

    def formatter(self):
        datastore = open(self.cfg_file, 'r').readlines()
        w_file_name = os.path.join(REAL_PATH, 'phabricator.json')
        output = list()
        logger.info(w_file_name)
        for line in datastore:
            for file_path, data in json.loads(line).items():
                for one_data in data:
                    tmp_one_data = one_data
                    tmp_one_data['path'] = file_path
                    if not one_data['char']:
                        tmp_one_data['char'] = 0
                    output.append(json.dumps(tmp_one_data))
        open(w_file_name, 'w').write('\n'.join(output))


def main():
    parser = argparse.ArgumentParser(description='input ph json file')
    parser.add_argument(
        '-c', '--config_py', metavar=str(), required=True,
        help="input absolute path of the yaml configuration file", type=str)
    args = parser.parse_args()
    logger.info('absolute path is %s' % args.config_py)
    process = PhabricatorFormatter(args.config_py)
    process.formatter()

if __name__ == "__main__":
    main()

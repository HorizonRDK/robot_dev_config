# coding:utf-8
import logging
from logging.handlers import RotatingFileHandler
import sys
import yaml
import os
import argparse
import requests
import json
from requests_toolbelt import MultipartEncoder

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


class GalleryUpload(object):
    def __init__(self, cfg_file):
        self.cfg_file = cfg_file
        self.cfg_runtime = None
        self.token = None

    def read_cfg_file(self):
        if not os.path.isfile(self.cfg_file):
            logger.error('file not exist %s' % self.cfg_file)
            sys.exit(1)
        cfg_source = open(self.cfg_file, 'r').read()
        logger.debug(cfg_source)
        logger.info('******[parse cfg file]******')
        try:
            cfg_runtime = yaml.safe_load(cfg_source)
        except Exception as e:
            logger.error(e)
            sys.exit(1)
        logger.debug(cfg_runtime)
        self.cfg_runtime = cfg_runtime
        logger.info(self.cfg_runtime)

    def auth(self):
        attempts = 0
        success = False
        while attempts < 3 and not success:
            try:
                logger.info('auth')
                r = requests.post(
                    'http://gallery.hobot.cc/api/auth/token-create',
                    json=self.cfg_runtime['auth'])
                token = json.loads(r.content.decode('utf-8'))
                logger.info(token)
                if r.status_code != 200:
                    logger.error('auth fail')
                logger.info('refresh token')
                r = requests.post(
                    'http://gallery.hobot.cc/api/auth/token-refresh',
                    json=token)
                logger.info(r.json())
                if r.status_code != 200:
                    logger.error('token refresh fail')
                logger.info('verify token')
                r = requests.post(
                    'http://gallery.hobot.cc/api/auth/token-verify',
                    json=token)
                logger.info(r.json())
                if r.status_code != 200:
                    logger.error('token verify fail')
                self.token = r.json()
                success = True
            except Exception as e:
                attempts += 1
                if attempts == 3:
                    logger.error(e)
                    sys.exit(1)

    def upload(self):
        try:
            upload_cfg = self.cfg_runtime
            del upload_cfg['auth']
            upload_cfg['file'] = (
                upload_cfg['file'], open(upload_cfg['file'], 'rb'),
                'text/plain')
            # upload_cfg['filename'] =
            # '-'.join([upload_cfg['project'],upload_cfg['version']]) + '.zip'
            upload_cfg['filename'] = 'file.tar.gz'
            logger.info(upload_cfg)
            multipart_data = MultipartEncoder(fields=upload_cfg)
            header_data = {
                'Content-Type': multipart_data.content_type,
                'Authorization': 'JWT %s' % self.token['token']}
            logger.info(header_data)
            r = requests.post(
                'http://gallery.hobot.cc/api/artifacts',
                data=multipart_data, headers=header_data)
            logger.info(r.json())
            logger.info(r.status_code)
            if not r.json()['ok']:
                logger.error('upload fail')
                sys.exit(1)
        except Exception as e:
            logger.error(e)
            sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description='input configuration yaml')
    parser.add_argument(
        '-c', '--config_yaml', metavar=str(), required=True,
        help="input absolute path of the yaml configuration file", type=str)
    args = parser.parse_args()
    logger.info('absolute path is %s' % args.config_yaml)
    process = GalleryUpload(args.config_yaml)
    process.read_cfg_file()
    process.auth()
    process.upload()

if __name__ == "__main__":
    main()

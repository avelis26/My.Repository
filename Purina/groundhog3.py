#!/usr/bin/env python3
# v1.0.4
# Utility server has python 2.7.12 and 3.6.8
# USAGE:
# UAT   ./tools/groundhog3.py --tgtdb 'groundhog-dev' --logfile '/home/ec2-user/groundhog-dev.log' --debug
# PROD  ./tools/groundhog3.py --tgtdb 'groundhog' --logfile '/home/ec2-user/groundhog.log' --debug
# Cron  0 21 * * * /home/ec2-user/data/profiles.purina.com/deploy/tools/groundhog3.py --tgtdb 'groundhog' --logfile '/home/ec2-user/groundhog.log' &> '/home/ec2-user/groundhog-error.log'
import subprocess
import datetime
import json
import sys
import argparse
import logging
import mysql.connector
from time import sleep
exit_code = 1
#
# Load argument parser to control input and provide automatic help.
#
parser = argparse.ArgumentParser()
parser.add_argument('--tgtdb',
    default='groundhog',
    choices=['groundhog', 'groundhog-dev', 'groundhog-qa', 'groundhog-dw', 'groundhog-ad-hoc'],
    metavar='string',
    help='Please provide the name of the database server you would like to destroy. Choices: groundhog, groundhog-dev, groundhog-qa, groundhog-dw, groundhog-ad-hoc')
parser.add_argument('--logfile',
    default='/home/ec2-user/groundhog.log',
    metavar='string',
    help='Please provide the location of where you want the logs to be stored. Default: /home/ec2-user/groundhog.log')
parser.add_argument('--debug',
    action='store_true',
    help="This flag will set the logging level to 'DEBUG' which will include arguments and commands used.")
args = parser.parse_args()
#
# Load logging module and set basic config options including log output file locaiton.
#
file_handler = logging.FileHandler(filename=str(args.logfile))
stdout_handler = logging.StreamHandler(sys.stdout)
handlers = [file_handler, stdout_handler]
if args.debug == True:
    logging.basicConfig(
        format='%(asctime)s  %(levelname)-8s  %(message)s',
        handlers=handlers,
        level=logging.DEBUG,
        datefmt='%Y-%m-%d %H:%M:%S %Z'
    )
else:
    logging.basicConfig(
        format='%(asctime)s  %(levelname)-8s  %(message)s',
        handlers=handlers,
        level=logging.INFO,
        datefmt='%Y-%m-%d %H:%M:%S %Z'
    )
logging.info('---------------------------- BEGIN ----------------------------')
logging.debug('Python Version..........................: ' + str(".".join(map(str, sys.version_info[:3]))))
logging.info('Target Database Server Name.............: ' + args.tgtdb)
logging.info('........................................: ')
#
# Destroy the target database server.
#
try:
    logging.info("Searching for " + args.tgtdb + " instance...")
    cmd = "aws rds describe-db-instances " + \
        "--query 'DBInstances[*].[DBInstanceIdentifier]' " + \
        "--filters Name=db-instance-id,Values='" + str(args.tgtdb) + "' --output text"
    logging.info("Cmd: [" + cmd + "]")
    result_delete = subprocess.check_output([cmd], shell=True)
    result_delete = result_delete.decode("utf-8")
    if result_delete.rstrip() == str(args.tgtdb):
        logging.info(args.tgtdb + " instance found.")
        logging.info("Starting delete of " + args.tgtdb + " instance...")
        cmd = "aws rds delete-db-instance " + \
            "--db-instance-identifier '" + str(args.tgtdb) + "' " + \
            "--skip-final-snapshot"
        logging.info("Cmd: [" + cmd + "]")
        result_action = subprocess.check_output([cmd], shell=True)
        result_action = result_action.decode("utf-8")
        logging.debug("Result: [" + result_action + "]")
    else:
        exit_code = 0
        logging.info(args.tgtdb + " instance not found.")
        logging.debug('Exit Code: ' + str(exit_code))
        logging.info('----------------------------- END -----------------------------')
        logging.shutdown()
        sys.exit(exit_code)
except:
    logging.exception("Message JM43: Deletion of " + args.tgtdb + " instance has failed!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)
#
# Wait for delete operation to finish.
#
if result_delete.rstrip() == str(args.tgtdb):
    try:
        logging.info("Waiting for existing " + args.tgtdb + " instance to be deleted...")
        cmd = "aws rds describe-db-instances " + \
            "--query 'DBInstances[*].[DBInstanceIdentifier]' " + \
            "--filters Name=db-instance-id,Values='" + str(args.tgtdb) + "' --output text"
        logging.info("Cmd: [" + cmd + "]")
        check = False
        i = 0
        while check == False:
            i += 1
            logging.debug("Delete Check: " + str(i))
            if i == 120:
                break
            result_wait = subprocess.check_output([cmd], shell=True)
            result_wait = result_wait.decode("utf-8")
            if len(result_wait) == 0:
                logging.info("Existing " + args.tgtdb + " instance has been deleted.")
                check = True
                exit_code = 0
            else:
                sleep(60)
        if check == False:
            raise TimeoutError('Error 408 - Request Timeout')
    except:
        logging.exception("Message AD04: Deletion of " + args.tgtdb + " instance has failed!!!")
    finally:
        logging.debug('Exit Code: ' + str(exit_code))
        logging.info('----------------------------- END -----------------------------')
        logging.shutdown()
        sys.exit(exit_code)

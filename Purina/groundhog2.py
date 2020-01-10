#!/usr/bin/env python3
# v1.1.8
# Utility server has python 2.7.12 and 3.6.8
# USAGE: 
# UAT   ./tools/groundhog2.py --tgtdb 'groundhog-dev' --logfile '/home/ec2-user/groundhog-dev.log' --debug
# PROD  ./tools/groundhog2.py --tgtdb 'groundhog' --logfile '/home/ec2-user/groundhog.log' --debug
# Cron  0 9 * * * /home/ec2-user/data/profiles.purina.com/deploy/tools/groundhog2.py --tgtdb 'groundhog' --logfile '/home/ec2-user/groundhog.log' &> '/home/ec2-user/groundhog-error.log'
import subprocess
import datetime
import json
import sys
import argparse
import logging
import mysql.connector
from time import sleep
#
# Setting hard coded variables.
#
exit_code = 1
database_password = '/home/ec2-user/secrets/groundhog.ppk' # File locaiton for database password.
user_list = [
    'agriffin',
    'amoti',
    'bhopkins',
    'bingram',
    'bmerrill',
    'bshorter',
    'cvandusen',
    'ghamirani',
    'jhall',
    'jhill',
    'lspindelilus',
    'mhowell',
    'mkrishna',
    'rduncan',
    'rholloway',
    'rnadegouni',
    'yudaipurwala',
    'htulsani',
    'mblack',
    'alugo',
    'gmioni',
    'oagi',
    'mhammill',
    'hbristol',
    'kboulware',
    'kcharriere',
    'gpinkston'
]
#
# Load argument parser to control input and provide automatic help.
#
parser = argparse.ArgumentParser()
parser.add_argument('--tgtdb',
    default='groundhog',
    choices=['groundhog', 'groundhog-dev', 'groundhog-qa', 'groundhog-dw', 'groundhog-ad-hoc'],
    metavar='string',
    help='Please provide the name of the database server you would like to grant read /write privileges to the user list. Choices: groundhog, groundhog-dev, groundhog-qa, groundhog-dw, groundhog-ad-hoc')
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
# Wait for database to be ready for queries.
#
try:
    file = open(database_password, 'r')
    db_passwd = file.read().rstrip()
    file.close()
except:
    exit_code = 1
    logging.exception("Message MV12: Secrets file (" + database_password + ") not found!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)
check = False
i = 0
while check == False:
    i += 1
    if i == 32:
        break
    try:
        logging.info('Connection Attempt ' + str(i) + ' to ' + args.tgtdb + '.cw3pelk7q4ex.us-east-1.rds.amazonaws.com...')
        mydb = mysql.connector.connect(
            host = args.tgtdb + ".cw3pelk7q4ex.us-east-1.rds.amazonaws.com",
            user = "root",
            passwd = db_passwd
        )
        check = True
    except Exception as error:
        logging.debug(str(error))
        sleep(32)
if check == False:
    exit_code = 2
    logging.exception("Message VR46: Database server is not responding!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    mydb.close()
    sys.exit(exit_code)
#
# Revoke access for all users except 'root', '*', and 'rdsadmin' by setting thier passwords to expired.
#
try:
    mycursor = mydb.cursor()
    logging.info('Revoking access for all users (except root) by setting their passwords to expired...')
    cmd = "UPDATE mysql.user SET password_expired = 'Y' WHERE User NOT IN ('root', 'rdsadmin', '*');"
    logging.debug(cmd)
    mycursor.execute(cmd)
    logging.info('Flushing privileges...')
    cmd = "FLUSH PRIVILEGES;"
    logging.debug(cmd)
    mycursor.execute(cmd)
    logging.info('Killing all connections to ' + args.tgtdb + ' except root and rdsadmin...')
    cmd = "CALL mysql.kill_non_root_processes();"
    logging.debug(cmd)
    mycursor.execute(cmd)
    logging.info('Permissions revoked successfully.')
except:
    exit_code = 3
    logging.exception("Message FQ20: Revoking access for all users (except root) has failed!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    mycursor.close()
    mydb.close()
    sys.exit(exit_code)
#
# Grant privileges only to users found in the user list at top.
#
sleep(8)
try:
    mycursor = mydb.cursor()
    for user in user_list:
        logging.info('Granting permissions for ' + user + '...')
        cmd = "UPDATE mysql.user SET password_expired = 'N' WHERE User = '" + user + "';"
        logging.debug(cmd)
        mycursor.execute(cmd)
        cmd = "GRANT SELECT ON mysql.* TO '" + user + "';"
        logging.debug(cmd)
        mycursor.execute(cmd)
        cmd = "GRANT ALL PRIVILEGES ON purina_profiles.* TO '" + user + "';"
        logging.debug(cmd)
        mycursor.execute(cmd)
        cmd = "GRANT ALL PRIVILEGES ON Purina_Registration.* TO '" + user + "';"
        logging.debug(cmd)
        mycursor.execute(cmd)
        cmd = "GRANT ALL PRIVILEGES ON PurinaCoupon.* TO '" + user + "';"
        logging.debug(cmd)
        mycursor.execute(cmd)
    logging.info('Flushing privileges...')
    cmd = "FLUSH PRIVILEGES;"
    logging.debug(cmd)
    mycursor.execute(cmd)
    logging.info('Permissions granted successfully.')
    exit_code = 0
except:
    exit_code = 4
    logging.exception("Message DP09: Granting privileges to the user list has failed!!!")
finally:
    mydb.close()
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)

#!/usr/bin/env python3
# v2.1.7
# Utility server has python 2.7.12 and 3.6.8
# USAGE:
# UAT   ./tools/groundhog.py --srcdb 'pr2db' --tgtdb 'groundhog-dev' --dbclass 'db.m4.2xlarge' --logfile '/home/ec2-user/groundhog-dev.log' --debug
# PROD  ./tools/groundhog.py --srcdb 'pr2db' --tgtdb 'groundhog' --dbclass 'db.m4.2xlarge' --logfile '/home/ec2-user/groundhog.log' --debug
# Cron  0 4 * * * /home/ec2-user/data/profiles.purina.com/deploy/tools/groundhog.py --srcdb 'pr2db' --tgtdb 'groundhog' --dbclass 'db.m4.xlarge' --logfile '/home/ec2-user/groundhog.log' &> '/home/ec2-user/groundhog-error.log'
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
exit_code = 1 # Setting the exit code to 1 and will be set to 0 in the finally clause.
user_list = ['DW_GROUNDHOG'] # List of users that will have read / write access in Groundhog from 5am to 9am daily.
database_password = '/home/ec2-user/secrets/groundhog.ppk' # File locaiton for database password.
database_postfix = '.cw3pelk7q4ex.us-east-1.rds.amazonaws.com' # AWS database postfix.
sp_file_location = '/home/ec2-user/scripts/kill_non_root_processes.sql' # File locaiton for stored procedure file.
sp_file_content = """
DROP PROCEDURE IF EXISTS mysql.kill_non_root_processes;
DELIMITER $$
CREATE PROCEDURE mysql.kill_non_root_processes()
BEGIN
	DECLARE finished INT DEFAULT 0;
	DECLARE proc_id INT;
	DECLARE proc_id_cursor CURSOR FOR SELECT ID FROM information_schema.processlist WHERE USER NOT IN ('root', 'rdsadmin');
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
	OPEN proc_id_cursor;
	proc_id_cursor_loop: LOOP
		FETCH proc_id_cursor INTO proc_id;
		IF finished = 1 THEN 
			LEAVE proc_id_cursor_loop;
		END IF;
		IF proc_id <> CONNECTION_ID() THEN
			CALL mysql.rds_kill(proc_id);
		END IF;
	END LOOP proc_id_cursor_loop;
	CLOSE proc_id_cursor;
END$$
DELIMITER ;
""" # Stored procedure code for terminating all non-root connetions. The 'DELIMITER' command requires this code be put into a file and called with mysql.
#
# Load argument parser to control input and provide automatic help.
#
parser = argparse.ArgumentParser()
parser.add_argument('--srcdb',
    default='purina-dev',
    choices=['pr2db', 'purina-dev', 'groundhog'],
    metavar='string',
    help='Please provide the name of the database server you would like to clone. Choices: pr2db, purina-dev, groundhog.')
parser.add_argument('--tgtdb',
    default='groundhog-dev',
    choices=['groundhog', 'groundhog-dev', 'groundhog-qa', 'groundhog-dw', 'groundhog-ad-hoc'],
    metavar='string',
    help='Please provide the name you would like used for the new database server. Choices: groundhog, groundhog-dev, groundhog-qa, groundhog-dw, groundhog-ad-hoc')
parser.add_argument('--dbclass',
    default='db.m4.2xlarge',
    choices=['db.m4.large', 'db.m4.xlarge', 'db.m4.2xlarge'],
    metavar='string',
    help='Please chose the size you would like used for the new database server. Choices: db.m4.large, db.m4.xlarge, db.m4.2xlarge')
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
logging.info('Source Database Server Name.............: ' + args.srcdb)
logging.info('Destination Database Server Name........: ' + args.tgtdb)
logging.info('Destination Database Server Size........: ' + args.dbclass)
logging.info('........................................: ')
#
# Query AWS and return latest RDS snapshot name of specified source database.
#
check = False
i = 0
while check == False:
    i += 1
    if i == 4:
        break
    try:
        logging.info('Searching for latest snapshot...')
        cmd = "aws rds describe-db-snapshots " + \
            "--snapshot-type 'automated' " + \
            "--db-instance-identifier '" + str(args.srcdb) + "' " + \
            "--query='reverse(sort_by(DBSnapshots, &SnapshotCreateTime))[0]'"
        logging.debug("Cmd: [" + cmd + "]")
        result_snapshot = subprocess.check_output([cmd], shell=True)
        result_snapshot = result_snapshot.decode("utf-8")
        logging.debug(str(result_snapshot).rstrip())
        parsed_json = json.loads(result_snapshot)
        latest_snapshot_name = parsed_json['DBSnapshotIdentifier']
        logging.info("Latest snapshot found: " + str(latest_snapshot_name))
        check = True
    except Exception as error:
        logging.debug(str(error))
        sleep(4)
if check == False:
    exit_code = 1
    logging.exception("Message AI29: Finding latest snapshot has failed!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)
#
# Delete existing destination database clone if exists.
#
try:
    logging.info("Searching for existing " + args.tgtdb + " instance...")
    cmd = "aws rds describe-db-instances " + \
        "--query 'DBInstances[*].[DBInstanceIdentifier]' " + \
        "--filters Name=db-instance-id,Values='" + str(args.tgtdb) + "' --output text"
    logging.debug("Cmd: [" + cmd + "]")
    result_delete = subprocess.check_output([cmd], shell=True)
    result_delete = result_delete.decode("utf-8")
    if result_delete.rstrip() == str(args.tgtdb):
        logging.info("Existing " + args.tgtdb + " instance found.")
        logging.info("Starting delete of existing " + args.tgtdb + " instance...")
        cmd = "aws rds delete-db-instance " + \
            "--db-instance-identifier '" + str(args.tgtdb) + "' " + \
            "--skip-final-snapshot"
        logging.debug("Cmd: [" + cmd + "]")
        result_action = subprocess.check_output([cmd], shell=True)
        result_action = result_action.decode("utf-8")
        logging.debug("Result: [" + result_action + "]")
    else:
        logging.info("Existing " + args.tgtdb + " instance not found.")
except:
    exit_code = 2
    logging.exception("Message JM43: Deletion of existing " + args.tgtdb + " instance has failed!!!")
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
        logging.debug("Cmd: [" + cmd + "]")
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
            else:
                sleep(60)
        if check == False:
            raise TimeoutError('Error 408 - Request Timeout')
    except:
        exit_code = 3
        logging.exception("Message AD04: Delete operation has failed!!!")
        logging.debug('Exit Code: ' + str(exit_code))
        logging.info('----------------------------- END -----------------------------')
        logging.shutdown()
        sys.exit(exit_code)
#
# Use snapshot to create database clone.
#
try:
    logging.info("Starting clone operation of " + str(args.srcdb) + " to " + str(args.tgtdb) + " of size " + str(args.dbclass) + "...")
    cmd = "aws rds restore-db-instance-from-db-snapshot " + \
        "--db-instance-identifier '" + str(args.tgtdb) + "' " + \
        "--db-snapshot-identifier '" + str(latest_snapshot_name) + "' " + \
        "--availability-zone 'us-east-1d' " + \
        "--db-subnet-group-name 'default-vpc-f7d1c999' " + \
        "--copy-tags-to-snapshot " + \
        "--db-instance-class '" + str(args.dbclass) + "' " + \
        "--publicly-accessible"
    logging.debug("Cmd: [" + cmd + "]")
    result_clone = subprocess.check_output([cmd], shell=True)
    result_clone = result_clone.decode("utf-8")
    logging.debug("Result: [" + result_clone + "]")
except:
    exit_code = 4
    logging.exception("Message CC35: Groundhog cloning operation failed to start!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)
#
# Wait for clone operation to finish.
#
try:
    logging.info("Waiting for new " + args.tgtdb + " instance to be created...")
    cmd = "aws rds describe-db-instances " + \
        "--query 'DBInstances[*].[DBInstanceStatus]' " + \
        "--filters Name=db-instance-id,Values='" + str(args.tgtdb) + "' --output text"
    logging.debug("Cmd: [" + cmd + "]")
    check = False
    i = 0
    while check == False:
        i += 1
        if i == 240:
            break
        result_create = subprocess.check_output([cmd], shell=True)
        result_create = result_create.decode("utf-8").rstrip()
        logging.debug(result_create)
        if result_create == 'available':
            logging.info("New " + args.tgtdb + " instance has been created.")
            check = True
        else:
            sleep(60)
    if check == False:
        raise TimeoutError('Error 408 - Request Timeout')
    sleep(8)
except:
    exit_code = 5
    logging.exception("Message MM93: Creating " + args.tgtdb + " instance has taken too long!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)
#
# Disable automatic backups for groundhog.
#
try:
    logging.info("Disabling automatic backup of " + args.tgtdb + " instance...")
    cmd = "aws rds modify-db-instance " + \
        "--db-instance-identifier " + str(args.tgtdb) + " " + \
        "--backup-retention-period 0 " + \
        "--apply-immediately"
    logging.debug("Cmd: [" + cmd + "]")
    result_disable = subprocess.check_output([cmd], shell=True)
    result_disable = result_disable.decode("utf-8").rstrip()
    logging.debug(result_disable)
except:
    exit_code = 6
    logging.exception("Message JL99: Disable automatic backup command failed to initiate!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)
#
# Wait for disable operation to finish.
#
try:
    logging.info("Waiting for automatic backup to be disabled...")
    cmd = "aws rds describe-db-instances --db-instance-identifier " + args.tgtdb
    check = False
    i = 0
    while check == False:
        i += 1
        if i == 240:
            break
        result_disable = subprocess.check_output([cmd], shell=True)
        result_disable = result_disable.decode("utf-8").rstrip()
        logging.debug(result_disable)
        parsed_json = json.loads(result_disable)
        backup_policy = parsed_json['DBInstances'][0]['BackupRetentionPeriod']
        logging.debug(str(backup_policy))
        if backup_policy == 0:
            logging.info('Automatic backup disabled.')
            check = True
        else:
            sleep(60)
    if check == False:
        raise TimeoutError('Error 408 - Request Timeout')
except:
    exit_code = 7
    logging.exception("Message AR42: Disabling automatic backup has failed!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    sys.exit(exit_code)
#
# Wait for database to be ready for queries.
#
try:
    file = open(database_password, 'r')
    db_passwd = file.read().rstrip()
    file.close()
except:
    exit_code = 8
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
        logging.info('Connection Attempt ' + str(i) + ' to ' + args.tgtdb + database_postfix + '...')
        mydb = mysql.connector.connect(
            host = args.tgtdb + database_postfix,
            user = "root",
            passwd = db_passwd
        )
        check = True
    except Exception as error:
        logging.debug(str(error))
        sleep(32)
if check == False:
    exit_code = 9
    logging.exception("Message VR46: Database server has taken too long to come online!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    mydb.close()
    sys.exit(exit_code)
#
# Drop and create the kill_non_root_processes stored procedure for disconnecting all non root users.
#
sleep(16)
try:
    logging.info('Creating stored procedure file to be used by mysql...')
    file = open(sp_file_location, 'w')
    file.write(sp_file_content)
    file.close()
    logging.info('Stored procedure file created.')
    logging.info('Creating stored procedure for disconnecting all non root users...')
    cmd = "mysql --verbose -u root --password=" + db_passwd + " -h " + args.tgtdb + database_postfix + " mysql < " + sp_file_location
    logging.debug(cmd)
    result_sp = subprocess.check_output([cmd], shell=True)
    result_sp = result_sp.decode("utf-8").rstrip()
    logging.debug(result_sp)
    logging.info('Stored procedure created successfully.')
except:
    exit_code = 10
    logging.exception("Message JZ05: Creation of stored procedure has failed!!!")
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
    exit_code = 11
    logging.exception("Message FQ20: Revoking access for all users (except root) has failed!!!")
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    mycursor.close()
    mydb.close()
    sys.exit(exit_code)
#
# Grant privileges only to users found in the user list at top (i.e. DW_GROUNDHOG).
#
try:
    for user in user_list:
        logging.info('Granting permissions to ' + user + '...')
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
    exit_code = 12
    logging.exception("Message DP09: Granting privileges to the user list has failed!!!")
finally:
    mydb.close()
    logging.debug('Exit Code: ' + str(exit_code))
    logging.info('----------------------------- END -----------------------------')
    logging.shutdown()
    mycursor.close()
    mydb.close()
    sys.exit(exit_code)

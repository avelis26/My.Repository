#!/usr/bin/env python3
# v0.0.3
# Utility server has python 2.6.9 and 3.4.8
# https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-snapshots.html
# https://docs.aws.amazon.com/cli/latest/reference/rds/restore-db-instance-from-db-snapshot.html
import subprocess
import datetime
import json
new_instance_name = 'groundhog-test'
target_instance_name = 'purina-dev'
target_security_group = 'rds-launch-wizard-4 (sg-cfb6b186)'
cmd = "aws rds describe-db-snapshots --snapshot-type 'automated' --db-instance-identifier '" + str(target_instance_name) + "' --query='reverse(sort_by(DBSnapshots, &SnapshotCreateTime))[0]'"
result = subprocess.check_output([cmd], shell=True)
result = result.decode("utf-8")
parsed_json = json.loads(result)
latest_snapshot_name = parsed_json['DBSnapshotIdentifier']
print("Latest snapshot for instance: " + str(target_instance_name) + ", is: " + str(latest_snapshot_name))
print("Current UTC time is:  " + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
print("Starting restore...")
cmd = "aws rds restore-db-instance-from-db-snapshot --db-instance-identifier '" + str(new_instance_name) + "' --db-snapshot-identifier '" + str(latest_snapshot_name) + "'"
result = subprocess.check_output([cmd], shell=True)
print("Current UTC time is:  " + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
print("Done :)")
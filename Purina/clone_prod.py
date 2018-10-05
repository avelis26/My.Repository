#!/usr/bin/env python3
# v0.0.7
# Utility server has python 2.6.9 and 3.4.8
# https://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-snapshots.html
# https://docs.aws.amazon.com/cli/latest/reference/rds/restore-db-instance-from-db-snapshot.html
import subprocess
import datetime
import json
ops_log = '/home/ec2-user/gpink/groundhog.log'
new_instance_name = 'groundhog-test'
target_instance_name = 'purina-dev'
target_security_group = 'rds-launch-wizard-4 (sg-cfb6b186)'


def timestamp(write_mode):
    print("Current UTC time is:  " + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"), file = open(ops_log, write_mode))


print(timestamp('w'))
cmd = "aws rds describe-db-snapshots --snapshot-type 'automated' --db-instance-identifier '" + \
    str(target_instance_name) + \
    "' --query='reverse(sort_by(DBSnapshots, &SnapshotCreateTime))[0]'"
print("Searching for latest snapshot...", file=open(ops_log, "a"))
print(cmd, file=open(ops_log, "a"))
result = subprocess.check_output([cmd], shell=True)
result = result.decode("utf-8")
print(result, file=open(ops_log, "a"))
parsed_json = json.loads(result)
latest_snapshot_name = parsed_json['DBSnapshotIdentifier']
print("Latest snapshot for instance: " + str(target_instance_name) +
      ", is: " + str(latest_snapshot_name), file=open(ops_log, "a"))
print(timestamp('a'))
print("Starting restore...", file=open(ops_log, "a"))
cmd = "aws rds restore-db-instance-from-db-snapshot --db-instance-identifier '" + str(new_instance_name) + "' --db-snapshot-identifier '" + str(
    latest_snapshot_name) + "' --availability-zone 'us-east-1d' --db-subnet-group-name 'default-vpc-f7d1c999' --copy-tags-to-snapshot"
print(cmd, file=open(ops_log, "a"))
result = subprocess.check_output([cmd], shell=True)
result = result.decode("utf-8")
print(result, file=open(ops_log, "a"))
print(timestamp('a'))
print("Done :)", file=open(ops_log, "a"))

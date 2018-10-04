#!/usr/bin/env python3
# Utility server has python 2.6.9 and 3.4.8
import subprocess
import json
cmd="aws rds describe-db-snapshots --snapshot-type 'automated' --db-instance-identifier 'purina-dev' --query='reverse(sort_by(DBSnapshots, &SnapshotCreateTime))[0]'"
result=subprocess.check_output([cmd], shell=True)
result=result.decode("utf-8")
parsed_json=json.loads(result)
print(parsed_json['DBSnapshotIdentifier'])
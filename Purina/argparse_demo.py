#!/usr/bin/env python3
# ./argparse_demo.py --existing_db_name 'pr2db' --new_db_name 'groundhog' --new_db_class 'db.m4.xlarge'
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--existing_db_name',
                    default='pr2db',
                    choices=['pr2db', 'purina-dev', 'groundhog'],
                    metavar='string',
                    help='The name of the database you would like to clone. Example: pr2db')
parser.add_argument('--new_db_name',
                    default='groundhog',
                    choices=['groundhog', 'groundhog_uat', 'groundhog_qa'],
                    metavar='string',
                    help='The name you would like used for the new database. Example: groundhog')
parser.add_argument('--new_db_class',
                    default='db.m4.xlarge',
                    choices=['db.m4.large', 'db.m4.xlarge', 'db.m4.2xlarge'],
                    metavar='string',
                    help='The size you would like used for the new database. Example: db.m4.xlarge')
args = parser.parse_args()

print(str(args))

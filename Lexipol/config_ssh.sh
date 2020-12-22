#!/bin/bash
sudo nano /etc/ssh/sshd_config
# Set the following arguments:
# PasswordAuthentication yes
# ChallengeResponseAuthentication yes
# PubkeyAuthentication yes
sudo service sshd restart

clear && sudo cat /etc/ssh/sshd_config | grep 'PasswordAuthentication\|ChallengeResponseAuthentication\|PubkeyAuthentication'
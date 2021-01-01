#!/bin/bash
sudo nano /etc/ssh/sshd_config
# Set the following arguments:
# PasswordAuthentication yes
# ChallengeResponseAuthentication yes
# PubkeyAuthentication yes
# UsePAM yes
sudo service sshd restart

clear && sudo cat /etc/ssh/sshd_config | grep 'PasswordAuthentication\|ChallengeResponseAuthentication\|PubkeyAuthentication\|UsePAM'

sudo tail -f /var/log/secure

sudo su
file=/etc/ssh/sshd_config
cat $file > $file.old
awk '
$1=="PasswordAuthentication" {$2="yes"}
$1=="ChallengeResponseAuthentication" {$2="yes"}
$1=="PubkeyAuthentication" {$2="yes"}
$1=="UsePAM" {$2="yes"}
{print}
' $file.old > $file
diff $file.old $file

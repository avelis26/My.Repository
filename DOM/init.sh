#!/bin/bash
sudo groupadd sftpadmins
sudo groupadd sftpusers
sudo usermod -a -G sftpadmins localadmin
sudo usermod -a -G sftpusers localadmin
sudo mkdir /media/data
sudo fdisk /dev/sdc
#n
#p
#1
#[default]
#[default]
#p
#w

sudo mkfs -t ext4 /dev/sdc1
sudo -i blkid

#[copy UUID of sdc1 and paste in next command]

sudo sh -c "echo 'UUID=979c0330-3248-4999-9563-7ae77acbc650    /media/data    ext4    defaults,nofail    1    2' >> /etc/fstab"
echo "alias update='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoclean -y && sudo apt autoremove -y'" >> /home/localadmin/.bashrc
sudo reboot

update && sudo apt-get -y install samba

sudo smbpasswd -a localadmin

sudo sh -c "echo '
[data]
   path = /media/data
   available = yes
   valid users = localadmin
   read only = no
   browsable = yes
   public = yes
   writable = yes' >> /etc/samba/smb.conf"
sudo service smbd restart

sudo chmod 755 /media/data

sudo useradd -g sftpusers --create-home --no-user-group databasescvs
sudo mkdir -p /media/data/databasescvs/inbound
sudo mkdir -p /media/data/databasescvs/outbound
sudo chown -R root:root /media/data/databasescvs
sudo chown databasescvs:sftpusers /media/data/databasescvs/inbound
sudo chown databasescvs:sftpusers /media/data/databasescvs/outbound
sudo chmod 775 /media/data/databasescvs/inbound
sudo chmod 775 /media/data/databasescvs/outbound
sudo mkdir /home/databasescvs/.ssh
sudo chown databasescvs:sftpusers /home/databasescvs/.ssh
sudo chmod 700 /home/databasescvs/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCy83ZEFiUH9cSH9MMKBzJWvJveeLBqD0D7SXz92YqPiO/Cr55M4lSV6rg5MN/Ste2BD04ijc/OJwaNuRfuGC0mm0gPj5NnOlBGtRF0rsPEfjqfNeCVwbonqjz6uLDru/PHzrIqbdhrXJWDKr/8CCNlEJqZskelnzqU1JNgnZKPyZ6jHLFCOJ54B3/B9qJuGaN/1vs+EfUfeccJZmshKcpTR8mOrgOHqb3i2lF1L37WX8kLhnolIslhRL7QsqpMKdXm7KR28R9f62bLRkdLGj4W3dVqJ6zWl7ps8cw48HRWms56EBF14ZRiQEkxhUQcDtGRU3udm9zQ/TH1xHo3fiAD databasescvs' >> /home/databasescvs/.ssh/authorized_keys"
sudo chown databasescvs:sftpusers /home/databasescvs/.ssh/authorized_keys
sudo chmod 644 /home/databasescvs/.ssh/authorized_keys

sudo sh -c "echo 'Match user databasescvs
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/databasescvs
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no' >> /etc/ssh/sshd_config"
sudo service ssh restart

#"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
#"net use z: /delete"
#"net use z: \\10.0.0.21\data password /user:localadmin"
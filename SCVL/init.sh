#!/bin/bash
sudo groupadd sftpadmins
sudo groupadd sftpusers
sudo usermod -a -G sftpadmins localadmin
sudo usermod -a -G sftpusers localadmin
sudo mkdir /media/data
sudo fdisk /dev/sdc

n
p
1
[default]
[default]
p
w

sudo mkfs -t ext4 /dev/sdc1
sudo -i blkid

[copy UUID of sdc1]

sudo sh -c "echo 'UUID=c7bb2301-949c-47b0-99d1-7e11a88f55ff    /media/data    ext4    defaults,nofail    1    2' >> /etc/fstab"
echo "alias update='sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoclean -y'" >> /home/localadmin/.bashrc
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

sudo useradd -g sftpusers --create-home --no-user-group scvlsftp
sudo mkdir -p /media/data/scvlsftp/inbound
sudo mkdir -p /media/data/scvlsftp/outbound
sudo chown -R root:root /media/data/scvlsftp
sudo chown scvlsftp:sftpusers /media/data/scvlsftp/inbound
sudo chown scvlsftp:sftpusers /media/data/scvlsftp/outbound
sudo chmod 775 /media/data/scvlsftp/inbound
sudo chmod 775 /media/data/scvlsftp/outbound
sudo mkdir /home/scvlsftp/.ssh
sudo chown scvlsftp:sftpusers /home/scvlsftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEArV0K522fOME13iAdEN2h/ryVKsM7dnSfRSZCr78F2AICnuQXPP59d7urvMBNeeFRAn/ZhCVnQSsTXaDKY+k1+qWJ8b5X2n3YIXdopfHHWGS14tpbbt1DC5IzVEpCIQHRHZO4DU8/1X0/cJGZv8PX/jGTKrfBwqs0SNFpVmg0nmx+ZbzdCYJy4lccoYMGSGqVtT4elV0c5TF/fdrgJrlYmV/89pS6k40hGLZ1iu/Cib79/et9iIOCPePsv0LmTLOKCz6d3A3DWk+c2e4xSpF1WIQtLvWfV5u140chRgZfHD/34DqnkneEChwdd3dkZjtmS4OXsfXYGZF6ZGPQgLkEXQ== rsa-key-20190110' >> /home/scvlsftp/.ssh/authorized_keys"
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDY2BJmaWS9hxVSB0oAPO19MuU5jgu7R2YiWoYymfhuPiDe95mmj5FhITdJH//wdHgoC0FxDGAG0f4QX6PA2J/ZKu0Ba3sMCLg263UAiD84BSk95TwGocUKEWoEkWVfjNGawC8AuSwscMi27qXqIz2tLa60bKyEKNlXEJi5izSIM38I7BimQ1tChsovNzmAODSMHmsRzcnGw0hJYcxnh/9BtHLRdDcJgGtdJzEda4Tfo1K4DJzyQ4mnpuNFg6rhGwLbW86Hy76bPxZhXtPa8XY8yF+26SDWGPfW2/wMx88y8xOcO57C64Fm0ZUOownypLBuV23/Z9VexrxB6Hc6wskd== scvlsftp' >> /home/scvlsftp/.ssh/authorized_keys"
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfSUATFmR8JXYu1iHhQfnhebjPQotb5RhwDTo+GtCBI29QuFN9emLvcr9hEzxqlUiLcUeOYjywfbVi8Vx6Kb5wAnMyl0t3vnjhqWigVfw3dzG+r6J6qxGCIZhcqwaJ4/aaePsQ+QWE+v+C5npLRooLZn43BmSYbYnkCItWySYNssUim7N+cW1ms5mHlycnVWy+vgh8NPGP3D3ygSqQbHpumML4a6zx8pmXKgB/wUDMHZFqMArR9L9PUonowZ2lP9WsL3nNuA7AWrs26nm/aVMFjvEVdDK2MZlMMMNh/iKDdHAnxU1k+MKAQt1yd2epSAyuyDA8k5rOpHtLsGn0f9z7 localadmin@ScvlProdSftp01' >> /home/scvlsftp/.ssh/authorized_keys"
sudo chown scvlsftp:sftpusers /home/scvlsftp/.ssh/authorized_keys

sudo useradd -g sftpusers --create-home --no-user-group vibessftp
sudo mkdir -p /media/data/vibessftp/inbound
sudo mkdir -p /media/data/vibessftp/outbound
sudo chown -R root:root /media/data/vibessftp
sudo chown vibessftp:sftpusers /media/data/vibessftp/inbound
sudo chown vibessftp:sftpusers /media/data/vibessftp/outbound
sudo chmod 775 /media/data/vibessftp/inbound
sudo chmod 775 /media/data/vibessftp/outbound
sudo mkdir /home/vibessftp/.ssh
sudo chown vibessftp:sftpusers /home/vibessftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAIaGL6JUCnKVbmW6msLrasXoFWLj/hJEmkMLREnn9x5uloZZ584l+hEh3+kcE0UR970tm7tBmHriOmFfgNuLx0SWSvO4ng04WF+A8sm6kysWOVTw3mmsTNqUEM/C/lkBPv/YG7HATvyVR0DtrAnvxEDXXzadN2oIO3dQFkx8darnCuiPm6AMToUwTz4P3Kw6Kh5tE0v1x8MvH+MQr6WWWR5Cm3jAbpBJpHfTMcVAs95ePszidDEUe5abxQ1ndglfAyHa4LKlqVWZw6Qw4XAaU88GlCcdX6Y9KpEUhBSDM1qEB78h+SjNtOnz2YwwgYiEHBMiPW4mPuBslUkj91+df vibessftp' >> /home/vibessftp/.ssh/authorized_keys"
sudo chown vibessftp:sftpusers /home/vibessftp/.ssh/authorized_keys

sudo useradd -g sftpusers --create-home --no-user-group responsyssftp
sudo mkdir -p /media/data/responsyssftp/inbound
sudo mkdir -p /media/data/responsyssftp/outbound
sudo chown -R root:root /media/data/responsyssftp
sudo chown responsyssftp:sftpusers /media/data/responsyssftp/inbound
sudo chown responsyssftp:sftpusers /media/data/responsyssftp/outbound
sudo chmod 775 /media/data/responsyssftp/inbound
sudo chmod 775 /media/data/responsyssftp/outbound
sudo mkdir /home/responsyssftp/.ssh
sudo chown responsyssftp:sftpusers /home/responsyssftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB0uNwYORRENceVdJeCAsWcN+85+qrTAAJSWWW+9vs9f6W5ln7qCt/v5Gkk660KRmdoEGRlA2e28aeKRSbps3xfTn3Za8Y+kL4/SNvhM0T9W10EMFt4Vdrtz+ZXKNeWsB2nlQ09/RIWoH7q5/jv6NAm4BcNaaeUY1Djj6I5x7Ch6zD+A0VQzyuVhCJfYBGc75r3+x2JKXQU4FjjH2w0GtzQfDPCVfzAtGk6KhckHgAen2NMdAqOJBWvQfLG3VVRQTViJbhpXUWO8pD20UAxRVLc6MJ+Tka5N8f1ClQ1EhiaAYyV91SMzxjw8UIfaZ+NUMdC8V9HMu8W8GoNYSoFr8Z responsyssftp' >> /home/responsyssftp/.ssh/authorized_keys"
sudo chown responsyssftp:sftpusers /home/responsyssftp/.ssh/authorized_keys

sudo useradd -g sftpusers --create-home --no-user-group sfccsftp
sudo mkdir -p /media/data/sfccsftp/inbound
sudo mkdir -p /media/data/sfccsftp/outbound
sudo chown -R root:root /media/data/sfccsftp
sudo chown sfccsftp:sftpusers /media/data/sfccsftp/inbound
sudo chown sfccsftp:sftpusers /media/data/sfccsftp/outbound
sudo chmod 775 /media/data/sfccsftp/inbound
sudo chmod 775 /media/data/sfccsftp/outbound
sudo mkdir /home/sfccsftp/.ssh
sudo chown sfccsftp:sftpusers /home/sfccsftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC03ZWqIC4joprUzcFeaOw6XpqeTxekk9tUD1ylLa4rZ2+SElmWI9bgWJKO4gbtKQ4s6SZKGbDbG5isVUGuqkp73f1eH0uDG0kNyIyLsw06z5l9SwIY/CPNc0uwCEhmbK7uqr/XsRBWpl/6v3+4pQusdgo87UzOhMLDtfk1sxpiuUfO5M4C4/1GIX8QwrujV8TDfSrIdSak12X4gEPVKqjYU1NdrdXeuRH5MnGoL3B6c6jKTfGyBwBq0+hSEuXbDQrKnNZYJ+DMoXt+OUE7FqsR6W9lxSIoGkuKtkmOEpMJPFFN0OThpBR5fZRvaHt8Md2+LOFDM6XTQUyh/N7Bua1l sfccsftp' >> /home/sfccsftp/.ssh/authorized_keys"
sudo chown sfccsftp:sftpusers /home/sfccsftp/.ssh/authorized_keys

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
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCy83ZEFiUH9cSH9MMKBzJWvJveeLBqD0D7SXz92YqPiO/Cr55M4lSV6rg5MN/Ste2BD04ijc/OJwaNuRfuGC0mm0gPj5NnOlBGtRF0rsPEfjqfNeCVwbonqjz6uLDru/PHzrIqbdhrXJWDKr/8CCNlEJqZskelnzqU1JNgnZKPyZ6jHLFCOJ54B3/B9qJuGaN/1vs+EfUfeccJZmshKcpTR8mOrgOHqb3i2lF1L37WX8kLhnolIslhRL7QsqpMKdXm7KR28R9f62bLRkdLGj4W3dVqJ6zWl7ps8cw48HRWms56EBF14ZRiQEkxhUQcDtGRU3udm9zQ/TH1xHo3fiAD databasescvs' >> /home/databasescvs/.ssh/authorized_keys"
sudo chown databasescvs:sftpusers /home/databasescvs/.ssh/authorized_keys

sudo useradd -g sftpusers --create-home --no-user-group crowdtwist
sudo mkdir -p /media/data/crowdtwist/inbound
sudo mkdir -p /media/data/crowdtwist/outbound
sudo chown -R root:root /media/data/crowdtwist
sudo chown crowdtwist:sftpusers /media/data/crowdtwist/inbound
sudo chown crowdtwist:sftpusers /media/data/crowdtwist/outbound
sudo chmod 775 /media/data/crowdtwist/inbound
sudo chmod 775 /media/data/crowdtwist/outbound
sudo mkdir /home/crowdtwist/.ssh
sudo chown crowdtwist:sftpusers /home/crowdtwist/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxvWxOUVF+lkBh2KBxZkUDa2+fzN8SXd1jYDvVR1mtkt1lio66U13ARAsEpfL9mtDmCpBbQNuPFXtZ+WYvxg0wkton/LembdkRYrwh9K/s3BNxnHJ7vP5Z+hJApB/NqR7Ushm7OtpOlmiGq7L4Ug1qr+LBv52hrir0rSbBUqKkmQNnS6pwv7QCLyTFyERgOsxO7mIbKBNv21l2s0a9TSfDOgYi0JxvZtV/5iTFs6E1OXnAiWLtIR9BwJGOjl17ih2ckZmI01WAmE/LPc8DRqDdamA+ufBcisv2Hwi9sOq+poHBBbWebfySaqqs7Xh6WoNIsao4AecXjI9SX6zzb5Mj' >> /home/crowdtwist/.ssh/authorized_keys"
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcp/oqfof5cBejc2/tiiAFGQWbDs5myM3dgRvW3on+FB2As70mVc2oIYrdKXqh8kzapE034WlYKf49ajvZhyw4dJJ0OQQ04+VbpDlB7jlk+V1gEjxxNh7xaP8S+FuRS6vwfabRdveAhNXo1shRkA72yMn6mHI6pAkh9d1dxdUBqrVpKhxFfosTs+mBm6/YIj2VixCB98WFk2xAhLgBK5EVkpLACdGGU+eLvZrlk4b7KWOJpl75ZyI87eE07KmBZdGgACEhDnyRCjXKh7gViJmUFKIQdx8g8iP6A+xcXFV1AgG276vpemSGQf51Wz+Q9kXEDfv10Q4sfVX/PAQ7yMnZ mikechuang@ip-192-168-1-19.ec2.internal' >> /home/crowdtwist/.ssh/authorized_keys"
sudo chown crowdtwist:sftpusers /home/crowdtwist/.ssh/authorized_keys

sudo useradd -g sftpusers --create-home --no-user-group sfccscvl
sudo chown sfccscvl:sftpusers /media/data/sfccsftp/inbound
sudo chown sfccscvl:sftpusers /media/data/sfccsftp/outbound
sudo mkdir /home/sfccscvl/.ssh
sudo chown sfccscvl:sftpusers /home/sfccscvl/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+YNsVnJ+9nCGpg5RnnBGkYMFtuuXYq75gkTP1OKzvZD392uC2noAg8C/PfsSTEk2gwo/M1TCVMSzXW7BsqTwRWAT/I29h5T+fmSOcQrfwllVWUKdkUWUuCYVs8ngWXIn/oe6+HO63aTzrNxRIBFBf0ijV1ujpUb0TnOEm6W41TjsoB9+7mjacqXO76DuM55zYLEVjlOSy1FYniZiJD46G48QFknmhACHjFSuK52mT8f8NtaQqY4kDB4D8lqQ4CTubPjhZZA/lW0jc5XYKlPb6D8FiXDxqrNQQHwPy3nU9l+CJ7bmcvuFUTFYsjbGbHe9as2CuIWUleaqaheAel1BB sfccscvl' >> /home/sfccscvl/.ssh/authorized_keys"
sudo chown sfccscvl:sftpusers /home/sfccscvl/.ssh/authorized_keys

sudo sh -c "echo 'Match user scvlsftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/scvlsftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user vibessftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/vibessftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user responsyssftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/responsyssftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user sfccsftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/sfccsftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user crowdtwist
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/crowdtwist
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user databasescvs
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/databasescvs
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user sfccscvl
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/sfccsftp
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no' >> /etc/ssh/sshd_config"

sudo chmod 700 /home/crowdtwist/.ssh
sudo chmod 700 /home/databasescvs/.ssh
sudo chmod 700 /home/localadmin/.ssh
sudo chmod 700 /home/responsyssftp/.ssh
sudo chmod 700 /home/scvlsftp/.ssh
sudo chmod 700 /home/sfccsftp/.ssh
sudo chmod 700 /home/vibessftp/.ssh
sudo chmod 644 /home/crowdtwist/.ssh/authorized_keys
sudo chmod 644 /home/databasescvs/.ssh/authorized_keys
sudo chmod 644 /home/localadmin/.ssh/authorized_keys
sudo chmod 644 /home/responsyssftp/.ssh/authorized_keys
sudo chmod 644 /home/scvlsftp/.ssh/authorized_keys
sudo chmod 644 /home/sfccsftp/.ssh/authorized_keys
sudo chmod 644 /home/vibessftp/.ssh/authorized_keys












sudo setfacl -d -R -m u::rwx,g::rw,o::- /media/data/databasescvs/


getfacl /media/data/databasescvs/





sudo setfacl -b -R /media/data/databasescvs/


sudo service ssh restart


#sftp -o "IdentityFile=scvlsftp.ppk" scvlsftp@scvl-test-sftp-01.centralus.cloudapp.azure.com
#"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
#"net use z: /delete"
#"net use z: \\10.0.0.21\data password /user:localadmin"
#sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDY2BJmaWS9hxVSB0oAPO19MuU5jgu7R2YiWoYymfhuPiDe95mmj5FhITdJH//wdHgoC0FxDGAG0f4QX6PA2J/ZKu0Ba3sMCLg263UAiD84BSk95TwGocUKEWoEkWVfjNGawC8AuSwscMi27qXqIz2tLa60bKyEKNlXEJi5izSIM38I7BimQ1tChsovNzmAODSMHmsRzcnGw0hJYcxnh/9BtHLRdDcJgGtdJzEda4Tfo1K4DJzyQ4mnpuNFg6rhGwLbW86Hy76bPxZhXtPa8XY8yF+26SDWGPfW2/wMx88y8xOcO57C64Fm0ZUOownypLBuV23/Z9VexrxB6Hc6wskd scvlsftp' >> /home/scvlsftp/.ssh/authorized_keys"
##sudo useradd -s /bin/true smbsvc
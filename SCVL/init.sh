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

sudo sh -c "echo 'UUID=5d72fab2-a5c2-48b3-b6e7-d8a89fc76fb1	/media/data	ext4	defaults,nofail	1	2' >> /etc/fstab"
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
sudo mkdir -p /media/data/scvl/inbound
sudo mkdir -p /media/data/scvl/outbound
sudo chown -R root:root /media/data/scvl
sudo chown scvlsftp:sftpadmins /media/data/scvl/inbound
sudo chown scvlsftp:sftpadmins /media/data/scvl/outbound
sudo chmod 775 /media/data/scvl/inbound
sudo chmod 775 /media/data/scvl/outbound
sudo mkdir /home/scvlsftp/.ssh
sudo chown scvlsftp:sftpusers /home/scvlsftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDY2BJmaWS9hxVSB0oAPO19MuU5jgu7R2YiWoYymfhuPiDe95mmj5FhITdJH//wdHgoC0FxDGAG0f4QX6PA2J/ZKu0Ba3sMCLg263UAiD84BSk95TwGocUKEWoEkWVfjNGawC8AuSwscMi27qXqIz2tLa60bKyEKNlXEJi5izSIM38I7BimQ1tChsovNzmAODSMHmsRzcnGw0hJYcxnh/9BtHLRdDcJgGtdJzEda4Tfo1K4DJzyQ4mnpuNFg6rhGwLbW86Hy76bPxZhXtPa8XY8yF+26SDWGPfW2/wMx88y8xOcO57C64Fm0ZUOownypLBuV23/Z9VexrxB6Hc6wskd scvlsftp' >> /home/scvlsftp/.ssh/authorized_keys"
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEArV0K522fOME13iAdEN2h/ryVKsM7dnSfRSZCr78F2AICnuQXPP59d7urvMBNeeFRAn/ZhCVnQSsTXaDKY+k1+qWJ8b5X2n3YIXdopfHHWGS14tpbbt1DC5IzVEpCIQHRHZO4DU8/1X0/cJGZv8PX/jGTKrfBwqs0SNFpVmg0nmx+ZbzdCYJy4lccoYMGSGqVtT4elV0c5TF/fdrgJrlYmV/89pS6k40hGLZ1iu/Cib79/et9iIOCPePsv0LmTLOKCz6d3A3DWk+c2e4xSpF1WIQtLvWfV5u140chRgZfHD/34DqnkneEChwdd3dkZjtmS4OXsfXYGZF6ZGPQgLkEXQ scvlsftp-customer-provided' >> /home/scvlsftp/.ssh/authorized_keys"
sudo chown scvlsftp:sftpusers /home/scvlsftp/.ssh/authorized_keys
sudo useradd -g sftpusers --create-home --no-user-group vibessftp
sudo mkdir -p /media/data/vibes/inbound
sudo mkdir -p /media/data/vibes/outbound
sudo chown -R root:root /media/data/vibes
sudo chown vibessftp:sftpadmins /media/data/vibes/inbound
sudo chown vibessftp:sftpadmins /media/data/vibes/outbound
sudo chmod 775 /media/data/vibes/inbound
sudo chmod 775 /media/data/vibes/outbound
sudo mkdir /home/vibessftp/.ssh
sudo chown vibessftp:sftpusers /home/vibessftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAIaGL6JUCnKVbmW6msLrasXoFWLj/hJEmkMLREnn9x5uloZZ584l+hEh3+kcE0UR970tm7tBmHriOmFfgNuLx0SWSvO4ng04WF+A8sm6kysWOVTw3mmsTNqUEM/C/lkBPv/YG7HATvyVR0DtrAnvxEDXXzadN2oIO3dQFkx8darnCuiPm6AMToUwTz4P3Kw6Kh5tE0v1x8MvH+MQr6WWWR5Cm3jAbpBJpHfTMcVAs95ePszidDEUe5abxQ1ndglfAyHa4LKlqVWZw6Qw4XAaU88GlCcdX6Y9KpEUhBSDM1qEB78h+SjNtOnz2YwwgYiEHBMiPW4mPuBslUkj91+df vibessftp' >> /home/vibessftp/.ssh/authorized_keys"
sudo chown vibessftp:sftpusers /home/vibessftp/.ssh/authorized_keys
sudo useradd -g sftpusers --create-home --no-user-group responsyssftp
sudo mkdir -p /media/data/responsys/inbound
sudo mkdir -p /media/data/responsys/outbound
sudo chown -R root:root /media/data/responsys
sudo chown responsyssftp:sftpadmins /media/data/responsys/inbound
sudo chown responsyssftp:sftpadmins /media/data/responsys/outbound
sudo chmod 775 /media/data/responsys/inbound
sudo chmod 775 /media/data/responsys/outbound
sudo mkdir /home/responsyssftp/.ssh
sudo chown responsyssftp:sftpusers /home/responsyssftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDB0uNwYORRENceVdJeCAsWcN+85+qrTAAJSWWW+9vs9f6W5ln7qCt/v5Gkk660KRmdoEGRlA2e28aeKRSbps3xfTn3Za8Y+kL4/SNvhM0T9W10EMFt4Vdrtz+ZXKNeWsB2nlQ09/RIWoH7q5/jv6NAm4BcNaaeUY1Djj6I5x7Ch6zD+A0VQzyuVhCJfYBGc75r3+x2JKXQU4FjjH2w0GtzQfDPCVfzAtGk6KhckHgAen2NMdAqOJBWvQfLG3VVRQTViJbhpXUWO8pD20UAxRVLc6MJ+Tka5N8f1ClQ1EhiaAYyV91SMzxjw8UIfaZ+NUMdC8V9HMu8W8GoNYSoFr8Z responsyssftp' >> /home/responsyssftp/.ssh/authorized_keys"
sudo chown responsyssftp:sftpusers /home/responsyssftp/.ssh/authorized_keys
sudo useradd -g sftpusers --create-home --no-user-group sfccsftp
sudo mkdir -p /media/data/sfcc/inbound
sudo mkdir -p /media/data/sfcc/outbound
sudo chown -R root:root /media/data/sfcc
sudo chown sfccsftp:sftpadmins /media/data/sfcc/inbound
sudo chown sfccsftp:sftpadmins /media/data/sfcc/outbound
sudo chmod 775 /media/data/sfcc/inbound
sudo chmod 775 /media/data/sfcc/outbound
sudo mkdir /home/sfccsftp/.ssh
sudo chown sfccsftp:sftpusers /home/sfccsftp/.ssh
sudo sh -c "echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC03ZWqIC4joprUzcFeaOw6XpqeTxekk9tUD1ylLa4rZ2+SElmWI9bgWJKO4gbtKQ4s6SZKGbDbG5isVUGuqkp73f1eH0uDG0kNyIyLsw06z5l9SwIY/CPNc0uwCEhmbK7uqr/XsRBWpl/6v3+4pQusdgo87UzOhMLDtfk1sxpiuUfO5M4C4/1GIX8QwrujV8TDfSrIdSak12X4gEPVKqjYU1NdrdXeuRH5MnGoL3B6c6jKTfGyBwBq0+hSEuXbDQrKnNZYJ+DMoXt+OUE7FqsR6W9lxSIoGkuKtkmOEpMJPFFN0OThpBR5fZRvaHt8Md2+LOFDM6XTQUyh/N7Bua1l sfccsftp' >> /home/sfccsftp/.ssh/authorized_keys"
sudo chown sfccsftp:sftpusers /home/sfccsftp/.ssh/authorized_keys
sudo sh -c "echo 'Match user scvlsftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/scvl
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user vibessftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/vibes
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user responsyssftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/responsys
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no
Match user sfccsftp
ForceCommand internal-sftp -u 7
ChrootDirectory /media/data/sfcc
PermitTunnel no
AllowAgentForwarding no
AllowTcpForwarding no
X11Forwarding no' >> /etc/ssh/sshd_config"
sudo systemctl restart sshd






sftp -o "IdentityFile=scvlsftp.ppk" scvlsftp@scvl-test-sftp-01.centralus.cloudapp.azure.com

"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
"net use z: /delete"
"net use z: \\10.0.0.21\data Password20!7! /user:localadmin"

##sudo useradd -s /bin/true smbsvc
#!/bin/bash
# Create resources.
sudo -i
useradd -G group1,group2 -m gpinkston
passwd gpinkston
mkdir ~/.ssh
echo '-----BEGIN OPENSSH PRIVATE KEY-----' >> ~/.ssh/id_rsa
echo '-----END OPENSSH PRIVATE KEY-----' >> ~/.ssh/id_rsa
echo 'pubkey' >> ~/.ssh/id_rsa.pub
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# Set permissions.
chown -R gpinkston:gpinkston ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 644 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
sudo sh -c "echo \"gpinkston  ALL=(ALL) NOPASSWD:ALL\" >> /etc/sudoers"
# Update groups
sudo usermod -aG wheel,docker gpinkston
# Create alias's
echo 'alias ls="ls -lAph --color=always"' >> ~/.bashrc
echo 'alias ll="ls -lAph --color=always"' >> ~/.bashrc
echo 'alias update="sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y"' >> ~/.bashrc
source ~/.bashrc

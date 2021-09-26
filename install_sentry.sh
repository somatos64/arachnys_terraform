#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sudo /usr/bin/apt-add-repository --yes --update ppa:ansible/ansible
sudo /usr/bin/apt-get update
sudo /usr/bin/apt install -y ansible
/bin/echo -e \"Host github.com\\n\\tStrictHostKeyChecking no\\n\" >> /root/.ssh/config
/usr/bin/git clone -b master https://github.com/somatos64/arachnys_ansible.git --single-branch /tmp/arachnys_ansible
/usr/bin/ansible-galaxy collection install community.docker
/usr/bin/ansible-playbook /tmp/arachnys_ansible/playbook.yml -vvv
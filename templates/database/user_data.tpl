
#cloud-config
output : { all : '| tee -a /var/log/cloud-init-output.log' }
repo_update: true
repo_upgrade: all
runcmd:
  - [ sh, -c, "echo 'Deploying database'" ]
  - [ sh, -c, "echo 'Adding cloud-init logging output'" ]

  - [ sh, -c, "echo 'Updating OS'" ]
  - yum update -y
  - yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  - yum update -y
  - yum install -y git ansible jq unzip nano

  - [ sh, -c, "echo 'Installing pip'" ]
  - sudo yum install python-pip -y

  - [ sh, -c, "echo 'Installing AWS CLI V2'" ]
  - curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  - unzip awscliv2.zip
  - sudo ./aws/install
  - export PATH=/usr/local/bin:$PATH

  - [ sh, -c, "echo 'Installing / Updating PIP dependencies for ansible'" ]
  - pip install boto3 --upgrade
  - pip install futures
  - pip install Jinja2 --upgrade

  - [sh, -c, "echo create Git Config Credential helper"]
  - echo '#!/bin/bash' > /bin/askpass.sh
  - echo "echo username=$(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/username' --query 'Parameter.Value' --output text)" >> /bin/askpass.sh
  - echo "echo password=$(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/token' --with-decryption --query 'Parameter.Value' --output text)" >> /bin/askpass.sh
  - git config --system credential.helper "/bin/bash /bin/askpass.sh"

  - [ sh, -c, "echo 'Retrieve ansible from GIT'" ]
  - git clone $(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/host' --query 'Parameter.Value' --output text) ansible
  - cd /ansible
  - git checkout $(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/branch' --query 'Parameter.Value' --output text)
  - cd $(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/playbook/database' --query 'Parameter.Value' --output text)

  - [ sh, -c, "echo 'Run ansible'" ]
  - INSTANCEID="$(curl 169.254.169.254/latest/meta-data/instance-id | tr - _ )"
  - ansible-galaxy collection install community.general
  - ansible-galaxy collection install --force amazon.aws

  - touch /root/vars.yaml
  - [ sh, -c, "echo \"ssm_prefix: ${ssm_prefix}\" >> /root/vars.yaml" ]
  - ansible-playbook main.yaml -e "@/root/vars.yaml" -vvv

  - git config --system --unset credential.helper
  - rm -f /bin/askpass.sh

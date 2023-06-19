#cloud-config
output : { all : '| tee -a /var/log/cloud-init-output.log' }
repo_update: true
repo_upgrade: all
runcmd:
  #!/bin/bash -xe
  - [ sh, -c, "echo 'Deploying version EU Login Mock - 20210604.1000'" ]
  - yum update -y
  - yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  - yum update -y
  - yum install -y git ansible unzip

  - [ sh, -c, "echo 'Installing AWS CLI v2'" ]
  - cd /tmp
  - curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
  - unzip awscliv2.zip
  - ./aws/install -b /usr/bin

  - [ sh, -c, "echo 'Installing pip'" ]
  - curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
  - python get-pip.py
  - rm -f get-pip.py

  - [ sh, -c, "echo 'Installing Boto3 for ansible'" ]
  - pip install boto3 --upgrade

  - [ sh, -c, "echo create Git Config Credential helper" ]
  - echo '#!/bin/bash' > /bin/askpass.sh
  - echo "echo username=$(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/username' --query 'Parameter.Value' --output text)" >> /bin/askpass.sh
  - echo "echo password=$(aws ssm get-parameter --name '/${ssm_prefix}/git/token' --with-decryption --query 'Parameter.Value' --output text)" >> /bin/askpass.sh
  - git config --system credential.helper "/bin/bash /bin/askpass.sh"

  - touch /root/vars.yml
  - [ sh, -c, "echo 'ssm_prefix: ${ssm_prefix}\' >> /root/vars.yml" ]

  - [ sh, -c, "echo 'Retrieve ansible from GIT'" ]
  - git clone $(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/host' --query 'Parameter.Value' --output text) /ansible
  - cd /ansible
  - git checkout $(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/branch' --query 'Parameter.Value' --output text)
  - cd $(aws ssm get-parameter --name '/${ssm_prefix}/ansible/git/playbook/application' --query 'Parameter.Value' --output text)

  - ansible-playbook main.yaml -e "@/root/vars.yaml"

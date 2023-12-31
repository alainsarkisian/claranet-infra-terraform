resource "random_password" "database_password" {
  length           = var.password_lenght
  special          = var.password_allows_special
  override_special = var.password_override_special
}

resource "aws_ssm_parameter" "database_host" {
  name  = "/${var.ssm_prefix}/database/host"
  type  = "String"
  value = var.database_host

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "database_username" {
  name  = "/${var.ssm_prefix}/database/username"
  type  = "String"
  value = var.database_username

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "database_password" {
  name  = "/${var.ssm_prefix}/database/password"
  type  = "SecureString"
  value = random_password.database_password.result

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "database_port" {
  name  = "/${var.ssm_prefix}/database/port"
  type  = "String"
  value = var.database_port

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "database_name" {
  name = "/${var.ssm_prefix}/database/name"
  type = "String"

  value = var.database_name

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ansible_git_username" {
  name  = "/${var.ssm_prefix}/ansible/git/username"
  type  = "String"
  value = "sarkisian-alain"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ansible_git_token" {
  name  = "/${var.ssm_prefix}/ansible/git/token"
  type  = "String"
  value = "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"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ansible_git_host" {
  name  = "/${var.ssm_prefix}/ansible/git/host"
  type  = "String"
  value = "https://github.com/alainsarkisian/claranet-ansible.git"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ansible_git_branch" {
  name  = "/${var.ssm_prefix}/ansible/git/branch"
  type  = "String"
  value = "master"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ansible_git_playbook_database" {
  name  = "/${var.ssm_prefix}/ansible/git/playbook/database"
  type  = "String"
  value = "playbooks/claranet-ansible-playbook-database/"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "ansible_git_playbook_application" {
  name  = "/${var.ssm_prefix}/ansible/git/playbook/application"
  type  = "String"
  value = "playbooks/claranet-ansible-playbook-application/"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "application_port" {
  name  = "/${var.ssm_prefix}/application/port"
  type  = "String"
  value = var.application_port

  lifecycle {
    ignore_changes = [value]
  }
}
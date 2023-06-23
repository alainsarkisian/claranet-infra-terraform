module "ssm_parameters" {
  source = "./modules/ssm_parameters"

  ssm_prefix              = var.ssm_prefix
  password_lenght         = var.password_lenght
  password_allows_special = var.password_allows_special
  database_name           = var.database_name
  database_username       = var.database_username
  database_host           = var.database_host
  database_port           = var.database_port
  application_port        = var.application_port
}

module "alb" {
  source                  = "./modules/alb"
  private_zone_id         = var.private_zone_id
  alb_dns                 = var.alb_dns
  certificate_arn         = var.certificate_arn
  alb_healthy_threshold   = var.alb_healthy_threshold
  alb_unhealthy_threshold = var.alb_unhealthy_threshold
  alb_hc_interval         = var.alb_hc_interval
  vpc_id                  = var.vpc_id
  application_name        = var.application_name
}

module "database" {
  source = "./modules/database"

  ssm_prefix              = var.ssm_prefix
  db_ami_id               = var.db_ami_id
  instance_type           = var.instance_type
  database_key_name       = var.database_key_name
  database_subnet_id      = var.database_subnet_id
  vpc_id                  = var.vpc_id
  database_user_data      = templatefile("./templates/database/user_data.tpl", { ssm_prefix = var.ssm_prefix })
  app_security_group_id   = module.application.app_security_group_id
  db_asg_min_size         = var.db_asg_min_size
  db_asg_max_size         = var.db_asg_max_size
  db_asg_desired_capacity = var.db_asg_desired_capacity
  db_subnet_cidr_block    = var.db_subnet_cidr_block
  database_host           = var.database_host
}

module "application" {
  source = "./modules/application"

  ssm_prefix               = var.ssm_prefix
  ami_id                   = var.ami_id
  instance_type            = var.instance_type
  vpc_id                   = var.vpc_id
  application_key_name     = var.application_key_name
  http_target_group_arn    = module.alb.http_target_group_arn
  application_user_data    = templatefile("./templates/application/user_data.tpl", { ssm_prefix = var.ssm_prefix })
  app_asg_min_size         = var.app_asg_min_size
  app_asg_max_size         = var.app_asg_max_size
  app_asg_desired_capacity = var.app_asg_desired_capacity
  alb_arn                  = module.alb.alb_arn
  app_subnet_cidr_block    = var.app_subnet_cidr_block
  application_subnet_ids   = var.application_subnet_ids
  email                    = var.email
  application_name         = var.application_name
  scaling_threshold        = var.scaling_threshold
}
module "ssm_parameters" {
  source = "./modules/ssm_parameters"

  ssm_prefix              = var.ssm_prefix
  password_lenght         = var.password_lenght
  password_allows_special = var.password_allows_special
  database_name           = var.database_name
  database_username       = var.database_username
  database_host           = var.database_host
  database_port           = var.database_port
}

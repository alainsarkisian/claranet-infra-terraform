##################
#GENERAL
##################
aws_region    = "eu-west-1"
vpc_id        = "to_define"
ssm_prefix    = "claranet"
instance_type = "t3.micro"

##################
#ALB
##################
certificate_arn         = "to_define"
private_zone_id         = "to_define"
alb_dns                 = "claranet.cloud-phoenix-kata"
alb_healthy_threshold   = "3"
alb_unhealthy_threshold = "3"
alb_hc_interval         = "30"

##################
#Application
##################
application_name         = "cloud-phoenix-kata"
ami_id                   = "to_define" #RHEL
application_key_name     = "claranet-keypair-application"
application_port         = "3000"
app_asg_min_size         = "1"
app_asg_max_size         = "10"
app_asg_desired_capacity = "1"
app_subnet_cidr_block    = "to_define"
application_subnet_ids   = ["to_define"]
email                    = "to_define"
scaling_threshold        = "100"

##################
#DATABASE
##################
password_lenght         = 16
password_allows_special = false
database_username       = "kata"
database_host           = "to_define" # private IP for database instance
database_port           = "27017"
database_name           = "kata-db"
database_key_name       = "claranet-keypair-database"
database_subnet_id      = "to_define"
db_ami_id               = "to_define" #RHEL
db_asg_min_size         = "1"
db_asg_max_size         = "1"
db_asg_desired_capacity = "1"
db_subnet_cidr_block    = "to_define"
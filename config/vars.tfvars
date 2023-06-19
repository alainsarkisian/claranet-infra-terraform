aws_region       = "eu-west-1"
vpc_id           = "vpc-0b75047d0ec9301da"
application_name = "cloud-phoenix-kata"

ssm_prefix              = "claranet"
password_lenght         = 16
password_allows_special = false

database_username = "claranet"
database_host     = "to_define"
database_port     = "27017"
database_name     = "claranet"

ami_id             = "ami-020e14de09d1866b4"
instance_type      = "t3.micro"
database_key_name  = "claranet-keypair-database"
database_subnet_id = "subnet-0ba5aa70b6680b21a"


application_subnet_id = "subnet-0ba5aa70b6680b21a"
application_key_name  = "claranet-keypair-application"

private_zone_id = ""
alb_dns         = "claranet.cloud-phoenix-kata"

certificate_arn = ""

alb_healthy_threshold = 3

alb_unhealthy_threshold = 3

alb_hc_interval  = 30
app_asg_min_size = 1

app_asg_max_size = 10

app_asg_desired_capacity = 1
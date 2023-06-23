# resource "tls_private_key" "pk" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "database_key_pair" {
#   key_name   = var.database_key_name
#   public_key = file("templates/key-pairs/claranet.pub")
# }

# resource "local_file" "ssh_key" {
#   filename = "${aws_key_pair.database_key_pair.key_name}.pem"
#   content = tls_private_key.pk.private_key_pem
# }


resource "aws_launch_template" "database_lt" {
  name          = "database-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(var.database_user_data)
  key_name      = "cloud-phoenix-kata-database"

  network_interfaces {
    security_groups             = [aws_security_group.db_sg.id]
    associate_public_ip_address = true
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.database_instance_profile.arn
  }
}

# resource "aws_instance" "database" {

#   vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
#   subnet_id              = var.database_subnet_id

#   launch_template {
#     id      = aws_launch_template.database_lt.id
#     version = aws_launch_template.database_lt.latest_version
#   }
#   iam_instance_profile = aws_iam_instance_profile.database_instance_profile.id

#   tags = {
#     Name = "MongoDB"
#   }
# }

resource "aws_security_group" "db_sg" {
  name        = "database-sg"
  description = "Security group for the database instance"
  vpc_id      = var.vpc_id
  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description              = "MONGODB"
      from_port                = 27017
      to_port                  = 27017
      protocol                 = "tcp"
      cidr_blocks              = ["172.31.0.0/16"]
      source_security_group_id = var.app_security_group_id
      ipv6_cidr_blocks         = []
      prefix_list_ids          = []
      security_groups          = []
      self                     = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "db_autoscaling_group" {
  name                  = "cloud-phoenix-kata-database-autoscaling-group"
  min_size              = var.db_asg_min_size
  max_size              = var.db_asg_max_size
  desired_capacity      = var.db_asg_desired_capacity
  protect_from_scale_in = false

  health_check_grace_period = 1100
  health_check_type         = "EC2"

  termination_policies = ["OldestLaunchTemplate"]
  vpc_zone_identifier  = ["subnet-0ba5aa70b6680b21a", "subnet-0a3e94f1139ff6efe", "subnet-0e4c98ab196e0b120"]

  launch_template {
    id      = aws_launch_template.database_lt.id
    version = aws_launch_template.database_lt.latest_version
  }
  tag {
    key                 = "Name"
    value               = "cloud-phoenix-kata-database"
    propagate_at_launch = true
  }
}
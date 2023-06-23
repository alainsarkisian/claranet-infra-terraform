resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "database_key_pair" {
  key_name   = var.database_key_name
  public_key = file("templates/key-pairs/claranet.pub")
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.database_key_pair.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
}


resource "aws_launch_template" "database_lt" {
  name          = "database-lt"
  image_id      = var.db_ami_id
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

resource "aws_instance" "database" {

  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  subnet_id              = var.database_subnet_id
  private_ip             = var.database_host

  launch_template {
    id      = aws_launch_template.database_lt.id
    version = aws_launch_template.database_lt.latest_version
  }
  iam_instance_profile = aws_iam_instance_profile.database_instance_profile.id

  tags = {
    Name = "MongoDB"
  }
}

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
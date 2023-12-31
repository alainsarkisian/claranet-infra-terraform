resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "application_key_pair" {
  key_name   = var.application_key_name
  public_key = file("templates/key-pairs/claranet-app.pub")
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.application_key_pair.key_name}.pem"
  content  = tls_private_key.pk.private_key_pem
}

resource "aws_launch_template" "application_lt" {
  name          = "application-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(var.application_user_data)
  key_name      = "cloud-phoenix-kata-application"
  network_interfaces {
    security_groups             = [aws_security_group.app_sg.id]
    associate_public_ip_address = true
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.app_instance_profile.arn
  }
}

resource "aws_autoscaling_group" "app_autoscaling_group" {
  name                  = "${var.application_name}-app-autoscaling-group"
  min_size              = var.app_asg_min_size
  max_size              = var.app_asg_max_size
  desired_capacity      = var.app_asg_desired_capacity
  protect_from_scale_in = false

  target_group_arns = [var.http_target_group_arn]

  health_check_grace_period = 1100
  health_check_type         = "EC2"

  termination_policies = ["OldestLaunchTemplate"]
  vpc_zone_identifier  = var.application_subnet_ids

  launch_template {
    id      = aws_launch_template.application_lt.id
    version = aws_launch_template.application_lt.latest_version
  }
  tag {
    key                 = "Name"
    value               = "${var.application_name}-application"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Security group for the app instance"
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
      description      = "HTTP"
      from_port        = 3000
      to_port          = 3000
      protocol         = "tcp"
      cidr_blocks      = ["172.31.0.0/16"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_policy" "app_asg_policy" {
  name                   = "cloud-phoenix-kata-app-autoscaling-group-policy"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.app_autoscaling_group.name

  adjustment_type    = "ChangeInCapacity"
  scaling_adjustment = 1

  cooldown = 300
}

resource "aws_autoscaling_notification" "app_asg_notification" {
  group_names   = [aws_autoscaling_group.app_autoscaling_group.name]
  notifications = ["autoscaling:EC2_INSTANCE_LAUNCH", "autoscaling:EC2_INSTANCE_TERMINATE"]
  topic_arn     = aws_sns_topic.cpu_peak_topic.arn
}
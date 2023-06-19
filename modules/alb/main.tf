resource "aws_lb" "alb" {
  name                             = "${var.application_name}-alb"
  internal                         = false
  load_balancer_type               = "application"
  ip_address_type                  = "ipv4"
  subnets                          = ["subnet-0ba5aa70b6680b21a", "subnet-0a3e94f1139ff6efe", "subnet-0e4c98ab196e0b120"]
  enable_cross_zone_load_balancing = true
  security_groups                  = [aws_security_group.alb_sg.id]

  tags = {
    Name = "${var.application_name}-alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  deregistration_delay = 30
  name                 = "${var.application_name}-alb-tg"
  port                 = 3000
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = var.alb_healthy_threshold
    interval            = var.alb_hc_interval
    path                = "/"
    port                = "3000"
    protocol            = "HTTP"
    unhealthy_threshold = var.alb_unhealthy_threshold
  }

  tags = {
    Name = "${var.application_name}-health-check-http"
  }
}

resource "aws_lb_listener" "alb_listener_http" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.alb.arn

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type             = "forward"
  }

  # default_action {
  #     type = "redirect"
  #     redirect {
  #       port = "443"
  #       protocol = "HTTPS"
  #       status_code = "HTTP_301"
  #     }
  # }
}

# resource "aws_lb_listener" "alb_listener_https" {
#   port = 443
#   protocol = "HTTPS"
#   load_balancer_arn = aws_lb.alb

#   certificate_arn = var.certificate_arn

#   default_action {
#     target_group_arn = aws_lb_target_group.alb_tg
#     type = "forward"
#   }
# }

# resource "aws_route53_record" "dns_record" {
#   zone_id = var.private_zone_id
#   name    = var.alb_dns
#   type    = "A"

#   alias {
#     name                   = aws_lb.alb.dns_name
#     zone_id                = aws_lb.alb.zone_id
#     evaluate_target_health = false
#   }
# }

resource "aws_security_group" "alb_sg" {
  name        = "${var.application_name}-alb-sg"
  description = "security group for ALB"

  vpc_id = var.vpc_id
  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
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
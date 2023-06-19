##########
### IAM
##########
resource "aws_iam_role" "app_role" {
  name = "cloud-pohenix-kata-app-role"

  assume_role_policy = <<-EOF
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
          }
        ]
      }
    EOF

  max_session_duration = 3600
  path                 = "/"

  tags = {
    Name = "cloud-pohenix-kata-app-role"
  }
}

resource "aws_iam_role_policy_attachment" "app_ec2_read_only" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "app_ec2_for_ssm" {
  role       = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy" "app_role_policy" {
  name = "cloud-pohenix-kata-app-role-policy"
  role = aws_iam_role.app_role.id

  policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
            "ssm:GetParameter"
          ],
          "Resource": "*",
          "Effect": "Allow"
        }
      ]
    }
  EOF
}

resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "cloud-pohenix-kata-app-instance-profile"
  path = "/"
  role = aws_iam_role.app_role.id
}
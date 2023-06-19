##########
### IAM
##########
resource "aws_iam_role" "database_role" {
  name = "cloud-pohenix-kata-database-role"

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
    Name = "cloud-pohenix-kata-database-role"
  }
}

resource "aws_iam_role_policy_attachment" "database_ec2_read_only" {
  role       = aws_iam_role.database_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "database_ec2_for_ssm" {
  role       = aws_iam_role.database_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy" "database_role_policy" {
  name = "cloud-pohenix-kata-database-role-policy"
  role = aws_iam_role.database_role.id

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

resource "aws_iam_instance_profile" "database_instance_profile" {
  name = "cloud-pohenix-kata-database-instance-profile"
  path = "/"
  role = aws_iam_role.database_role.id
}
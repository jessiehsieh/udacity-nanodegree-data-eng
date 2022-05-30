/*
resource "aws_iam_role" "Cloud9SSMAccessRole" {
  name = "AWSCloud9SSMAccessRole"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": [
                            "cloud9.amazonaws.com",
                            "ec2.amazonaws.com"
                            ]
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}



resource "aws_iam_policy" "Cloud9SSMPolicy" {
  name        = "AWSCloud9SSMInstanceProfile"
  description = "This policy will be used to attach a role on a InstanceProfile which will allow Cloud9 to use the SSM Session Manager to connect to the instance"

  tags = local.required_tags

  policy = jsonencode(
      {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        }
    ]
}
  )
}


resource "aws_iam_role_policy_attachment" "cloud9_SSM_policy_attach" {
   role       = "${aws_iam_role.Cloud9SSMAccessRole.name}"
   policy_arn = "arn:aws:iam::aws:policy/AWSCloud9SSMInstanceProfile"
}

*/
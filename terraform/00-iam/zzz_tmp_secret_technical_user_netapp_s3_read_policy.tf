# temporary policy to test the technical s3 user, can be deleted after test
/* resource "aws_iam_policy" "tmp_secret_technical_user_netapp_s3_read_policy" {
  name        = "tmp_secret_technical_user_netapp_s3_read_policy"
  description = "allow read technical_user_netapp_s3 secret"
  
  tags = local.required_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
            {
                "Effect" = "Allow",
                "Action" = [
                    "ssm:GetParameters"
                ],
                "Resource" = [
                    data.aws_ssm_parameter.technical_user_netapp_s3.arn,
                ]
            }
        ]
    })
} */
resource "aws_iam_role" "redshift_role" {
  name        = "role_redshift_role"
  description = ""

  tags = local.required_tags

  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = "sts:AssumeRole",
          "Principal" = {
            "Service" = "redshift.amazonaws.com"
          },
          "Effect" = "Allow",
          "Sid"    = "RedshiftAssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "s3_preprocess_bucket_read_write_policy" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = aws_iam_policy.s3_preprocess_bucket_read_write_policy.arn
}

resource "aws_iam_role_policy_attachment" "s3_redshift_log_policy" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = aws_iam_policy.s3_redshift_log_policy.arn
}

resource "aws_iam_role" "redshift_scheduler_role" {
  name        = "role_redshift_scheduler_role"
  description = "allowing the scheduler to assume role"

  tags = local.required_tags

  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = "sts:AssumeRole",
          "Principal" = {
            "Service" = "scheduler.redshift.amazonaws.com"
          },
          "Effect" = "Allow",
          "Sid"    = "RedshiftSchedulerAssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "redshift_scheduler_policy_attachment" {
  role       = aws_iam_role.redshift_scheduler_role.name
  policy_arn = aws_iam_policy.redshift_scheduler_policy.arn
}

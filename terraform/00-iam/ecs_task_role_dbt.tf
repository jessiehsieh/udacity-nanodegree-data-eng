resource "aws_iam_role" "ecs_task_role_dbt" {
  name = "role_ecs_task_role_dbt"

  tags = local.required_tags
  assume_role_policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Action" = "sts:AssumeRole",
          "Principal" = {
            "Service" = "ecs-tasks.amazonaws.com"
          },
          "Effect" = "Allow",
          "Sid"    = "ecsTaskAssumeRole"
        }
      ]
    }
  )
}

# read-write access to S3 DBT SQL Bucket
resource "aws_iam_role_policy_attachment" "s3_dbt_sql_bucket_policy_attachment" {
  role       = aws_iam_role.ecs_task_role_dbt.name
  policy_arn = aws_iam_policy.s3_dbt_sql_bucket_policy.arn
}

# get temp access to redshift from sts 
resource "aws_iam_role_policy_attachment" "redshift_iam_auth_policy_attachment" {
  role       = aws_iam_role.ecs_task_role_dbt.name
  policy_arn = aws_iam_policy.redshift_iam_auth_policy.arn
}

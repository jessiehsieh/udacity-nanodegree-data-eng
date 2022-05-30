resource "aws_iam_role" "ecs_task_role" {
  name = "role_ecs_task_role"

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

# read-only access to S3 Input Bucket
resource "aws_iam_role_policy_attachment" "s3_input_bucket_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.s3_input_bucket_read_only_policy.arn

}

# read-write access to S3 Output Bucket
resource "aws_iam_role_policy_attachment" "s3_output_bucket_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.s3_preprocess_bucket_read_write_policy.arn
}

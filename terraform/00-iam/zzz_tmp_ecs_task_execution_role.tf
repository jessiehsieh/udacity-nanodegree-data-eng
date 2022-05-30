# temporary execution role to test the technical s3 user, can be deleted after test
/* resource "aws_iam_role" "role_tmp_ecs_task_execution_role" {
  name        = "role_tmp_ecs_task_execution_role"
  description = "Used to test the technical user credentials, delete if everything works"

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
          "Sid"    = "ecsTaskExecutionAssumeRole"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "role-tmp-ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.role_tmp_ecs_task_execution_role.name
  policy_arn = aws_iam_policy.tmp_secret_technical_user_netapp_s3_read_policy.arn

}
*/
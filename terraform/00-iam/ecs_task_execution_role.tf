resource "aws_iam_role" "ecs_task_execution_role" {
  name        = "role_ecs_task_execution_role"
  description = "Used to allow ecs to assume a role"

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

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn

}

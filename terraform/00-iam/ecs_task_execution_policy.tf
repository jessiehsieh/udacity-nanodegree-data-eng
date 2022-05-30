resource "aws_iam_policy" "ecs_task_execution" {
  name        = "ecs_task_execution"
  description = "ECS Task Execution Policy, used to be able to execute ECS tasks."

  tags = local.required_tags

  policy = jsonencode(
      {
      Version = "2012-10-17"
      Statement = [
          {
                "Sid" = "ecs2ecrAuthorization"
                "Effect" = "Allow",
                "Action" = [
                    "ecr:GetAuthorizationToken"
              ],
                "Resource": "*"
          },
          {
              "Sid" = "ecsLogAuthorization"
              "Effect" = "Allow",
              "Action" = [
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
              ],
              "Resource": ["arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/ecs/preprocess_input_data:*",
                           "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/ecs/dbt:*",
                           "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/ecs/preprocess_contracts:*",
                           "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/ecs/preprocess_partners:*",
                           "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/ecs/dbt_copy_contract_tables:*",
                           "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/ecs/dbt_copy_partner_tables:*",
                           "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/ecs/dbt_run:*"
              ]
          },
          {
            "Sid" = "ecs2ecrPullAuthorization"
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage"
            ],
            "Resource": "arn:aws:ecr:${var.region}:${var.account_id}:repository/*",
          },
      ]
    }
  )
}

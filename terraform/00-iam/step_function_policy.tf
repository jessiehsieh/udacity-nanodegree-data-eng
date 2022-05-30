resource "aws_iam_policy" "sfn_execution_policy" {
  name        = "sfn_execution_policy"
  description = ""

  tags = local.required_tags

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowECSrunTask",
        "Effect" : "Allow",
        "Action" : [
          "ecs:RunTask"
        ],
        "Resource" : "arn:aws:ecs:${var.region}:${var.account_id}:task-definition/*"
      },
      {
        "Sid" : "AllowPassRoleToECS",
        "Effect" : "Allow",
        "Action" : [
          "iam:PassRole"
        ],
        "Resource" : ["arn:aws:iam::${var.account_id}:role/role_ecs_task_execution_role",
                      "arn:aws:iam::${var.account_id}:role/role_ecs_task_role"]
      },
      {
        "Action": "iam:PassRole",
        "Effect": "Allow",
        "Resource": [
            "*"
        ],
        "Condition": {
            "StringLike": {
                "iam:PassedToService": "ecs-tasks.amazonaws.com"
            }
        }
    },
      {
        "Sid" : "AllowAnyStopTask",
        "Effect" : "Allow",
        "Action" : [
          "ecs:StopTask",
          "ecs:DescribeTasks"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowSFgetEventsforECSTask",
        "Effect" : "Allow",
        "Action" : [
          "events:PutTargets",
          "events:PutRule",
          "events:DescribeRule"
        ],
        "Resource" : [
          "arn:aws:events:${var.region}:${var.account_id}:rule/StepFunctionsGetEventsForECSTaskRule"
        ]
      },
      {
        "Sid" : "AllowSFLoggingToCloudwatch",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogDelivery",
          "logs:GetLogDelivery",
          "logs:UpdateLogDelivery",
          "logs:DeleteLogDelivery",
          "logs:ListLogDeliveries",
          "logs:PutResourcePolicy",
          "logs:DescribeResourcePolicies",
          "logs:DescribeLogGroups"
        ],
        "Resource" : ["arn:aws:logs:${var.region}:${var.account_id}:*",
                      "arn:aws:logs:${var.region}:${var.account_id}:log-group:*",
                      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/*",
                      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/stepfunction/*",
                      ]
      },
      {
          "Sid": "ListObjectsInBucket",
          "Effect": "Allow",
          "Action": ["s3:ListBucket"],
          "Resource": [data.aws_s3_bucket.preprocessed_bucket.arn]
      },
      {
          "Sid": "AllObjectActions",
          "Effect": "Allow",
          "Action": "s3:*Object*",
          "Resource": ["${data.aws_s3_bucket.preprocessed_bucket.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_policy" "redshift_scheduler_policy" {
  name        = "redshift_scheduler_policy"
  description = "Allows to start/stop/resume all accounts clusters"
  
  tags = local.required_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
        "Sid": "RedshiftScheduler",
        "Effect": "Allow",
        "Action": [
            "redshift:ResizeCluster", 
            "redshift:PauseCluster", 
            "redshift:ResumeCluster"
            ],
        "Resource": ["arn:aws:redshift:${var.region}:${var.account_id}:*"]
        }
        ]
  })
}
# Every Weekday at 21:00
resource "aws_redshift_scheduled_action" "pause_cluster" {
  name     = "redshift-scheduled-action-pause"
  schedule = "cron(0 20 ? * MON-FRI *)"
  iam_role = data.aws_iam_role.redshift_scheduler_role.arn

  target_action {
    pause_cluster {
      cluster_identifier = aws_redshift_cluster.si_mdh.cluster_identifier
    }
  }
}

# Every Weekday at 08:00
resource "aws_redshift_scheduled_action" "resume_cluster" {
  name     = "redshift-scheduled-action-resume"
  schedule = "cron(0 7 ? * MON-FRI *)"
  iam_role = data.aws_iam_role.redshift_scheduler_role.arn

  target_action {
    resume_cluster {
      cluster_identifier = aws_redshift_cluster.si_mdh.cluster_identifier
    }
  }
}
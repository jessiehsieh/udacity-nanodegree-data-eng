/*
######## Kept for backup purposes

data "aws_iam_policy_document" "redshift_audit_logs_put" {
    statement {
            sid = "Put bucket policy needed for audit logging"
            effect = "Allow"
            principals {
                type = "Service"
                identifiers = ["redshift.eu-central-1.amazonaws.com"]
            }
            actions = [
                "s3:PutObject",
                "s3:GetBucketAcl"
            ]
            resources = [aws_s3_bucket.redshift_audit_logs_bucket.arn]
            condition {
                test = "StringEquals"
                variable = "aws:SourceArn"
                values = [aws_redshift_cluster.si_mdh.arn,
                          "${aws_redshift_cluster.si_mdh.arn}/*"]
                }
            }
}
*/
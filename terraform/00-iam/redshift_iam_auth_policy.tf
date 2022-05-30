resource "aws_iam_policy" "redshift_iam_auth_policy" {
  name        = "redshift_iam_auth_policy"
  description = "Allows to get temporary credentials from sts"
  
  tags = local.required_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
          {
          "Sid": "GetClusterCredsStatement",
            "Effect": "Allow",
            "Action": [
              "redshift:GetClusterCredentials",
              "redshift:DescribeClusters",
              #"redshift:DbGroups",
            ],
            "Resource": [
              "arn:aws:redshift:${var.region}:${var.account_id}:*"
            ]
          },
          {
          "Sid": "AllowEverythingRedshift",
            "Effect": "Allow",
            "Action": [
              "redshift:*"
            ],
            "Resource": [
              "arn:aws:redshift:${var.region}:${var.account_id}:*"
            ]
          },
          {
          "Sid": "DenyClusterLevelActions",
            "Effect": "Deny",
            "Action": [
              "redshift:CreateCluster",
              "redshift:ModifyCluster",
              "redshift:DeleteCluster",
              "redshift:RebootCluster",

            ],
            "Resource": [
              "arn:aws:redshift:${var.region}:${var.account_id}:*"
            ]
          },
          {
          "Sid": "AllowEverythingRedshiftData",
            "Effect": "Allow",
            "Action": [
              "redshift-data:*"
            ],
            "Resource": [
              "arn:aws:redshift:${var.region}:${var.account_id}:*"
            ]
          },
    ]
  })
}

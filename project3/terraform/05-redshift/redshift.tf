resource "aws_redshift_subnet_group" "redshift" {
    name       = "main-redshift-subnet-group"
    subnet_ids = data.aws_subnet_ids.data.ids
    tags = merge(local.required_tags,
    {
      Name = "Subnet Group defining allowed subnets to use"
    }
  )
}

resource "aws_redshift_parameter_group" "mdh_cluster_parameter_group" {
  name   = "mdh-cluster-parameter-group"
  family = "redshift-1.0"
  parameter {
    name  = "require_ssl"
    value = "true"
  }
}


resource "aws_redshift_cluster" "si_mdh" {
  cluster_identifier = "mdh-cluster"
  database_name      = "mdh"
  master_username    = jsondecode(data.aws_secretsmanager_secret_version.redshift_admin.secret_string)["username"]
  master_password    = jsondecode(data.aws_secretsmanager_secret_version.redshift_admin.secret_string)["password"]
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift.name
  cluster_parameter_group_name = aws_redshift_parameter_group.mdh_cluster_parameter_group.id
  skip_final_snapshot = false
  final_snapshot_identifier = "mdh-cluster-final-snaphot"
  # Use the snapshot_identifier/snapshot_cluster_identifier to restore the cluster from the latest snapshot
  #snapshot_identifier = "mdh-cluster-final-snaphot"
  #snapshot_cluster_identifier = "mdh"
  number_of_nodes = 1
  encrypted = true
  kms_key_id = data.aws_kms_key.external_master_encryption_key.arn
  enhanced_vpc_routing = true
  publicly_accessible = false
  iam_roles = [data.aws_iam_role.redshift_role.arn]
  /*logging {
      enable = true
      bucket_name = data.aws_s3_bucket.redshift_audit_logs_bucket.id
      s3_key_prefix = "logs" 
  }*/
  tags = local.required_tags
}

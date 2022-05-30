#### Caller / Admin Role
data "aws_caller_identity" "current" {}

data "aws_iam_roles" "roles" {
  name_regex = ".*siCompliantAdmin.*"
}

data "aws_iam_role" "si_compliant_admin" {
  name = element(tolist(data.aws_iam_roles.roles.names),0)
}

#### Networking
data "aws_vpcs" "vpcs" {
  tags = {
    stage = "${var.stage}"
  }
}

data "aws_vpc" "vpc" {
  id = "${element(tolist(data.aws_vpcs.vpcs.ids), 0)}"
}

data "aws_availability_zones" "zones" {
    all_availability_zones = true
}

data "aws_subnet_ids" "connectivity" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:tier"
    values = ["connectivity"]
  }
}

data "aws_subnet_ids" "app" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:tier"
    values = ["app"]
  }
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:tier"
    values = ["data"]
  }
}

data "aws_subnet_ids" "attachment" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:tier"
    values = ["attachment"]
  }
}

data "aws_kms_key" "external_master_encryption_key" {
    key_id = "alias/${local.required_tags["stage"]}-external-master-encryption-key"
}
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

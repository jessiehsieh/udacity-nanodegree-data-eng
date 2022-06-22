resource "aws_security_group" "sg_vpc_endpoints" {
  name        = "sg_vpc_endpoints"
  description = "Security groups vpc endpoints: Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  tags = local.required_tags

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
    # ipv6_cidr_blocks = [data.aws_vpc.sandbox_vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
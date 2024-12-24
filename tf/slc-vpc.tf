# https://stackoverflow.com/questions/57099036/terraform-how-to-get-the-vpc-cidr-from-vpc-id

data "aws_vpc" "main" {
  id = module.vpc.vpc_id
}

resource "aws_eip" "nat" {
  count = 1
  domain = "vpc"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.cluster_name}"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
#  private_subnets = ["10.0.0.0/22", "10.0.4.0/22"]
  public_subnets  = ["10.0.100.0/22", "10.0.104.0/22"]

  enable_nat_gateway  = false
  single_nat_gateway  = true
  reuse_nat_ips       = true                    # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = "${aws_eip.nat.*.id}"   # <= IPs specified here as input to the module

  enable_dns_hostnames = true
  map_public_ip_on_launch = true
  

  public_subnet_tags = {
  }

  private_subnet_tags = {
  }

  tags = {
    Terraform = "true"
  }
}


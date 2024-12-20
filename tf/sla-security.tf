# module.vpc.vpc_cidr_block

module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.cluster_name}"
  vpc_id      = module.vpc.vpc_id
  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = 8080
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = var.your_ip_cidr
    },
    {  
      rule        = "ssh-tcp"
      cidr_blocks = var.your_ip_cidr
    },
  ]
  
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  

}
# https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest



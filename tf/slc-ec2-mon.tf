module "slc-mon" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["prometheus"])
  name = "slc-${each.key}"

  instance_type          = "c7g.xlarge"
  ami                    = data.aws_ami.ubuntu-arm.id
  key_name               = var.key_pair
  monitoring             = true
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[1]
  associate_public_ip_address	= "true" 

  root_block_device      = [ 
    {
      volume_size = 40       # in GB 
      volume_type = "gp3"
    }
  ]
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}




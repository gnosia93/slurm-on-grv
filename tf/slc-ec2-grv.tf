data "aws_ami" "ubuntu-arm" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
  #  values = ["ubuntu-pro-server/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-pro-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu-x86" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
   # values = ["ubuntu-pro-server/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-pro-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "slc-mst" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["mst", "client"])
  name = "slc-${each.key}"

  instance_type          = "c7g.2xlarge"
  ami                    = data.aws_ami.ubuntu-arm.id
  key_name               = var.key_pair
  monitoring             = true
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address	= "true" 

  root_block_device      = [ 
    {
      volume_size = 100       # in GB 
      volume_type = "gp3"
    }
  ]
  
  user_data              = templatefile("${path.module}/userdata.tpl", {
     EFS_ID = module.efs.id,
     HOST_NAME = "slc-${each.key}"
  })

  depends_on = [ module.efs ]

 
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "slc-wg" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["wg1", "wg2"])
  name = "slc-${each.key}"

  instance_type          = "c7g.4xlarge"
  ami                    = data.aws_ami.ubuntu-arm.id
  key_name               = var.key_pair
  monitoring             = true
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address	= "true" 

  root_block_device      = [ 
    {
      volume_size = 100       # in GB 
      volume_type = "gp3"
    }
  ]

  user_data              = templatefile("${path.module}/userdata.tpl", {
      EFS_ID = module.efs.id,
      HOST_NAME = "slc-${each.key}"
  })

  depends_on = [ module.efs ]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


output "master" {
  value = module.slc-mst.instnace[0].public_ip
}

output "client" {
  value = module.slc-mst.instnace[1].public_ip
}

output "graviton-workers" {
  value = [for instance in module.slc-wg : instance.public_ip]
}





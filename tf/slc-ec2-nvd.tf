data "aws_ami" "ubuntu-arm64-nvidia" {
  most_recent = true
  owners      = ["898082745236"]

  filter {
    name   = "name"
    values = ["Deep Learning ARM64 Base OSS Nvidia Driver GPU AMI (Ubuntu 22.04)*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "slc-wn" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["wn1", "wn2"])
  name = "slc-${each.key}"

  instance_type          = "g5g.xlarge"
 # ami                    = data.aws_ami.ubuntu-arm64-nvidia.id
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

output "nvidia-workers" {
  value = [for instance in module.slc-wn : instance.public_ip]
}



/*
output "efs-id" {
  value = module.efs.id
}
*/


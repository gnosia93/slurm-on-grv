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


module "slurm-master" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["mst"])
  name = "sl-${each.key}"

  instance_type          = "c6g.xlarge"
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
     EFS_ID = module.efs.id
  })

  depends_on = [ module.efs ]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "slurm-worker-grv" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["w1", "w2", "w3"])
  name = "sle-${each.key}"

  instance_type          = "g5g.xlarge"
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
      EFS_ID = module.efs.id
  })

  depends_on = [ module.efs ]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "slurm-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["w1", "w2", "w3"])
  name = "slx-${each.key}"

  instance_type          = "g5g.xlarge"
  ami                    = data.aws_ami.ubuntu-arm64-nvidia.id
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
      EFS_ID = module.efs.id
  })

  depends_on = [ module.efs ]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "master" {
  value = [for instance in module.slurm-master : instance.public_ip]
}

output "workers-cpu" {
  value = [for instance in module.slurm-worker-grv : instance.public_ip]
}

output "workers-gpu" {
  value = [for instance in module.slurm-worker : instance.public_ip]
}

# tolist(setunion([var.your_ip_cidr], var.github_webhook_ips))
output "efs-id" {
  value = module.efs.id
}


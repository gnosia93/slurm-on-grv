data "aws_ami" "ubuntu-arm" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-pro-server/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-pro-server-*"]
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
    values = ["ubuntu-pro-server/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-pro-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



module "slurm-master" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["mst"])
  name = "sla-${each.key}"

  instance_type          = "c6g.xlarge"
  ami                    = data.aws_ami.ubuntu-arm.id
  key_name               = var.key_pair
  monitoring             = true
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address	= "true" 
  user_data              = <<_DATA
#! /bin/bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt install -y jq
sudo apt install -y awscli
sudo apt install -y openjdk-17-jdk-headless
sudo apt install -y awscli
sudo apt install -y apache2-utils
sudo apt install -y net-tools
_DATA

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "slurm-worker" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["w1", "w2", "w3"])
  name = "sla-${each.key}"

  instance_type          = "g5g.xlarge"
  ami                    = data.aws_ami.ubuntu-arm.id
  key_name               = var.key_pair
  monitoring             = true
  vpc_security_group_ids = [module.ec2_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address	= "true" 
  user_data              = <<_DATA
#! /bin/bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt install -y jq
sudo apt install -y awscli
sudo apt install -y openjdk-17-jdk-headless
sudo apt install -y awscli
sudo apt install -y apache2-utils
sudo apt install -y net-tools
_DATA

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "master" {
  value = [for instance in module.slurm-master : instance.public_ip]
}

output "workers" {
  value = [for instance in module.slurm-worker : instance.public_ip]
}




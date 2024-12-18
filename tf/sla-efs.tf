
module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name           = "slurm-fs"

  # performance_mode                = "maxIO"
  # NB! PROVISIONED TROUGHPUT MODE WITH 256 MIBPS IS EXPENSIVE ~$1500/month
  # throughput_mode                 = "provisioned"
  # provisioned_throughput_in_mibps = 256

  # File system policy
  /*
  attach_policy                      = true
  bypass_policy_lockout_safety_check = false
  policy_statements = [
    {
      sid     = "Example"
      actions = ["elasticfilesystem:ClientMount"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::111122223333:role/EfsReadOnly"]
        }
      ]
    }
  ]
  */

  # Mount targets / security group
  mount_targets = {
    "ap-northeast-2" = {
      subnet_id = module.vpc.public_subnets[0]
    }
    "ap-northeast-2" = {
      subnet_id = module.vpc.public_subnets[1]
    }
  }
  
  security_group_description = "EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC public subnets"
      cidr_blocks = ["10.0.100.0/22", "10.0.104.0/22"]
    }
  }

  # Access point(s)
  access_points = {
    root_example = {
      root_directory = {
        path = "/data"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  } 

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

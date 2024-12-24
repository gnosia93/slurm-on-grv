# https://registry.terraform.io/modules/terraform-aws-modules/fsx/aws/latest/submodules/lustre

/*
module "lustre_persist" {
  source = "terraform-aws-modules/fsx/aws//modules/lustre"

  name = "lustre_persist"

  # File system
  automatic_backup_retention_days = 0
  data_compression_type           = "LZ4"
  deployment_type                 = "PERSISTENT_1"
  file_system_type_version        = "2.12"

  log_configuration = {
    level = "ERROR_ONLY"
  }

  per_unit_storage_throughput = 50

  root_squash_configuration = {
    root_squash = "365534:65534"
  }

  storage_capacity              = 1200
  storage_type                  = "SSD"
  subnet_ids                    = [ module.vpc.public_subnets[1] ]

  # Data Repository Association(s)

  data_repository_associations = {
    example = {
      batch_import_meta_data_on_create = true
      data_repository_path             = "s3://example-s3-bucket"
      delete_data_in_filesystem        = false
      file_system_path                 = "/persistent1/data"
      imported_file_chunk_size         = 128

      s3 = {
        auto_export_policy = {
          events = ["NEW", "CHANGED", "DELETED"]
        }

        auto_import_policy = {
          events = ["NEW", "CHANGED", "DELETED"]
        }
      }
    }
  }
  

  # Security group
  security_group_ingress_rules = {
    in = {
      cidr_ipv4   = module.vpc.vpc_cidr_block 
      from_port   = 0
      to_port     = 0
      protocol    = "tcp"
    }
  }
  security_group_egress_rules = {
    out = {
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all traffic"
      ip_protocol = "-1"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
*/

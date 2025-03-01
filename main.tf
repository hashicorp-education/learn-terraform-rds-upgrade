# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      HashiCorpLearnTutorial = "rds-upgrade"
    }
  }
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name                 = "${random_pet.name.id}-education"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "random_pet" "name" {
  length = 1
}

resource "aws_db_subnet_group" "education" {
  name       = "${random_pet.name.id}-education"
  subnet_ids = module.vpc.public_subnets
}

resource "aws_security_group" "rds" {
  name   = "${random_pet.name.id}-education"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_parameter_group" "education" {
  name_prefix = "${random_pet.name.id}-education"
  family      = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

ephemeral "random_password" "db_password" {
  length  = 16
  special = false
}

locals {
  # Increment db_password_version to update the DB password and store the new
  # password in SSM.
  db_password_version = 1
}

resource "aws_db_instance" "education" {
  identifier                  = "${random_pet.name.id}-education"
  instance_class              = "db.t3.micro"
  allocated_storage           = 10
  apply_immediately           = true
  engine                      = "postgres"
  engine_version              = "15"
  username                    = "edu"
  password_wo                 = ephemeral.random_password.db_password.result
  password_wo_version         = local.db_password_version
  allow_major_version_upgrade = true
  db_subnet_group_name        = aws_db_subnet_group.education.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  parameter_group_name        = aws_db_parameter_group.education.name
  publicly_accessible         = true
  skip_final_snapshot         = true
  backup_retention_period     = 1
}

resource "aws_ssm_parameter" "secret" {
  name             = "/education/database/password/master"
  description      = "Password for RDS database."
  type             = "SecureString"
  value_wo         = ephemeral.random_password.db_password.result
  value_wo_version = local.db_password_version
}

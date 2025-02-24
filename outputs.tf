# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "region" {
  description = "AWS region for all resources."
  value       = var.region
}

output "rds_hostname" {
  description = "RDS instance hostname."
  value       = aws_db_instance.education.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port."
  value       = aws_db_instance.education.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance username."
  value       = aws_db_instance.education.username
  sensitive   = true
}

output "random_pet_name" {
  description = "Value of random pet name in configuration, used to ensure resource names are unique."
  value       = random_pet.name.id
}

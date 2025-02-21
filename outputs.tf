# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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

# output "rds_pre_16_backup_identifier" {
#   description = "Identifier of the snapshot created before upgrading RDS database to PostgreSQL 16."
#   value       = aws_db_snapshot.pre_16_upgrade.db_snapshot_identifier
# }

# output "rds_pre_16_backup_status" {
#   description = "Status of the snapshot created beforeupgradingRDS database to PostgreSQL 16."
#   value       = aws_db_snapshot.pre_16_upgrade.status
# }

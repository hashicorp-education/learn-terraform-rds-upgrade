# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region for all resources."
  default     = "us-east-2"
}

variable "db_password" {
  description = "RDS user password."
  default     = ""
  ephemeral   = true
}

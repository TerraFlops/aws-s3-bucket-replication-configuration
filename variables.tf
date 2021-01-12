variable "name" {
  type = string
  description = "Name for the replication rule"
}

variable "enabled" {
  type = bool
  description = "Boolean flag to enable/disable replication, defaults to true"
  default = true
}

variable "source_aws_account_id" {
  type = string
  description = "The AWS account ID where the source bucket is located"
}

variable "source_bucket_name" {
  type = string
  description = "The replication source bucket name"
}

variable "source_bucket_prefix" {
  type = string
  description = "Optional prefix for source bucket replication"
  default = ""
}

variable "destination_bucket_names" {
  type = map(string)
  description = "Map of destination bucket names and the storage class that will be applied to replicated files"
}
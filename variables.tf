variable "name" {
  type = string
  description = "Name for the replication rule"
}

variable "enabled" {
  type = bool
  description = "Boolean flag to enable/disable replication, defaults to true"
  default = true
}

variable "aws_account_id" {
  type = string
  description = "The AWS account ID where the source bucket is located"
}

variable "bucket_name" {
  type = string
  description = "The replication source bucket name"
}

variable "bucket_prefix" {
  type = string
  description = "Optional prefix for source bucket replication"
  default = ""
}

variable "destinations" {
  type = list(object({
    aws_account_id = string
    bucket_name = string
    storage_class = string
  }))
  description = "Map of destination bucket configurations"
}
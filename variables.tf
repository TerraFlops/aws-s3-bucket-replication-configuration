variable "enabled" {
  type = bool
  description = "Boolean flag to enable/disable replication, defaults to true"
  default = true
}

variable "source_aws_account_id" {
  type = string
  description = "The AWS account ID where the source bucket is located"
}

variable "source_iam_role_name" {
  type = string
  description = "If specified a source IAM role will be created with this name"
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
  type = set(string)
  description = "Set of destination bucket names to this the source will be replicated"
}

variable "destination_bucket_storage_class" {
  type = string
  description = "Override for destination bucket storage class, defaults to STANDARD"
  default = "STANDARD"
}
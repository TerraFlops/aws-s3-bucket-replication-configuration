variable "source_aws_account_id" {
  type = string
  description = "The AWS account ID where the source bucket is located"
}

variable "source_iam_role_name" {
  type = string
  description = "If specified a source IAM role will be created with this name"
  default = null
}

variable "source_bucket_name" {
  type = string
  description = "The replication source bucket name"
}

variable "destination_bucket_names" {
  type = set(string)
  description = "Set of destination bucket names to this the source will be replicated"
}

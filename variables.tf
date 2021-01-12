variable "source_aws_account_id" {
  type = string
  description = "The AWS account ID where the source bucket is located"
}

variable "c" {
  type = string
  description = "The replication source bucket name"
}

variable "destination_bucket_name" {
  type = string
  description = "The replication destination bucket name"
}
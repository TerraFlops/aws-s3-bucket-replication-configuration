output "name" {
  description = "Name for the replication rule"
  value = var.name
}

output "rule" {
  description = "Map that can be used to populate S3 bucket replication configuration rule block"
  value = {
    status = var.enabled == true ? "Enabled" : "Disabled"
    prefix = var.source_bucket_prefix
    destinations = [
      for destination_bucket_name, storage_class in var.destination_bucket_names: {
          bucket = destination_bucket_name
          storage_class = storage_class
        }
    ]
  }
}

output "source_iam_role_assume_policy" {
  description = "The assume role policy that needs to be applied to the source bucket in the replication pair"
  value = data.aws_iam_policy_document.source_iam_role_assume_policy.json
}

output "source_iam_role_policy" {
  description = "The replication policy that needs to be applied to the IAM role in the source account in the replication pair"
  value = data.aws_iam_policy_document.source_iam_role_policy.json
}

output "source_iam_role_arn" {
  description = "The source replication IAM roles ARN"
  value = aws_iam_role.source_iam_role.arn
}

output "source_bucket_arn" {
  description = "The source S3 buckets ARN"
  value = local.source_bucket_arn
}

output "source_bucket_prefix" {
  description = "The source S3 buckets prefix for replication"
  value = var.source_bucket_prefix
}

output "destination_bucket_policy" {
  description = "The replication policy that needs to be applied to the destination bucket in the replication pair"
  value = data.aws_iam_policy_document.destination_bucket_policy.json
}

output "destination_bucket_iam_role_policy" {
  description = "The replication policy that needs to be applied to the destination bucket in the replication pair"
  value = data.aws_iam_policy_document.destination_bucket_policy.json
}

output "destination_bucket_arns" {
  description = "The destination S3 buckets ARNs"
  value = local.destination_bucket_arns
}

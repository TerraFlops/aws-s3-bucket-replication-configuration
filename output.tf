output "name" {
  description = "Name for the replication rule"
  value = var.name
}

output "rules" {
  description = "Map that can be used to populate S3 bucket replication configuration rule blocks"
  value = [
    for priority, destination in var.destinations: {
      id = "${var.name}${tonumber(priority) + 1}"
      status = var.enabled == true ? "Enabled" : "Disabled"
      # prefix = var.bucket_prefix
      priority = length(var.destinations) > 1 ? tonumber(priority) + 1 : 0
      filter = {
        prefix = var.bucket_prefix
      }
      destination = {
        account_id = destination["aws_account_id"]
        bucket = "arn:aws:s3:::${destination["bucket_name"]}"
        storage_class = destination["storage_class"]
        access_control_translation = {
          owner = "Destination"
        }
      }
    }
  ]
}

output "iam_role_policy" {
  description = "The replication policy that needs to be applied to the IAM role in the source account in the replication pair"
  value = data.aws_iam_policy_document.iam_role_policy.json
}

output "iam_role_arn" {
  description = "The source replication IAM roles ARN"
  value = aws_iam_role.iam_role.arn
}

output "bucket_arn" {
  description = "The source S3 buckets ARN"
  value = local.bucket_arn
}

output "bucket_prefix" {
  description = "The source S3 buckets prefix for replication"
  value = var.bucket_prefix
}

output "aws_account_id" {
  description = "The AWS account ID where the source bucket is located"
  value = var.aws_account_id
}

output "destination_bucket_arns" {
  value = local.destination_bucket_arns
}


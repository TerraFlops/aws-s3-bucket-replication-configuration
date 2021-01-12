output "source_iam_role_assume_policy" {
  description = "The assume role policy that needs to be applied to the source bucket in the replication pair"
  value = data.aws_iam_policy_document.source_iam_role_assume_policy.json
}

output "source_iam_role_policy" {
  description = "The replication policy that needs to be applied to the IAM role in the source account in the replication pair"
  value = data.aws_iam_policy_document.source_iam_role_policy.json
}

output "destination_bucket_policy" {
  description = "The replication policy that needs to be applied to the destination bucket in the replication pair"
  value = data.aws_iam_policy_document.destination_bucket_policy.json
}

output "source_iam_role_arn" {
  description = "If an IAM role for the replication source was created this will contain its ARN, otherwise it will be null"
  value = var.source_iam_role_name == null ? null : aws_iam_role.source_iam_role[0].arn
}
output "replication_source_assume_role_policy" {
  description = "The assume role policy that needs to be applied to the source bucket in the replication pair"
  value = data.aws_iam_policy_document.replication_source_assume_role_policy.json
}

output "replication_source_iam_role_policy" {
  description = "The replication policy that needs to be applied to the IAM role in the source account in the replication pair"
  value = data.aws_iam_policy_document.replication_source_iam_role.json
}

output "replication_destination_policy" {
  description = "The replication policy that needs to be applied to the destination bucket in the replication pair"
  value = data.aws_iam_policy_document.replication_destination.json
}

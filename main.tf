locals {
  s3_service_root_arn = "arn:aws:iam::${var.aws_account_id}:root"
  bucket_arn = "arn:aws:s3:::${var.bucket_name}"
  destination_bucket_arns = toset([for destination in var.destinations: "arn:aws:s3:::${destination["bucket_name"]}"])
}

# Create policy document allowing S3 service to assume the IAM role
data "aws_iam_policy_document" "iam_role_assume_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "s3.amazonaws.com"
      ]
      type = "Service"
    }
    actions = [
      "sts:AssumeRole"
    ]
  }
}

# Create policy for the source account replication
data "aws_iam_policy_document" "iam_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      local.bucket_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    resources = [
      "${local.bucket_arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = concat(
      destination_bucket_arns,
      [ for destination_bucket_arn in destination_bucket_arns: "${destination_bucket_arn}/*" ]
    )
  }
}

# Create the IAM role that will be used to perform replication from the source account
resource "aws_iam_role" "iam_role" {
  name = "${var.name}Role"
  assume_role_policy = data.aws_iam_policy_document.iam_role_assume_policy.json
}

# Attach the policy to this newly created role
resource "aws_iam_role_policy" "iam_role" {
  name = "${var.name}Policy"
  policy = data.aws_iam_policy_document.iam_role_policy.json
  role = aws_iam_role.iam_role.name
}
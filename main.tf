locals {
  source_s3_service_root_arn = "arn:aws:iam::${var.source_aws_account_id}:root"
  source_bucket_arn = "arn:aws:s3:::${var.source_bucket_name}"
  destination_bucket_arns = toset([for destination_bucket_name in var.destination_bucket_names: "arn:aws:s3:::${destination_bucket_name}"])
}

# Create policy document allowing S3 service to assume the IAM role
data "aws_iam_policy_document" "source_iam_role_assume_policy" {
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

data "aws_iam_policy_document" "source_iam_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      local.source_bucket_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = [
      "${local.source_bucket_arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = [
      "${local.source_bucket_arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "destination_bucket_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        local.source_s3_service_root_arn
      ]
      type = "AWS"
    }
    actions = [
      "s3:ReplicateDelete",
      "s3:ReplicateObject"
    ]
    resources = toset([
      for destination_bucket_arn in local.destination_bucket_arns: "${destination_bucket_arn}/*"
    ])
  }
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        local.source_s3_service_root_arn
      ]
      type = "AWS"
    }
    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]
    resources = local.destination_bucket_arns
  }
}

# If a role name is supplied, create IAM role for replication
resource "aws_iam_role" "source_iam_role" {
  count = var.source_iam_role_name == null ? 0 : 1
  name = var.source_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.source_iam_role_assume_policy
}

# If a role was created, attach the policy to it
resource "aws_iam_role_policy" "source_iam_role" {
  count = var.source_iam_role_name == null ? 0 : 1
  name = "${var.source_iam_role_name}Policy"
  policy = data.aws_iam_policy_document.source_iam_role_policy.json
  role = aws_iam_role.source_iam_role[0].name
}
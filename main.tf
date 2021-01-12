# Create policy document allowing S3 service to assume the IAM role
data "aws_iam_policy_document" "replication_source_iam_role_assume_policy" {
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

data "aws_iam_policy_document" "replication_source_iam_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${var.source_bucket_name}"
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
      "arn:aws:s3:::${var.source_bucket_name}/*"
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
      "arn:aws:s3:::${var.source_bucket_name}/*"
    ]
  }
}

data "aws_iam_policy_document" "replication_destination_bucket_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::${var.source_aws_account_id}:root"
      ]
      type = "AWS"
    }
    actions = [
      "s3:ReplicateDelete",
      "s3:ReplicateObject"
    ]
    resources = [
      "arn:aws:s3:::${var.destination_bucket_name}/*"
    ]
  }
  statement {
    effect = "Allow"
    principals {
      identifiers = [
        "arn:aws:iam::${var.source_aws_account_id}:root"
      ]
      type = "AWS"
    }
    actions = [
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]
    resources = [
      "arn:aws:s3:::${var.destination_bucket_name}"
    ]
  }
}

# If a role name is supplied, create IAM role for replication
resource "aws_iam_role" "source_iam_role" {
  count = var.source_iam_role_name == null ? 0 : 1
  name = var.source_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.replication_source_iam_role_assume_policy
}

# If a role was created, attach the policy to it
resource "aws_iam_role_policy" "source_iam_role" {
  count = var.source_iam_role_name == null ? 0 : 1
  name = "${var.source_iam_role_name}Policy"
  policy = data.aws_iam_policy_document.replication_source_iam_role_policy.json
  role = aws_iam_role.source_iam_role[0].name
}
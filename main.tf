# Create policy document allowing S3 service to assume the IAM role
data "aws_iam_policy_document" "replication_source_assume_role_policy" {
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

data "aws_iam_policy_document" "replication_source" {
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

data "aws_iam_policy_document" "replication_destination" {
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
# Terraflops Terraform Module
 
### AWS S3 Bucket Replication Policy

This module can be used to generate the S3 bucket/IAM role policy statements for cross-account replication

#### Example usage

```hcl-terraform
module "s3_replication_policy" {
  source = "git::https://github.com/TerraFlops/aws-s3-replication-policy?ref=v1.0"
  source_aws_account_id = "0123456789"
  source_bucket_name = "source.bucket.example.com"
  destination_bucket_name = "destination.bucket.example.com"
}
```

The following JSON statements are output from the module

* replication_source_iam_role_assume_policy
* replication_source_iam_role_policy
* replication_destination_bucket_policy
# Terraflops Terraform Module
 
### AWS S3 Bucket Replication Configuration

This module can be used to create an iterable output used to define an S3 buckets
replication configuration. 

#### Example usage

```hcl-terraform
module "example_replication_configuration" {
  source = "git::https://github.com/TerraFlops/aws-s3-bucket-replication-configuration?ref=v1.19"
  name = "ExampleReplication"
  source_aws_account_id = data.aws_caller_identity.default.account_id
  source_bucket_name = "source.bucket.example.com"
  source_bucket_prefix = "incoming/"
  destination_bucket_names = {
    "first.destination.bucket.example.com" = "STANDARD",
    "second.destination.bucket.example.com" = "STANDARD_IA"
  }
}

# Apply the configuration to an S3 bucket

resource "aws_s3_bucket" "source_example_bucket" {
  bucket = "source.bucket.example.com"
  
  # ... Insert bucket configuration ...

  # Configure bucket replication creating a rule for each destination
  replication_configuration {
    role = module.example_replication_configuration.source_iam_role_arn
    dynamic "rules" {
      for_each = module.example_replication_configuration.rules
      content {
        id = rules.value["id"]
        status = rules.value["status"]
        prefix = rules.value["prefix"]
        priority = rules.value["priority"]
        destination {
          bucket = rules.value["destination"]["bucket"]
          storage_class = rules.value["destination"]["storage_class"]
        }
      }
    }
  }
}
```

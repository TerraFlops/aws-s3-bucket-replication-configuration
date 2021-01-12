# Terraflops Terraform Module
 
### AWS S3 Bucket Replication Configuration

This module can be used to create an iterable output used to define an S3 buckets
replication configuration. 

#### Example usage

```hcl-terraform
module "example_replication_configuration" {
  source = "git::https://github.com/TerraFlops/aws-s3-bucket-replication-configuration?ref=v1.26"
  name = "ExampleReplication"
  aws_account_id = data.aws_caller_identity.default.account_id
  bucket_name = "source.bucket.example.com"
  bucket_prefix = "incoming/"
  destinations = [
    {
      aws_account_id = "012345678901"
      bucket_name = "another.bucket.example.com"
      storage_class = "STANDARD"
    }
  ]
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
          account_id = rules.value["destination"]["account_id"]
          access_control_translation {
            owner = rules.value["destination"]["access_control_translation"]["owner"]
          }
        }
      }
    }
  }
}
```

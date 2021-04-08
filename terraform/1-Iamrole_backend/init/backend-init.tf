# S3 bucket as backend 
# DynamoDB table for lock (Prevent conflict)

provider "aws" {
  region = var.AWS_REGION # Please use the default region ID
}

# S3 bucket for backend
resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.account_id}-apnortheast2-tfstate"

  versioning {
    enabled = true # Prevent from deleting tfstate file
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

variable "account_id" {
  default = "dayone-id" # Please use the account alias for id
}


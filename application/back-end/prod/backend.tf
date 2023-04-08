# Define AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "fotopie-terraform.tfstate-bucket"
        key = "prod-terraform.tfstate"
        region = "ap-southeast-2"
    #   dynamodb_table = "terraform-state-lock-dynamodb" 
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name         = "terraform-state-lock-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

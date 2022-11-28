# Terrafrom Block
terraform {
  required_version = "~> 1.3.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.41.0"
     }
  }
}
# Provider Block
provider "aws" {
  region = "ap-south-1"
  profile = "default"  # defining it is optional for default profile
}

# s3 bucket resource
resource "aws_s3_bucket" "first"{

  bucket = "abhijeet-1-s3-bucket"
   
   
   versioning {
    enabled = true
  }



}



resource "aws_s3_bucket_acl" "example1" {

  bucket = aws_s3_bucket.first.id

  acl    = "private"


}

# lifecycle rule

resource "aws_s3_bucket" "abhijeet-1-s3-bucket" {
  bucket = "abhijeet-1-s3"
  acl    = "private"

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  lifecycle_rule {
    id      = "tmp"
    prefix  = "tmp/"
    enabled = true

    expiration {
      date = "2016-01-12"
    }
  }
}

resource "aws_s3_bucket" "versioning_bucket" {
  bucket = "my-versioning-bucket-123"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "config/"
    enabled = true

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}



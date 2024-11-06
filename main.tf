terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"  # change in case you want to work with another AWS account profile
}

resource "aws_instance" "netflix_app" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"

  tags = {
    Name = "Netflix App"
  }
}

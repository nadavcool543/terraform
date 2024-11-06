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
  profile = "default"  
}

resource "aws_key_pair" "netflix_app_key" {
  key_name   = "netflix-app-key"  
  public_key = file("C:/Users/nadav/OneDrive/Desktop/mykey.pub")  
}

resource "aws_instance" "netflix_app" {
  ami           = "ami-06b21ccaeff8cd686"
  instance_type = "t2.nano"
  key_name      = aws_key_pair.netflix_app_key.key_name

  tags = {
    Name       = "Netflix App"
    Environment = "Development"
  }

  security_groups = [aws_security_group.netflix_app_sg.name]
}

resource "aws_security_group" "netflix_app_sg" {
  name        = "netflix-app-sg"   
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ebs_volume" "netflix_app_volume" {
  availability_zone = "us-east-1a"  
  size              = 5              
  tags = {
    Name = "Netflix App Volume"
  }
}

resource "aws_volume_attachment" "netflix_app_volume_attachment" {
  device_name = "/dev/sdf"  
  volume_id   = aws_ebs_volume.netflix_app_volume.id
  instance_id = aws_instance.netflix_app.id
}

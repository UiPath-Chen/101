terraform {
#   required_version = ">= 0.12"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
# export AWS_ACCESS_KEY_ID="anaccesskey"
# export AWS_SECRET_ACCESS_KEY="asecretkey"
# export AWS_REGION="us-west-2"

provider "aws" {
    # region = "us-east-1"
    region = "us-west-2"
    # access_key = "my-access-key"
    # secret_key = "my-secret-key"
}

# Spot instance
# 竞价
data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "this" {
  ami = data.aws_ami.this.id
  instance_market_options {
    spot_options {
      max_price = 0.0031                    # 最大出价
    }
  }
  instance_type = "t4g.nano"
  tags = {
    Name = "test-spot"
  }
}


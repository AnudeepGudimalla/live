terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

terraform {  
  backend "s3" {

    bucket         = "terraform-up-running-state-book"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

resource "aws_db_subnet_group" "example" {
  name       = "example-subnet-group"
  subnet_ids = ["subnet-0dd9e0d65d20758a9", "subnet-05c58f3c0840d8800"]  # Ensure these are in different AZs

  tags = {
    Name = "example-subnet-group"
  }
}


resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  engine_version      = "8.0.39"
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true

  db_name             = "example_database"

  username = var.db_username
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.example.name
  
}
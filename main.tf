#default

terraform {
  backend "s3" {
    bucket         = "mystatepracticebdg"
    key            = "terraform/state.tfstate"
    region         = "us-west-1"
    dynamodb_table = "app-state"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"

  default_tags {
    tags = {
      Owner     = "Eva"
      CreatedBy = "Terraform"
      Course    = "DevOps Intermediate"
    }
  }
}

# Modules

module "network" {
  source = "./modules/network"
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.network.vpc_id
  public_subnet_id  = module.network.public_subnet_id
  public_subnet1_id = module.network.public_subnet1_id
  alb_sg_id         = module.network.alb_sg

}

module "asg" {
  source = "./modules/asg"
  public_subnet_id  = module.network.public_subnet_id
  public_subnet1_id = module.network.public_subnet1_id
  instance_sg_id    = module.network.instance_sg_id
  target_group_arn  = module.alb.tg_arn
}


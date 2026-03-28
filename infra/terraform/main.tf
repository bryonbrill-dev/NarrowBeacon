terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "azurerm" {
  features {}
}

resource "random_pet" "suffix" {
  length = 2
}

locals {
  project_slug = lower(replace(var.project_name, " ", "-"))
}

module "aws_static_site" {
  count = contains(["aws", "both"], var.cloud_target) ? 1 : 0

  source       = "./modules/aws-static-site"
  project_name = local.project_slug
  suffix       = random_pet.suffix.id
  index_html   = var.index_html
  tags         = var.tags
}

module "azure_static_site" {
  count = contains(["azure", "both"], var.cloud_target) ? 1 : 0

  source       = "./modules/azure-static-site"
  project_name = local.project_slug
  suffix       = random_pet.suffix.id
  location     = var.azure_location
  index_html   = var.index_html
  tags         = var.tags
}

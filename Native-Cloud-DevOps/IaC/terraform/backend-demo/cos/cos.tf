terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}


provider "tencentcloud" {
  region     = "ap-guangzhou"
}

# COS bucket
data "tencentcloud_user_info" "info" {}

locals {
  app_id = data.tencentcloud_user_info.info.app_id
}

resource "tencentcloud_cos_bucket" "terraform-state" {
    bucket                  =   "terraform-state-${local.app_id}"
    acl                     =   "private"
    encryption_algorithm    =   "AES256"
}
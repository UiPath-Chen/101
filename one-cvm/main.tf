terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}


# Configure the TencentCloud Provider
# $ export TENCENTCLOUD_SECRET_ID="my-secret-id"
# $ export TENCENTCLOUD_SECRET_KEY="my-secret-key"
# $ export TENCENTCLOUD_REGION="ap-guangzhou"
provider "tencentcloud" {
#   secret_id  = "my-secret-id"
#   secret_key = "my-secret-key"
  # region     = "ap-guangzhou"
  region     = "ap-hongkong"
}

# Get availability zones
# data "tencentcloud_availability_zones" "default" {
data "tencentcloud_availability_zones_by_product" "default" {
    product = "cvm"
}

# Get availability images
data "tencentcloud_images" "default" {
  image_type = ["PUBLIC_IMAGE"]
#   os_name    = "centos"
  os_name    = "ubuntu"
}

# Get availability instance types
data "tencentcloud_instance_types" "default" {
  # 机型
  filter {
    name   = "instance-family"
    # values = ["S1", "S2", "S3", "S4", "S5"]
    values = ["S5"]
  }
  cpu_core_count = 4   # > 4C
  memory_size    = 16  # > 12G
}

# Create server
resource "tencentcloud_instance" "kubernetes_master_nodes" {
  depends_on                 = [tencentcloud_security_group_lite_rule.default]
  instance_name              = "master" # 服务器名称
  availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones.0.name
  image_id                   = data.tencentcloud_images.default.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  system_disk_size           = 50     # >30G
  allocate_public_ip         = true
  internet_max_bandwidth_out = 20
  instance_charge_type       = "SPOTPAID"
  spot_instance_type         = "ONE-TIME"
  spot_max_price             = "0.1"      #
  orderly_security_groups            = [tencentcloud_security_group.default.id]
  password                   = var.password
  count                      = 1
}


# resource "tencentcloud_instance" "kubernetes_worker_nodes" {
#   depends_on                 = [tencentcloud_security_group_lite_rule.default]
#   instance_name              = "web server" # 服务器名称
#   availability_zone          = data.tencentcloud_availability_zones_by_product.default.zones.0.name
#   image_id                   = data.tencentcloud_images.default.images.0.image_id
#   instance_type              = data.tencentcloud_instance_types.default.instance_types.0.instance_type
#   system_disk_type           = "CLOUD_PREMIUM"
#   system_disk_size           = 50
#   allocate_public_ip         = true
#   internet_max_bandwidth_out = 20
#   instance_charge_type       = "SPOTPAID"
#   spot_instance_type         = "ONE-TIME"
#   spot_max_price             = "0.016"      # >=0.016
#   orderly_security_groups            = [tencentcloud_security_group.default.id]
#   password                   = var.password
#   count                      = 1
# }

# Create security group
resource "tencentcloud_security_group" "default" {
  name        = "web accessibility"
  description = "make it accessible for both production and stage ports"
}

# Create security group rule allow ssh request
resource "tencentcloud_security_group_lite_rule" "default" {
  security_group_id = tencentcloud_security_group.default.id
  ingress = [
    "ACCEPT#0.0.0.0/0#22#TCP",
    "ACCEPT#0.0.0.0/0#80#TCP",
    "ACCEPT#0.0.0.0/0#6443#TCP",

    "ACCEPT#0.0.0.0/0#31746#TCP",
    "ACCEPT#0.0.0.0/0#31751#TCP",

    "ACCEPT#0.0.0.0/0#32689#TCP",

    "ACCEPT#0.0.0.0/0#32563#TCP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL"
  ]
}
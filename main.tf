# Configure the HuaweiCloud Provider
provider "huaweicloud" {
  region     = "me-east-1"
  access_key = "MUDXLHNXB11KBWCV1RGU"
  secret_key = "hwsk"
}

data "huaweicloud_availability_zones" "myaz" {}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_images_image" "myimage" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}

data "huaweicloud_vpc_subnet" "mynet" {
  name = "subnet-ecs"
}

data "huaweicloud_networking_secgroup" "mysecgroup" {
  name = "web-mxd-sa-test-dev"
}

resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "!@#$%*12345678"
}
#variable "password" {
#  default = "Test@12345"
#}
resource "huaweicloud_compute_instance" "myinstance" {
  name               = "my-test-terr"
#  admin_pass         = var.password
  admin_pass         = random_password.password.result
  image_id           = data.huaweicloud_images_image.myimage.id
  flavor_id          = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]
  security_group_ids = [data.huaweicloud_networking_secgroup.mysecgroup.id]
  system_disk_type = "SAS"
  system_disk_size = 40
#  system_disk_kms_key_id  = "fb4405e1-e593-423b-9956-ccc4baed08aa"

  network {
    uuid = data.huaweicloud_vpc_subnet.mynet.id
  }
#    user_data = <<-EOF
#    #!/bin/bash
#    timedatectl set-timezone Asia/Riyadh
#    EOF
 }

terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.12.0"
    }
  }
}

provider "ibm" {
  region                = var.region
  visibility            = "private"
  ibmcloud_api_key      = "qFLYymTwV5JfY8CZDPq07qC1eRB2h8hUFSR5eI_y6PMe"
  iaas_classic_username = "2591271_milind@yayzy.com"
  iaas_classic_api_key  = "7a0307836af6fe56519dfffc5e63712c405750e112f840b43f5f694cc77c2139"
}

# Create a VPC
resource "ibm_is_vpc" "terra_test_vpc" {
  name = "terra-test-vpc"
}

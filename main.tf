
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

resource "ibm_is_vpc_routing_table" "terra_test_routing_table" {
  name = "terra-table-routing-table"
  vpc  = ibm_is_vpc.terra_test_vpc.id
}


resource "ibm_is_subnet" "terra_test_subnet" {
  name            = "terra-test-subnet"
  vpc             = ibm_is_vpc.terra_test_vpc.id
  zone            = var.region
  ipv4_cidr_block = "10.240.0.0/24"
  routing_table   = ibm_is_vpc_routing_table.terra_test_routing_table.routing_table

  //User can configure timeouts
  timeouts {
    create = "90m"
    delete = "30m"
  }
}

# Create a Load Balancer
resource "ibm_is_lb" "terra_test_lb" {
  name    = "terra-test-load-balancer"
  subnets = [ibm_is_subnet.terra_test_subnet.id]
  profile = "network-fixed"
}

#   
resource "ibm_is_lb_pool" "terra_test_lb_pool" {
  name           = "terra-test-pool"
  lb             = ibm_is_lb.terra_test_lb.id
  algorithm      = "round_robin"
  protocol       = "https"
  health_delay   = 60
  health_retries = 5
  health_timeout = 30
  health_type    = "https"
  proxy_protocol = "v1"
}

resource "ibm_is_lb_listener" "terra_test_lb_listener" {
  lb       = ibm_is_lb.terra_test_lb.id
  port     = "443"
  protocol = "https"
}

resource "ibm_is_lb_pool_member" "terra_test_lb_pool_member" {
  count          = "2"
  lb             = ibm_is_lb.terra_test_lb.id
  pool           = element(split("/", ibm_is_lb_pool.terra_test_lb_pool.id), 1)
  port           = "80"
  target_address = "192.168.0.1"
  depends_on     = [ibm_is_lb_listener.terra_test_lb_listener]
}

# Communication between VPCs

# Peering is required for internal communication between VPCs.
# However, it is important to note that the CIDRs of the two VPCs peering must not overlap. Transit Gateway is also useful recently, but in this lab, we will establish end-to-end VPC Peering.
# In order to enter into VPC Peering, the Requester must make a Peering request, and the Acceptor must approve the request. After that, the peering ID is stored in the destination IP range and route table.

# Requester: dayonep VPC
# Acceptor: dayoned VPC


# 1.Peering Connection Requester

resource "aws_vpc_peering_connection" "peerings" {
  count         = length(var.vpc_peerings)
  peer_vpc_id   = var.vpc_peerings[count.index]["peer_vpc_id"]
  peer_owner_id = var.vpc_peerings[count.index]["peer_owner_id"]
  peer_region   = var.vpc_peerings[count.index]["peer_region"]
  vpc_id        = aws_vpc.default.id

  tags = {
    Name          = "${var.shard_id}-with-${var.vpc_peerings[count.index]["peer_vpc_name"]}"
    peer_vpc_name = var.vpc_peerings[count.index]["peer_vpc_name"]
    Side          = "Requester"
  }
}


# variable = variables.tf
variable "vpc_peerings" {
  description = "A list of maps containing key/value pairs that define vpc peering."
  type        = list(any)
  default     = []
}

# value = terraform.tfvars
vpc_peerings = [
  {
    peer_vpc_id   = "<< VPC ID >>"
    peer_owner_id = "<< Owner ID >>"
    peer_region   = "<< Region ID >>"
    peer_vpc_name = "<< Peering VPC Name >>"
    vpc_cidr      = "<< VPC CIDR >>"
  }
]




# 2. Acceptor

resource "aws_vpc_peering_connection_accepter" "dayonep_apnortheast2" {
  vpc_peering_connection_id = var.vpc_peer_connection_id_dayonep_apne2
  auto_accept               = true
}

# variable
# peering ID with dayonep VPC
variable "vpc_peer_connection_id_dayonep_apne2" {}
# VPC Peering Connection Variables
vpc_peer_connection_id_dayonep_apne2 = "pcx-xxxx"


# 3. Add route rule

# Routes for public subnet with peering connection
resource "aws_route" "public_peering" {
  count                     = length(var.vpc_peerings)
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.vpc_peerings[count.index]["vpc_cidr"]
  vpc_peering_connection_id = element(aws_vpc_peering_connection.peerings.*.id, count.index)
}

# Routes for private subnet with peering connection
resource "aws_route" "private_peering" {
  count = length(var.vpc_peerings) * length(var.availability_zones)
  route_table_id = element(
    aws_route_table.private.*.id,
    floor(count.index / length(var.vpc_peerings))
  )
  destination_cidr_block = var.vpc_peerings[count.index % length(var.vpc_peerings)]["vpc_cidr"]
  vpc_peering_connection_id = element(
    aws_vpc_peering_connection.peerings.*.id,
    count.index % length(var.vpc_peerings)
  )
}

# Variable
# peering ID with dayoned VPC
variable "vpc_peer_connection_id_dayoned_apne2" {}
variable "dayoned_destination_cidr_block" {}

# Value
# VPC Peering Connection Variables
vpc_peer_connection_id_dayoned_apne2 = "pcx-xxxxx"
dayoned_destination_cidr_block       = "10.10.0.0/16"



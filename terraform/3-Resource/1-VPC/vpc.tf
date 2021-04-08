# Create a security group to be used in common in the VPC.
# We are going to create a Security Group for SSH access from office/home and a Security Group of Bastion Server to access instances in the Private Subnet.
# Security Group ID needs to be subtracted from Output as it is needed to create other resources later.
# If you have a security group that you need in common, you can create additional security groups in this lab.


# Default / Home security group

# 10.0.0.0/8 is the CIDR range we are going to use for all VPC setting
# Default SG: This is a security group that instances should have in common.
# Home SG: This is a security group for setting up only company access to websites that require access control, such as the Admin page and kibana page.

# Default Security Group 
# This is the security group for most of instances should have 
resource "aws_security_group" "default" {
  name        = "default-${var.vpc_name}"
  description = "default group for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  #ingress {
  #  from_port = 80       # You could set additional ingress port 
  #  to_port   = 80
  #  protocol  = "tcp"

  #  cidr_blocks = [
  #    "10.0.0.0/8",
  #  ]
  #}

  # Instance should allow jmx exportor to access for monitoring
  ingress {
    from_port   = 10080
    to_port     = 10080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "inbound rule for jmx exporter"
  }


  # Instance should allow node exporter to access for monitoring
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "inbound rule for node exporter"
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https any outbound"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https any outbound"
  }

  # Instance should allow ifselt to send the log file to kafka
  egress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "kafka any outbound"
  }


  # Instance should allow ifselt to send the log file to elasticsearch
  egress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ElasticSearch any outbound"
  }

}

# Home Security Group 
# This will be usually attached to the web server that users in the office should access through browser..
# This is used for all users in the company to access to the resources in the office or home..
resource "aws_security_group" "home" {
  name        = "home"
  description = "Home Security Group for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0" # Change here to your office or house ...
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0" # Change here to your office or house ...
    ]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https any outbound"
  }
}


# Bastion security group (optional)
# If you are accessing SSH through AWS Session Manager, Teleport, etc. without a bastion server, you do not need to create the following security group.

# Bastion SG: Security group to be used for Bastion server.
# Bastion Aware SG: This is a security group that allows permission to access through Bastion. This security group will be attached to the private instance.

# Security Group to the bastion server
resource "aws_security_group" "bastion" {
  name        = "bastion-${var.vpc_name}"
  description = "Allows SSH access to the bastion server"

  vpc_id = aws_vpc.default.id

  ingress {
    from_port = 22 # Specify the port you use for SSH
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0" # Change here to your office or house ...
    ]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http port any outbound"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https port any outbound"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags = {
    Name = "bastion-${var.vpc_name}"
  }
}

# Security Group from the bastion server
# This will be attached to the private instance which user wants to access through bastion host
resource "aws_security_group" "bastion_aware" {
  name        = "bastion_aware-${var.vpc_name}"
  description = "Allows SSH access from the Bastion server"

  vpc_id = aws_vpc.default.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastionAware-${var.vpc_name}"
  }
}


# Route53 record
# Create an Internal DNS Record for use in the VPC. It is recommended to create each VPC in order to use DNS for internal communication.

resource "aws_route53_zone" "internal" {
  name    = "dayone.internal"
  comment = "${var.vpc_name} - Managed by Terraform"

  vpc {
    vpc_id = aws_vpc.default.id
  }
}


# VPC set

# VPC
# Public Subnet / Private Subnet / DB Subnet(private)
# Elastic IP for NAT
# Route Table
# Internet Gateway
# NAT Gateway


# VPC
# Whole network cidr will be 10.0.0.0/8 
# A VPC cidr will use the B class with 10.xxx.0.0/16
# You should set cidr advertently because if the number of VPC get larger then the ip range could be in shortage.
resource "aws_vpc" "default" {
  cidr_block           = "10.${var.cidr_numeral}.0.0/16" # Please set this according to your company size
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.vpc_name}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}


# NAT Gateway 
resource "aws_nat_gateway" "nat" {
  # Count means how many you want to create the same resource
  # This will be generated with array format
  # For example, if the number of availability zone is three, then nat[0], nat[1], nat[2] will be created.
  # If you want to create each resource with independent name, then you have to copy the same code and modify some code
  count = length(var.availability_zones)

  # element is used for select the resource from the array 
  # Usage = element (array, index) => equals array[index]
  allocation_id = element(aws_eip.nat.*.id, count.index)

  #Subnet Setting
  # nat[0] will be attached to subnet[0]. Same to all index.
  subnet_id = element(aws_subnet.public.*.id, count.index)

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "NAT-GW${count.index}-${var.vpc_name}"
  }

}

# Elastic IP for NAT Gateway 
resource "aws_eip" "nat" {
  # Count value should be same with that of aws_nat_gateway because all nat will get elastic ip
  count = length(var.availability_zones)
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}


#### PUBLIC SUBNETS
# Subnet will use cidr with /20 -> The number of available IP is 4,096  (Including reserved ip from AWS)
resource "aws_subnet" "public" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_public[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)

  # Public IP will be assigned automatically when the instance is launch in the public subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "public${count.index}-${var.vpc_name}"
  }
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "publicrt-${var.vpc_name}"
  }
}


# Route Table Association for public subnets
resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}




#### PRIVATE SUBNETS
# Subnet will use cidr with /20 -> The number of available IP is 4,096  (Including reserved ip from AWS)
resource "aws_subnet" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name               = "private${count.index}-${var.vpc_name}"
    immutable_metadata = "{ \"purpose\": \"internal_${var.vpc_name}\", \"target\": null }"
    Network            = "Private"
  }
}

# Route Table for private subnets
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  tags = {
    Name    = "private${count.index}rt-${var.vpc_name}"
    Network = "Private"
  }
}

# Route Table Association for private subnets
resource "aws_route_table_association" "private" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}


# DB PRIVATE SUBNETS
# This subnet is only for the database. 
# For security, it is better to assign ip range for database only.
# This is also going to use /20 cidr, which might be too many IPs... Please count it carefully and change the cidr.
resource "aws_subnet" "private_db" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  cidr_block        = "10.${var.cidr_numeral}.${var.cidr_numeral_private_db[count.index]}.0/20"
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name               = "db-private${count.index}-${var.vpc_name}"
    immutable_metadata = "{ \"purpose\": \"internal_db_${var.vpc_name}\", \"target\": null }"
    Network            = "Private"
  }
}

# Route Table for DB subnets
resource "aws_route_table" "private_db" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.default.id

  tags = {
    Name    = "privatedb${count.index}rt-${var.vpc_name}"
    Network = "Private"
  }
}

# Route Table Association for DB subnets
resource "aws_route_table_association" "private_db" {
  count          = length(var.availability_zones)
  subnet_id      = element(aws_subnet.private_db.*.id, count.index)
  route_table_id = element(aws_route_table.private_db.*.id, count.index)
}


# Route Table Routes
# You need to register it in the route table so that you can use the IGW and NAT you created earlier. Since we plan to add routes for peering later, the files are separated and managed for convenience.

# routes for internet gateway which will be set in public subent
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# routes for NAT gateway which will be set in private subent
resource "aws_route" "private_nat" {
  count                  = length(var.availability_zones)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
}

# Output
# Resources created in the VPC will be used by other resources in the future.
# All values to be used are added as output.

# Region
output "aws_region" {
  description = "Region of VPC"
  value       = var.aws_region
}

output "region_namespace" {
  description = "Region name without '-'"
  value       = replace(var.aws_region, "-", "")
}

# Availability_zones
output "availability_zones" {
  description = "Availability zone list of VPC"
  value       = var.availability_zones
}

# VPC
output "vpc_name" {
  description = "The name of the VPC which is also the environment name"
  value       = var.vpc_name
}

output "vpc_id" {
  description = "VPC ID of newly created VPC"
  value       = aws_vpc.default.id
}

output "cidr_block" {
  description = "CIDR block of VPC"
  value       = aws_vpc.default.cidr_block
}

output "cidr_numeral" {
  description = "number that specifies the vpc range (B class)"
  value       = var.cidr_numeral
}

# Shard
output "shard_id" {
  description = "The shard ID which will be used to distinguish the env of resources"
  value       = var.shard_id
}

output "shard_short_id" {
  description = "Short version of shard ID"
  value       = var.shard_short_id
}

# Prviate subnets
output "private_subnets" {
  description = "List of private subnet ID in VPC"
  value       = aws_subnet.private.*.id
}

# Public subnets
output "public_subnets" {
  description = "List of public subnet ID in VPC"
  value       = aws_subnet.public.*.id
}

# Private Database Subnets
output "db_private_subnets" {
  description = "List of DB private subnet ID in VPC"
  value       = aws_subnet.private_db.*.id
}

# Route53
output "route53_internal_zone_id" {
  description = "Internal Zone ID for VPC"
  value       = aws_route53_zone.internal.zone_id
}

output "route53_internal_domain" {
  description = "Internal Domain Name for VPC"
  value       = aws_route53_zone.internal.name
}

# Security Group
output "aws_security_group_bastion_id" {
  description = "ID of bastion security group"
  value       = aws_security_group.bastion.id
}

output "aws_security_group_bastion_aware_id" {
  description = "ID of bastion aware security group"
  value       = aws_security_group.bastion_aware.id
}

output "aws_security_group_default_id" {
  description = "ID of default security group"
  value       = aws_security_group.default.id
}

output "aws_security_group_home_id" {
  description = "ID of home security group"
  value       = aws_security_group.home.id
}

# ETC
output "env_suffix" {
  description = "Suffix of the environment"
  value       = var.env_suffix
}

output "billing_tag" {
  description = "The environment value for biliing consolidation."
  value       = var.billing_tag
}


# Production env
# Production environment can be created by proceeding in the same way as the above file setting.
# You only need to change the values in backend.tf and terraform.tfvars to suit your production.




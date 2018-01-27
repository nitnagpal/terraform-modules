terraform {
  required_version = ">= 0.10.8"
}

## VPC ##
resource "aws_vpc" "this" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags {
    Name               = "${var.env}-${var.vpc_name}-vpc"
    Environment        = "${var.env}"
    Terraform = true
  }
}

## DHCP Options ##
resource "aws_vpc_dhcp_options" "this" {
  count = "${var.enable_dhcp_options ? 1 : 0}"
  domain_name         = "${var.domain_name}"
  domain_name_servers = "${var.domain_name_servers}"
  ntp_servers         = "${var.ntp_servers}"
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-dhcp-options"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## DHCP Options Association ##
resource "aws_vpc_dhcp_options_association" "this" {
  count = "${var.enable_dhcp_options ? 1 : 0}"
  vpc_id          = "${aws_vpc.this.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.this.id}"
}

## Default Route Table ##
resource "aws_default_route_table" "this" {
  default_route_table_id = "${aws_vpc.this.default_route_table_id}"
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-default-route"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## Default Security Group ##
resource "aws_default_security_group" "this" {
  vpc_id = "${aws_vpc.this.id}"
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-default-sg"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## Default Network ACL ##
resource "aws_default_network_acl" "this" {
  default_network_acl_id = "${aws_vpc.this.default_network_acl_id}"
  subnet_ids = ["${aws_subnet.private.*.id}", "${aws_subnet.public.*.id}"]
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-default-nacl"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## Internet Gateway ##
resource "aws_internet_gateway" "this" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.this.id}"
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-igw"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## Public Route Table ##
resource "aws_route_table" "public" {
  count = "${length(var.public_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.this.id}"
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-public-route-table"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## Public Route ##
 resource "aws_route" "public" {
   count                  = "${length(var.public_subnets) > 0 ? 1 : 0}"
   route_table_id         = "${aws_route_table.public.id}"
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = "${aws_internet_gateway.this.id}"
 }

 ## Public subnets ##
 resource "aws_subnet" "public" {
   count                   = "${length(var.public_subnets)}"
   vpc_id                  = "${aws_vpc.this.id}"
   cidr_block              = "${var.public_subnets[count.index]}"
   availability_zone       = "${element(var.aws_availability_zones[var.aws_region], count.index % length(var.aws_availability_zones[var.aws_region]))}"
   map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
   tags {
     Name        = "${var.env}-${var.vpc_name}-vpc-public-subnet-${count.index+1}-${element(split("-",element(var.aws_availability_zones[var.aws_region],count.index)), 2)}"
     Environment = "${var.env}"
     Terraform   = true
   }
 }

## Public Route Table Association ##
 resource "aws_route_table_association" "public" {
   count          = "${length(var.public_subnets)}"
   subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
   route_table_id = "${aws_route_table.public.id}"
 }

 ## Private subnets ##
 resource "aws_subnet" "private" {
   count             = "${length(var.private_subnets)}"
   vpc_id            = "${aws_vpc.this.id}"
   cidr_block        = "${var.private_subnets[count.index]}"
   availability_zone = "${element(var.aws_availability_zones[var.aws_region], count.index % length(var.aws_availability_zones[var.aws_region]))}"
   tags {
     Name        = "${var.env}-${var.vpc_name}-vpc-private-subnet-${count.index+1}-${element(split("-",element(var.aws_availability_zones[var.aws_region],count.index)), 2)}"
     Environment = "${var.env}"
     Terraform   = true
   }
 }

## NAT Gateway EIPs ##
 resource "aws_eip" "nat" {
   count = "${var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.aws_availability_zones[var.aws_region])) : 0}"
   vpc = true
   tags {
     Name        = "${var.env}-${var.vpc_name}-vpc-nat-gateway-eip-${count.index+1}"
     Environment = "${var.env}"
     Terraform   = true
   }
 }

## NAT Gateway ##
 resource "aws_nat_gateway" "this" {
   count = "${var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.aws_availability_zones[var.aws_region])) : 0}"
   allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
   subnet_id     = "${element(aws_subnet.public.*.id, (var.single_nat_gateway ? 0 : count.index))}"
   tags {
     Name        = "${var.env}-${var.vpc_name}-vpc-nat-gateway-${count.index+1}"
     Environment = "${var.env}"
     Terraform = true
   }
   lifecycle {
     create_before_destroy = true
   }
   depends_on = ["aws_internet_gateway.this"]
 }

## Private Route Table ##
 resource "aws_route_table" "private" {
   count  = "${length(var.private_subnets) > 0 ? length(var.aws_availability_zones[var.aws_region]) : 0}"
   vpc_id = "${aws_vpc.this.id}"
   tags      {
     Name        = "${var.env}-${var.vpc_name}-vpc-private-route-table-${element(split("-",element(var.aws_availability_zones[var.aws_region],count.index)), 2)}"
     Environment = "${var.env}"
     Terraform   = true
   }
   lifecycle {
     create_before_destroy = true
   }
 }

## Private Route ##
 resource "aws_route" "private" {
   count  = "${(var.enable_nat_gateway && length(var.private_subnets) > 0) ? length(var.aws_availability_zones[var.aws_region]) : 0}"
   route_table_id          = "${element(aws_route_table.private.*.id, count.index)}"
   destination_cidr_block  = "0.0.0.0/0"
   nat_gateway_id          = "${element(aws_nat_gateway.this.*.id, count.index)}"
 }

## Private Route Table Association ##
 resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
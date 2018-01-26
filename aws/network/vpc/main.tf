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
  count  = "${var.enable_internet_gateway ? 1 : 0}"
  vpc_id = "${aws_vpc.this.id}"
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-igw"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## Public Route Table ##
resource "aws_route_table" "public" {
  count  = "${var.enable_internet_gateway ? 1 : 0}"
  vpc_id = "${aws_vpc.this.id}"
  tags {
    Name        = "${var.env}-${var.vpc_name}-vpc-public-route-table"
    Environment = "${var.env}"
    Terraform   = true
  }
}

## Public Route ##
 resource "aws_route" "public" {
   count  = "${var.enable_internet_gateway ? 1 : 0}"
   route_table_id            = "${aws_route_table.public.id}"
   destination_cidr_block    = "0.0.0.0/0"
   gateway_id                = "${aws_internet_gateway.this.id}"
 }
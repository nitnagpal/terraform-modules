output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.this.id}"
}

output "vpc_name" {
  description = "The Name of the VPC"
  value       = "${var.env}-${var.vpc_name}-vpc"
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = "${aws_vpc.this.cidr_block}"
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = "${aws_vpc.this.default_security_group_id}"
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = "${aws_vpc.this.default_network_acl_id}"
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = "${aws_vpc.this.default_route_table_id}"
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${aws_subnet.private.*.id}"]
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = ["${aws_subnet.private.*.cidr_block}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${aws_subnet.public.*.id}"]
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = ["${aws_subnet.public.*.cidr_block}"]
}

## Route tables ##
output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = ["${aws_route_table.public.*.id}"]
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = ["${aws_route_table.private.*.id}"]
}

## Nat Gateway ##
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${aws_eip.nat.*.public_ip}"]
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = ["${aws_nat_gateway.this.*.id}"]
}

## Internet Gateway ##
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = "${var.enable_internet_gateway == 0 ? "" : aws_internet_gateway.this.id}"
}

output "public_route_table_id" {
  description = "The ID of the default public route table"
  value       = "${var.enable_internet_gateway == 0 ? "" : aws_route_table.public.id}"
}
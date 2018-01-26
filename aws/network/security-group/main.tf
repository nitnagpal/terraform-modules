terraform {
  required_version = ">= 0.10.8"
}

## Security Group ##
resource "aws_security_group" "this" {
  name         = "${var.env}-${var.name}-sg"
  description  = "${var.description}"
  vpc_id       = "${var.vpc_id}"
  tags {
    Name            = "${var.env}-${var.name}-sg"
    Environment     = "${var.env}"
    Terraform       = true
  }
}

## Security Group Ingress with CIDR ##
resource "aws_security_group_rule" "ingress-cidr" {
  count                    = "${length(var.ingress_cidr_from_ports)}"
  type                     = "ingress"
  from_port                = "${element(var.ingress_cidr_from_ports, count.index)}"
  to_port                  = "${element(var.ingress_cidr_to_ports, count.index)}"
  protocol                 = "${element(var.ingress_cidr_protocols, count.index)}"
  cidr_blocks              = ["${element(var.ingress_cidr_blocks, count.index)}"]
  security_group_id        = "${aws_security_group.this.id}"
  description              = "${element(var.ingress_cidr_descriptions, count.index)}"
}

## Security Group Ingress with SGID ##
resource "aws_security_group_rule" "ingress-sgid" {
  count                    = "${length(var.ingress_sgid_from_ports)}"
  type                     = "ingress"
  from_port                = "${element(var.ingress_sgid_from_ports, count.index)}"
  to_port                  = "${element(var.ingress_sgid_to_ports, count.index)}"
  protocol                 = "${element(var.ingress_sgid_protocols, count.index)}"
  source_security_group_id = "${element(var.source_security_group_id, count.index)}"
  security_group_id        = "${aws_security_group.this.id}"
  description              = "${element(var.ingress_sgid_descriptions, count.index)}"
}

## Security Group Egress with CIDR ##
resource "aws_security_group_rule" "egress" {
  type                     = "egress"
  from_port                = "${element(var.egress_cidr_from_ports, count.index)}"
  to_port                  = "${element(var.egress_cidr_to_ports, count.index)}"
  protocol                 = "${element(var.egress_cidr_protocols, count.index)}"
  cidr_blocks              = ["${element(var.egress_cidr_blocks, count.index)}"]
  security_group_id        = "${aws_security_group.this.id}"
  description              = "${element(var.egress_cidr_descriptions, count.index)}"
}
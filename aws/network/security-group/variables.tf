variable "env" {
  description = "Environment"
  default     = ""
}

variable "name" {
  description = "The Name of the Security Group"
  default     = ""
}

variable "description" {
  description = "The Description of the Security Group"
  default     = ""
}

variable "vpc_id" {
  description = "The ID of the VPC this security group will belong to"
  default     = ""
}

variable "ingress_cidr_from_ports" {
  description = "List of all the starting ports of ingress cidr rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_cidr_to_ports" {
  description = "List of all the ending ports of ingress cidr rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_cidr_protocols" {
  description = "List of all protocols for ingress cidr rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "List of all cidr blocks for ingress cidr rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_cidr_descriptions" {
  description = "List of all cidr descriptions for ingress cidr rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_sgid_from_ports" {
  description = "List of all the starting ports of ingress sgid rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_sgid_to_ports" {
  description = "List of all the ending ports of ingress sgid rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_sgid_protocols" {
  description = "List of all protocols for ingress sgid rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "source_security_group_id" {
  description = "List of all source security group ids for ingress sgid rules, order should be maintained"
  type        = "list"
  default     = []
}

variable "ingress_sgid_descriptions" {
  description = "List of all sgid descriptions for ingress sgid rules, order should be maintained"
  type        = "list"
  default     = []
}


variable "egress_cidr_from_ports" {
  description = "List of all the starting ports of egress cidr rules, order should be maintained"
  type        = "list"
  default     = [0]
}

variable "egress_cidr_to_ports" {
  description = "List of all the ending ports of egress cidr rules, order should be maintained"
  type        = "list"
  default     = [65535]
}

variable "egress_cidr_protocols" {
  description = "List of all protocols for egress cidr rules, order should be maintained"
  type        = "list"
  default     = ["tcp"]
}

variable "egress_cidr_blocks" {
  description = "List of all cidr blocks for egress cidr rules, order should be maintained"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr_descriptions" {
  description = "List of all cidr descriptions for egress cidr rules, order should be maintained"
  type        = "list"
  default     = ["Allow All egress rule"]
}
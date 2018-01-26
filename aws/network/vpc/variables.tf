variable "env" {
  description = "Environment"
  default     = ""
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "terraform-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "enable_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom Domain name, DNS servers, NTP servers"
  default     = false
}

variable "domain_name" {
  description = "Specifies DNS name for DHCP options set"
  default     = ""
}

variable "domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided"
  type        = "list"
  default     = ["AmazonProvidedDNS"]
}

variable "ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set"
  type        = "list"
  default     = []
}

variable "enable_internet_gateway" {
  description = "Should be true if you want to enable Internet Gateway and create a public route table using this igw"
  default     = false
}
## Usage
```
module "myvpc" {
  source                  = "/path/to/terraform-modules/aws/network/vpc"
  env                     = "prod"
  aws_region              = "ap-south-1"
  vpc_name                = "terraform"
  vpc_cidr                = "10.1.0.0/16"
  public_subnets          = ["10.1.1.0/24","10.1.2.0/24"]
  private_subnets         = ["10.1.3.0/24","10.1.4.0/24"]
  enable_dhcp_options     = true
  enable_internet_gateway = true
  enable_nat_gateway      = true
  domain_name             = "prod.terraform.internal"
}

output "vpc-id"   { value = "${module.myvpc.vpc_id}" }
output "vpc-cidr" { value = "${module.myvpc.vpc_cidr}" }
output "vpc-name" {value = "${module.myvpc.vpc_name}"}
output "vpc-default-route-table-id"   { value = "${module.myvpc.default_route_table_id}" }
output "vpc-default-security-group-id"   { value = "${module.myvpc.default_security_group_id}" }
output "vpc-internet-gateway-id"   { value = "${module.myvpc.internet_gateway_id}" }

output "vpc-private-subnets"   { value = "${module.myvpc.private_subnets}" }
output "vpc-private-subnets-cidr-blocks"   { value = "${module.myvpc.private_subnets_cidr_blocks}" }
output "vpc-public-subnets"   { value = "${module.myvpc.public_subnets}" }
output "vpc-public-subnets-cidr-blocks"   { value = "${module.myvpc.public_subnets_cidr_blocks}" }

output "vpc-public-route-table-ids"   { value = "${module.myvpc.public_route_table_ids}" }
output "vpc-private-route-table-ids"   { value = "${module.myvpc.private_route_table_ids}" }

output "vpc-nat-public-ips"   { value = "${module.myvpc.nat_public_ips}" }
output "vpc-natgw-ids"   { value = "${module.myvpc.natgw_ids}" }
```
## Output

```
Outputs:

vpc-cidr = 10.1.0.0/16
vpc-default-route-table-id = rtb-7f149***
vpc-default-security-group-id = sg-35b14***
vpc-id = vpc-0136e***
vpc-internet-gateway-id = igw-f4391***
vpc-name = prod-terraform-vpc
vpc-nat-public-ips = [
    52.66.***.20,
    13.126.**.224
]
vpc-natgw-ids = [
    nat-0ea4e8317****,
    nat-009f52848****
]
vpc-private-route-table-ids = [
    rtb-4a2ba***,
    rtb-70149***
]
vpc-private-subnets = [
    subnet-50a90***,
    subnet-95332***
]
vpc-private-subnets-cidr-blocks = [
    10.1.3.0/24,
    10.1.4.0/24,
]
vpc-public-route-table-ids = [
    rtb-ea2ba***
]
vpc-public-subnets = [
    subnet-74a60***,
    subnet-21332***
]
vpc-public-subnets-cidr-blocks = [
    10.1.1.0/24,
    10.1.2.0/24
]
```

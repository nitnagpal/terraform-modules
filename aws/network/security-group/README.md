## Usage
```
module "sg-cidr" {
  source                    = "path/to/terraform-modules/aws/network/security-group"
  env                       = "prod"
  name                      = "ssh-http-https"
  description               = "Local ssh http https access"
  vpc_id                    = "${module.vpc.vpc_id}"
  ingress_cidr_from_ports   = ["22","80","443"]
  ingress_cidr_to_ports     = ["22","80","443"]
  ingress_cidr_protocols    = ["tcp","tcp","tcp"]
  ingress_cidr_blocks       = ["10.0.0.0/8","10.0.0.0/8","10.0.0.0/8"]
  ingress_cidr_descriptions = ["Local SSH","Local HTTP","Local HTTPS"]
  ingress_sgid_from_ports   = [ ]
  ingress_sgid_to_ports     = [ ]
  ingress_sgid_protocols    = [ ]
  ingress_sgid_descriptions = [ ]
  source_security_group_id  = [ ]
}
```
## Output

| Type   |Protocol   |Port Range   |Source      |Description   |
|:------:|:---------:|:-----------:|:----------:|:------------:|
| SSH   | TCP        | 22          | 10.0.0.0/8 | Local SSH    |
| HTTP  | TCP        | 80          | 10.0.0.0/8 | Local HTTP   |
| HTTPS | TCP        |443          | 10.0.0.0/8 | Local HTTPS  |

## Usage
```
module "sg-sgid" {
  source                    = "../../../../../terraform-modules/aws/network/security-group"
  env                       = "${var.env}"
  name                      = "http-https"
  description               = "Local http https access"
  vpc_id                    = "${module.vpc.vpc_id}"
  ingress_cidr_from_ports   = ["80","443"]
  ingress_cidr_to_ports     = ["80","443"]
  ingress_cidr_protocols    = ["tcp","tcp"]
  ingress_cidr_blocks       = ["10.0.0.0/8","10.0.0.0/8"]
  ingress_cidr_descriptions = ["Local HTTP","Local HTTPS"]
  ingress_sgid_from_ports   = ["8000"]
  ingress_sgid_to_ports     = ["9000"]
  ingress_sgid_protocols    = ["tcp"]
  ingress_sgid_descriptions = ["Access from sg-cidr security group"]
  source_security_group_id  = ["${module.sg-cidr.security_group_id}"]
}
```
## Output

| Type            |Protocol   |Port Range   |Source                                |Description   |
|:---------------:|:---------:|:-----------:|:------------------------------------:|:------------:|
| HTTP            | TCP       | 80          | 10.0.0.0/8                           | Local HTTP   |
| HTTPS           | TCP       | 443         | 10.0.0.0/8                           | Local HTTPS  |
| Custom TCP Rule | TCP       | 8000 - 9000 | sg-65b3410e (prod-ssh-http-https-sg) | Access from sg-cidr security group |

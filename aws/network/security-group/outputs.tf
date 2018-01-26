output "security_group_id" {
  description = "The ID of the Security Group"
  value       = "${aws_security_group.this.id}"
}

output "security_group_name" {
  description = "The Name of the Security Group"
  value       = "${aws_security_group.this.name}"
}

output "security_group_ingress_rules" {
  description = "The ingress rules of the Security Group"
  value       = "${aws_security_group.this.ingress}"
}

output "security_group_egress_rules" {
  description = "The egress rules of the Security Group"
  value       = "${aws_security_group.this.egress}"
}
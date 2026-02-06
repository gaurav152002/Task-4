variable "env" {}
variable "vpc_id" {}
variable "ec2_instance_id" {}
variable "public_subnet_ids" {
  type = list(string)
}


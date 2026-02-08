#===== security group for EC2 instance =====#
variable "vpc_id" {}
variable "env" {}
variable "instance_type" {}
variable "subnet_id" {}

# ===== ALB Security Group ID =====
variable "alb_sg_id" {
  description = "Security group ID of ALB"
  type        = string
}







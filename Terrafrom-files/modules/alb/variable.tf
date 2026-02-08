
# ===== Environment name (dev, prod, etc.) =====
variable "env" {
  description = "Environment name"
  type        = string
}

# ===== VPC where ALB and target group are created =====
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# ===== Public subnets for ALB =====
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

# ===== EC2 instance ID to register in target group =====
variable "ec2_instance_id" {
  description = "EC2 instance ID running Strapi"
  type        = string
}

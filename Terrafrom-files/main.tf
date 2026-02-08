#===== vpc module =====#
module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    env = var.env
}

#===== EC2 module =====#
module "ec2" {
  source = "./modules/ec2"

  env           = var.env
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id

  # Using private subnet for EC2 instance
  subnet_id = module.vpc.private_subnet_id

  # Allow EC2 to accept traffic only from ALB
  alb_sg_id = module.alb.alb_sg_id
}
# ===== Application Load Balancer Module =====
module "alb" {
  source = "./modules/alb"

  env               = var.env
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  ec2_instance_id   = module.ec2.instance_id
}


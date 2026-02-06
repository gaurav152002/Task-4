#===== vpc module =====#
module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    env = var.env
}

#===== EC2 module =====#
module "ec2" {
    source = "./modules/EC2"
    env = var.env
    instance_type = var.instance_type
    vpc_id = module.vpc.vpc_id
    subnet_id = module.vpc.private_subnet_id
}

#===== ALB module =====#
module "alb" {
  source            = "./modules/alb"
  env               = var.env
  vpc_id            = module.vpc.vpc_id
  ec2_instance_id   = module.ec2.instance_id
  
  public_subnet_ids = [
  module.vpc.public_subnet_id,
  module.vpc.public_subnet_2_id
]

}

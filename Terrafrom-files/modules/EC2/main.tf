#===== security group for EC2 instance =====#
resource "aws_security_group" "ec2_sg" {
    vpc_id = var.vpc_id    

    # ===== Allow Strapi traffic only from ALB =====
    ingress {
        from_port       = 1337
        to_port         = 1337
        protocol        = "tcp"
        security_groups = [var.alb_sg_id]       
        }

     egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
    tags = {
        Name = "dev--ec2 security group"
    }
}

#===== EC2 instance =====#
resource "aws_instance" "this" {
    ami = "ami-0b6c6ebed2801a5cb"
    instance_type = var.instance_type 
    subnet_id = var.subnet_id

    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    
    user_data = file("${path.module}/userdata.sh")

    root_block_device {
    volume_size = 20
    volume_type = "gp3"
    }

    #===== Temperory adjust =====#

    tags = {
        Name = "Strapi-ec2-instance"
    }
}
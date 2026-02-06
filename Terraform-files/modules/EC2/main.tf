#===== security group for EC2 instance =====#
resource "aws_security_group" "ec2_sg" {
    vpc_id = var.vpc_id  

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
        }
    ingress {
        from_port = 1337
        to_port = 1337
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
        }    
     egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }
    tags = {
        Name = "${var.env}--ec2 security group"
    }
}

#===== EC2 instance =====#
resource "aws_instance" "this" {
    ami = "ami-0b6c6ebed2801a5cb"
    instance_type = var.instance_type 
    subnet_id = var.subnet_id

    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    
    user_data = file("${path.module}/userdata.sh")

    tags = {
        Name = "Strapi-ec2-instance"
    }
}
resource "aws_security_group" "sg" {
  name = "Terraform-sec-grp"
  description = "Allow HTTP and SSH traffic via Terraform"

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-SG"
  }
}



resource "aws_instance" "myec2" {
    ami = "ami-062f0cc54dbfd8ef1"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    key_name = "april24"
    tags = {
      Name = "New server-1"
    }
  
}
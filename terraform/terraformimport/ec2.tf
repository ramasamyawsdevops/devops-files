resource "aws_instance" "myser1" {
  ami             = "ami-0af9569868786b23a"
  instance_type   = "t2.micro"
  key_name        = "may17"
  security_groups = ["linux-sg"]
  availability_zone = "ap-south-1b"

  tags = {
    Name = "terraform-server"
  }
  
}
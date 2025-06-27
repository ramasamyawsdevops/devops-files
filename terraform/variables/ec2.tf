resource "aws_instance" "web" {
  ami             = var.ami
  instance_type   = var.type
  key_name        = var.key
  security_groups = var.sg
  availability_zone = var.zone

  tags = {
    Name = var.tags
  }
}

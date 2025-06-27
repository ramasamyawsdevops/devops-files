resource "aws_instance" "webserver" {
  ami           = var.amiid
  instance_type = var.machinetype
  key_name      = var.keyname
  security_groups = var.sgname

  tags = {
    Name = var.mytag
  }
}
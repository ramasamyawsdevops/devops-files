resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = var.key
  vpc_security_group_ids = var.sg
  availability_zone      = var.zone

  user_data = <<-EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Name = var.tags
  }
}

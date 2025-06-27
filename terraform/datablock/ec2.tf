provider "aws" {
  region = "us-east-2"  # Update as needed
}

data "aws_ami" "login_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["login"]  # Your AMI name from the screenshot
  }

  owners = ["045900906501"]  # Your AWS account ID
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.login_ami.id
  instance_type = "t2.micro"
  key_name = "may12"
  security_groups = [ "linux-sg" ]

  tags = {
    Name = "login-instance"
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "192.168.0.0/16"
    instance_tenancy = "default"
    tags = {
      Name="MY_VPC"
    }
  
}

resource "aws_subnet" "subnetpublic" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "ap-south-1a"

    tags = {
      Name = "subnet-public"
    }  
}

resource "aws_subnet" "subnetprivate" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "ap-south-1b"

    tags = {
      Name = "subnet-private"
    }  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id

    tags={
        Name="MY_IGW"
    }  
}

resource "aws_route_table" "routetablepublic" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name="RT-public"
    }
  
}

resource "aws_route_table_association" "routetable-a-public" {
    subnet_id = aws_subnet.subnetpublic.id
    route_table_id = aws_route_table.routetablepublic.id  
}

resource "aws_eip" "myeip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = aws_eip.myeip.id
    subnet_id = aws_subnet.subnetpublic.id

    tags = {
      Name="MY_NGW"
    }
  
}

resource "aws_route_table" "routetableprivate" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
    }
  tags = {
    Name="RT-private"
  }
}

resource "aws_route_table_association" "routetable-a-private" {
    subnet_id = aws_subnet.subnetprivate.id
    route_table_id = aws_route_table.routetableprivate.id  
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "MY-VPC-SG"
  }
}

resource "aws_instance" "web-pub" {
  ami             = "ami-0f1dcc636b69a6438"
  instance_type   = "t2.micro"
  subnet_id = aws_subnet.subnetpublic.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name        = "april24"
  associate_public_ip_address = true

  tags = {
    Name = "web-pub"
    Env  = "Production"
  }
}
resource "aws_instance" "web-pvt" {
  ami             = "ami-0f1dcc636b69a6438"
  instance_type   = "t2.micro"
  subnet_id = aws_subnet.subnetprivate.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name        = "april24"

  tags = {
    Name = "web-pvt"
    Env  = "Production"
  }
}

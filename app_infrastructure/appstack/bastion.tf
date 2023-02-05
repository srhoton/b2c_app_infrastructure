resource "aws_security_group" "b2c_bastion_inbound" {
  name = "b2c_bastion_${var.feature}_inbound"
  vpc_id = data.aws_vpc.b2c_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0 
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "b2c_bastion_${var.feature}_inbound"
  }
}

resource "aws_instance" "bastion_instance" {
  ami = "ami-00874d747dde814fa"
  instance_type = "t3.micro"
  associate_public_ip_address = true

  subnet_id = data.aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.b2c_bastion_inbound.id]
  key_name = "b2c"

  tags = {
    Name = "b2c_bastion_${var.feature}"
  }
}

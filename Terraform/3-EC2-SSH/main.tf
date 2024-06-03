provider "aws" {
    region  = "us-east-2"
}

resource "aws_vpc" "terra_vpc" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "terra_vpc"
    }
}

resource "aws_subnet" "terra_subnet" {
    vpc_id = aws_vpc.terra_vpc.id
    cidr_block = "10.0.1.0/24"

    tags = {
        Name = "terra_subnet"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.terra_vpc.id
}

resource "aws_route_table" "rg" {
    vpc_id = aws_vpc.terra_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
}

resource "aws_route_table_association" "my_subnet_association" {
    subnet_id      = aws_subnet.terra_subnet.id
    route_table_id = aws_route_table.rg.id
}

resource "aws_security_group" "allow_ssh" {
    name        = "allow_ssh"
    description = "Allow SSH inbound and outbound traffic"
    vpc_id      = aws_vpc.terra_vpc.id

    tags = {
        Name = "allow_ssh"
    }

  // Inbound rule allowing SSH traffic
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  // Allowing SSH traffic from any IP
    }

  // Outbound rule allowing all traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"  // This indicates all protocols
        cidr_blocks = ["0.0.0.0/0"]  // Allowing traffic to any IP
    }
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-keypair"  # Replace with your desired key pair name
  public_key = tls_private_key.my_key.public_key_openssh
}


resource "null_resource" "export_key" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "echo '${tls_private_key.my_key.private_key_pem}' > ./key.pem"
  }
}



#to create a key ssh-keygen -f '/home/oran/.ssh/my-keypair'
resource "aws_instance" "test_ec2_instance" {
    ami = "ami-0ca2e925753ca2fb4"  // Example AMI ID
    count = 3
    associate_public_ip_address = true
    instance_type = "t2.micro"
    key_name = aws_key_pair.my_key_pair.key_name  // Example key pair name
    security_groups = [aws_security_group.allow_ssh.id]  // Example security group ID
    tags = {
        Name = "test_ec2_instance"  // Example instance name
    }
    subnet_id = aws_subnet.terra_subnet.id  // Example subnet ID
}
output "public_ip" {
  value = [for instance in aws_instance.test_ec2_instance : instance.public_ip]
}

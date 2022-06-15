# Resource for primary VPC

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main VPC"
  }
}
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id  
  cidr_block = "10.0.1.0/24"
  availability_zone_id = "aps1-az1"
  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "IGW"
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "PublicRT"
  }
}

resource "aws_route" "PublicRT-Route" {

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  route_table_id         = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PublicAss" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.PublicRT.id

}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
 resource "aws_key_pair" "deployer1" {
   key_name   = "Key_Pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5Y/wM4qtT1tYId4MdxQn4pNKbKvQm/8aiDj2YDQLfTRTAuKrc2Rf7TnNE7dfvf+DYscf2W5C9Km6H/HfVhCZv7qJu8k4r7iHwO28UrC/unU5nm6y6bJfKdyEZ0q8RswXkP5nUJ6zZjVeDrJT6U/4OIlEFPCabnBFahy+10zQ+Q16qGM8BxVOoGvOIJ0KtKbTr+LBT2t9qG1t8d5gcglyknj1jZ0AqSbeTmcdRWGkidD1xjOzVIzNeLbHtn67OpBlszwxnEbZMSWxTsAthxWTpmCktue57EuTJyOeWByAEWwyw202X0SOwUJDGFHdi5QVRbZL4eHeAQi6url4HMEK/B8XM28VkxN6KIrTwQSNY06sGIJqLoHqIgUxoqFmYmKs0Wr5EUDZLVxkWcwoGSGeybPQRRLditv1F/zL6I1WqpPfnqK83jxlo8dBJU6gS8w0LOu7uGxX0qONG+Z/N2BTFiNtiBsdRkXpk2s2pfGa3wa63/MAdkwep+jaEZNzvNRk= mounika@ubuntu20"
}
resource "aws_instance" "public_instance" {
  ami                         = "${var.ami_id}"
  vpc_security_group_ids      = ["${aws_security_group.allow_ssh.id}"]
  instance_type               = "${var.instance_type}"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = "true"
  key_name                    = "Key_Pair"
  tags = {
    Name = "public_instance"
  }
}

# Resource for Second VPC

resource "aws_vpc" "test-vpc" {
  provider   = aws.peer
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "test-vpc"
  }
}
resource "aws_subnet" "public1" {
  provider   = aws.peer
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "Public1 subnet"
  }
}
resource "aws_internet_gateway" "igw1" {
  provider = aws.peer
  vpc_id   = aws_vpc.test-vpc.id
  tags = {
    Name = "IGW1"
  }
}
resource "aws_route_table" "PublicRT1" {
  provider = aws.peer
  vpc_id   = aws_vpc.test-vpc.id
  tags = {
    Name = "PublicRT1"
  }
}

resource "aws_route" "PublicRT1-Route" {
  provider               = aws.peer
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw1.id
  route_table_id         = aws_route_table.PublicRT1.id
}
resource "aws_route_table_association" "PublicAss1" {
  provider       = aws.peer
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.PublicRT1.id

}

resource "aws_security_group" "allow_ssh1" {
  provider    = aws.peer
  name        = "allow_ssh1"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh1"
  }
}

 resource "aws_key_pair" "deployer" {
   provider   =  aws.peer
   key_name   = "Key_Pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5Y/wM4qtT1tYId4MdxQn4pNKbKvQm/8aiDj2YDQLfTRTAuKrc2Rf7TnNE7dfvf+DYscf2W5C9Km6H/HfVhCZv7qJu8k4r7iHwO28UrC/unU5nm6y6bJfKdyEZ0q8RswXkP5nUJ6zZjVeDrJT6U/4OIlEFPCabnBFahy+10zQ+Q16qGM8BxVOoGvOIJ0KtKbTr+LBT2t9qG1t8d5gcglyknj1jZ0AqSbeTmcdRWGkidD1xjOzVIzNeLbHtn67OpBlszwxnEbZMSWxTsAthxWTpmCktue57EuTJyOeWByAEWwyw202X0SOwUJDGFHdi5QVRbZL4eHeAQi6url4HMEK/B8XM28VkxN6KIrTwQSNY06sGIJqLoHqIgUxoqFmYmKs0Wr5EUDZLVxkWcwoGSGeybPQRRLditv1F/zL6I1WqpPfnqK83jxlo8dBJU6gS8w0LOu7uGxX0qONG+Z/N2BTFiNtiBsdRkXpk2s2pfGa3wa63/MAdkwep+jaEZNzvNRk= mounika@ubuntu20"
}

resource "aws_instance" "public_instance1" {
  provider                    = aws.peer
  ami                         = var.ami_id1
  vpc_security_group_ids      = ["${aws_security_group.allow_ssh1.id}"]
  instance_type               = "${var.instance_type}"
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = "true"
  key_name                    = "Key_Pair"
  tags = {
    Name = "public_instance1"
  }
}

data "aws_caller_identity" "peer" {
  provider = aws.peer
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "vpcpeeringdemo" {
  vpc_id      = aws_vpc.main.id
  peer_vpc_id = aws_vpc.test-vpc.id
  peer_region = "us-east-2"
  auto_accept = false
  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peering" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeeringdemo.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
resource "aws_route" "vpcpeeringaccepterroute" {
  provider                  = aws.peer
  route_table_id            = aws_route_table.PublicRT1.id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeeringdemo.id
}

resource "aws_route" "vpcpeeringrequesterroute" {
  route_table_id            = aws_route_table.PublicRT.id
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.vpcpeeringdemo.id
}


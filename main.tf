#----------------------------------------------------------------
#VPC
resource "aws_vpc" "VPC-MS" {
  tags = {
    Name="VPC-MS"
  }

  cidr_block = "192.168.0.0/16"
}

#----------------------------------------------------------------
#Subnet 1
resource "aws_subnet" "Subnet-1-MS" {
  tags = {
    name="Subnet-1-MS"
  }

  vpc_id = aws_vpc.VPC-MS.id
  cidr_block = "192.168.0.0/24"
}

#----------------------------------------------------------------
#Subnet 2
resource "aws_subnet" "Subnet-2-MS" {
  tags = {
    name="Subnet-2-MS"
  }

  vpc_id = aws_vpc.VPC-MS.id
  cidr_block = "192.168.1.0/24"
}

#----------------------------------------------------------------
#Route table 
resource "aws_route_table" "Route-Table-MS" {
  tags = {
    name="Route-Table-MS"
  }

  vpc_id = aws_vpc.VPC-MS.id
}

# Associate Subnet 1 with Route Table
resource "aws_route_table_association" "Route-Table-Association-MS" {
    subnet_id      = aws_subnet.Subnet-1-MS.id
    route_table_id = aws_route_table.Route-Table-MS.id
}

# Associate Subnet 2 with Route Table
resource "aws_route_table_association" "Route-Table-Association-MS-2" {
    subnet_id      = aws_subnet.Subnet-2-MS.id
    route_table_id = aws_route_table.Route-Table-MS.id
}

#Internet gateway
  resource "aws_internet_gateway" "Internet-Gateway-MS" {
    vpc_id = aws_vpc.VPC-MS.id
  }

# Attach Internet gateway to Route Table
  resource "aws_route" "Route-to-Internet-Gateway-MS" {
    route_table_id        = aws_route_table.Route-Table-MS.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet-Gateway-MS.id
  }

#----------------------------------------------------------------
#Security group
resource "aws_security_group" "Security-Group-Allow-SSH-HTTP-MS" {
  tags = {
    name = "Security-Group-Allow-SSH-HTTP-MS"
  }

  vpc_id = aws_vpc.VPC-MS.id

  ingress{ #allow SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{ #allow HTTP
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{ #allow HTTPS
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

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------------------------------------------------------------
#Keypair
resource "tls_private_key" "Keypair-test" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "keypair" {
  key_name = "selfmade"
  public_key = tls_private_key.Keypair-test.public_key_openssh
}

#----------------------------------------------------------------
#Apache webserver 1
resource "aws_instance" "Ubuntu-Webserver-MS" {
  tags = {
  Name="Ubuntu-Webserver-MS"
  }

  ami = "ami-0d64bb532e0502c46"
  instance_type = "t2.micro"
  user_data = file("Apache-Userdata.sh")
  key_name = "selfmade"
  vpc_security_group_ids = [aws_security_group.Security-Group-Allow-SSH-HTTP-MS.id]
  subnet_id = aws_subnet.Subnet-1-MS.id

metadata_options { #needed for the user data to apply????
  http_endpoint = "enabled"
  http_tokens   = "optional"
  }
}

#----------------------------------------------------------------
#Apache webserver 2
resource "aws_instance" "Ubuntu-Webserver-2-MS" {
  tags = {
  Name="Ubuntu-Webserver-2-MS"
  }

  ami = "ami-0d64bb532e0502c46"
  instance_type = "t2.micro"
  user_data = file("Apache-Userdata.sh")
  vpc_security_group_ids = [aws_security_group.Security-Group-Allow-SSH-HTTP-MS.id]
  subnet_id = aws_subnet.Subnet-1-MS.id
  key_name = aws_key_pair.keypair.key_name

metadata_options { #needed for the user data to apply????
  http_endpoint = "enabled"
  http_tokens   = "optional"
  }
}


#----------------------------------------------------------------
#S3-bucket
resource "aws_s3_bucket" "Buckie" {
  tags = {
    name="buckie-the-bucket"
  }

  bucket = "buckie-the-bucket"
}
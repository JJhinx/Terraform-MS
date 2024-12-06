#Keypair
resource "tls_private_key" "Keypair-test" {
  algorithm = "RSA"
  rsa_bits = 2048
}
resource "aws_key_pair" "keypair" {
  key_name = "selfmade2"
  public_key = tls_private_key.Keypair-test.public_key_openssh
}

#output "privateIP" {
  #value = aws_instance.MySQL-server-MS.private_ip
#}

#----------------------------------------------------------------
#Apache webserver - MySQL server
resource "aws_instance" "Ubuntu-Webserver-MS" {
  tags = {
  Name="Ubuntu-Webserver-MS"
  }

  ami = "ami-0d64bb532e0502c46"
  instance_type = "t2.micro"
  #user_data = file("userdata/Apache-Userdata.sh")
  user_data = data.template_file.userdata-Apache-MS.rendered
  key_name = "selfmade2"
  vpc_security_group_ids = [aws_security_group.Security-Group-Allow-SSH-HTTP-MS.id]
  subnet_id = aws_subnet.Subnet-1-MS.id
  associate_public_ip_address = "true"

  iam_instance_profile = data.aws_iam_role.FullAccessToS3.name

metadata_options {
  http_endpoint = "enabled"
  http_tokens   = "optional"
  }

  count = 2
}

#---------------------------------------------------------------
resource "aws_instance" "MySQL-server-MS" {
  tags = {
  Name="MySQL-server-MS"
  }

  ami = "ami-0d64bb532e0502c46"
  instance_type = "t2.micro"
  #user_data = file("userdata/Mysql-Userdata.tpl")
  user_data = data.template_file.userdata-MySQL-MS.rendered
  key_name = "selfmade2"
  vpc_security_group_ids = [aws_security_group.Security-Group-Allow-SSH-HTTP-MS.id]
  subnet_id = aws_subnet.Subnet-3-MS.id

  private_ip = "192.168.2.200"
metadata_options {
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

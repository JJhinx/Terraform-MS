variable "region" {
  description = "sets the region variable to ireland"
  default = "eu-west-1"
}

variable "ssh_private_key_file" {
  default = "jenkins-aws.pem"
}

locals {
  ssh_private_key_content = file(var.ssh_private_key_file)
}
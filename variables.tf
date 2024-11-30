variable "region" {
  description = "sets the region variable to ireland"
  default = "eu-west-1"
}

variable "mysql_root_password" {
  default = "tryout"
  sensitive = true
}
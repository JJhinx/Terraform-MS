variable "region" {
  description = "sets the region variable to ireland"
  default = "eu-west-1"
}

variable "db_rootpw" {
  default = "tryout"
  sensitive = true
}


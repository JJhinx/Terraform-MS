provider "aws" {
  region = var.region
  #sets the provider to aws

  access_key = "no"
  secret_key = "no"

}

provider "tls" {
  
}

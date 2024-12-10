provider "aws" {
  region = var.region
  #sets the provider to aws
  profile = "default"
  
}

provider "tls" {
  
}

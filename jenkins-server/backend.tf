terraform {
  backend "s3" {
    bucket = "cicd-terraform-server"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}

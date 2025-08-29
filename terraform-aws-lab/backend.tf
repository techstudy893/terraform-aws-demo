terraform {
  backend "s3" {
    bucket = "terraform-state-s3-987654321"
    key    = "terraform-aws-lab/state/terraform.tfstate"
    region = "eu-west-2"
    profile = "techstudy"
  }
}

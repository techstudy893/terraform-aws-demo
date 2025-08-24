module "vpc" {
  source      = "./modules/vpc"
  project     = var.project
  cidr_block  = "10.42.0.0/16"
  public_cidr = "10.42.1.0/24"
}

module "s3site" {
  source  = "./modules/s3site"
  project = var.project
}

module "web" {
  source             = "./modules/web"
  project            = var.project
  vpc_id             = module.vpc.vpc_id
  public_subnet_id   = module.vpc.public_subnet_id
  instance_count     = var.instance_count
  website_bucket     = module.s3site.bucket_name
  allowed_http_cidrs = ["0.0.0.0/0"]
  allowed_ssh_cidrs  = ["152.37.69.4/32"]
}






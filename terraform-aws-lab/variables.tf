variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "aws_profile" {
  type    = string
  default = "techstudy"
}


variable "project" {
  type    = string
  default = "yt-terraform-demo"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "bucket_names" {
  description = "extra buckets to show for_each"
  type        = set(string)
  default     = ["yt-demo-bucket-1", "yt-demo-bucket-2"]
}

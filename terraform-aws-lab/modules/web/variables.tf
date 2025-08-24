variable "project" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "website_bucket" {
  type = string
}

variable "allowed_http_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach HTTP"
  default     = ["0.0.0.0/0"]
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to SSH"
  default     = []
}

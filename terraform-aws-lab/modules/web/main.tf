data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"] # adjust if on ARM instances
  }
}

resource "aws_security_group" "web" {
  name        = "${var.project}-web-sg"
  description = "HTTP and SSH in"
  vpc_id      = var.vpc_id
  tags        = { Name = "${var.project}-web-sg" }
}

# HTTP (80)
resource "aws_vpc_security_group_ingress_rule" "http" {
  for_each          = toset(var.allowed_http_cidrs)
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "HTTP from ${each.value}"
}

# SSH (22)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each          = toset(var.allowed_ssh_cidrs)
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH from ${each.value}"
}

resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all
  description       = "Allow all egress"
}



# IAM role that can read from the S3 bucket
resource "aws_iam_role" "ec2" {
  name = "${var.project}-ec2-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_policy" "read_bucket" {
  name = "${var.project}-read-bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["s3:GetObject", "s3:ListBucket"],
      Resource = [
        "arn:aws:s3:::${var.website_bucket}",
        "arn:aws:s3:::${var.website_bucket}/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.read_bucket.arn
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project}-instance-profile"
  role = aws_iam_role.ec2.name
}

# Key pair (generated locally once)
resource "tls_private_key" "kp" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "kp" {
  key_name   = "${var.project}-key"
  public_key = tls_private_key.kp.public_key_openssh
}

resource "local_file" "pem" {
  content         = tls_private_key.kp.private_key_pem
  filename        = "${path.module}/../${var.project}.pem"
  file_permission = "0400"
}

locals {
  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx awscli
    echo "<h1>Hello from EC2 via Terraform</h1>" > /usr/share/nginx/html/index.html
    systemctl enable nginx
    systemctl start nginx
  EOF
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = aws_key_pair.kp.key_name
  user_data                   = local.user_data
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = true
  count                       = var.instance_count

  tags = {
    Name    = "${var.project}-web-${count.index}"
    Project = var.project
  }

  lifecycle {
    create_before_destroy = true
  }
}
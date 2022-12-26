data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}



resource "random_id" "lyrebird_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_instance" "theo_node" {
  count                  = var.instance_count
  instance_type          = var.instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_sg_id
  subnet_id              = var.sub_id[count.index]
  iam_instance_profile = "${aws_iam_instance_profile.case_profile.name}"
  user_data = <<-EOF
    #!/bin/bash
    set -ex
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  EOF 
  root_block_device {
    volume_size = var.vol_size

  }
    tags = {
      Name = "lyrebird-app-server"
  }
}




resource "aws_iam_role" "case_role" {
  name = "case_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      Name = "case_server_role"
  }
}



resource "aws_iam_instance_profile" "case_profile" {
  name = "case_profile"
  role = "${aws_iam_role.case_role.name}"
}


resource "aws_iam_role_policy" "case_policy" {
  name = "case_policy"
  role = "${aws_iam_role.case_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}




resource "aws_s3_bucket" "case_bucket" {
  bucket = var.bucket_name
  tags = {
    Name        = "case-bucket"
  }  

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD", "PUT"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}


resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.case_bucket.id
  acl    = "private"
}







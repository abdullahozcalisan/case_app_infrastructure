locals {
  sec_group = {
    public = {
      name        = "public_sg"
      description = "Pub-sub-sg"
      ingress = {
        ssh = {
          from        = 0
          to          = 0
          protocol    = -1
          cidr_blocks = [var.access_ip]

        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }
        https = {
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]

        }        
      }
    }
    priv = {
      name        = "priv_sg"
      description = "Priv-sub-sg-for-rds"
      ingress = {
        mysql = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [var.vpc_cidr]
        }
      }
    }

  }
}

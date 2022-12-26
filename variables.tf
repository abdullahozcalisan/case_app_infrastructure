variable "vpc_cidr" {
  default = "10.10.0.0/16"
}
variable "access_ip" {}

variable "region" {
  default = "us-east-1"
}

variable "lyreapp_instance_count" {
  default = 1
}
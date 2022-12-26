module "networking" {
  source          = "./networking"
  max_subnets     = 20
  priv_sub_count  = 1
  vpc_cidr        = var.vpc_cidr
  priv_cidrs      = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  pub_sub_count   = 1
  pub_sub_cidrs   = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  sec_group       = local.sec_group

}



module "compute" {
  source         = "./compute"
  instance_count = var.lyreapp_instance_count
  instance_type  = "t2.micro"
  vpc_sg_id      = [module.networking.pub_sec_gr]
  sub_id         = module.networking.pub_sub_id
  vol_size       = 10
  key_name       = "lyrebirdcase"
  bucket_name = "case-lyrebird-test-bucket-v1"
}

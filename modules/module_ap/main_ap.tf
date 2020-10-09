provider "aws" {
  alias  = "ap-provider"
  region = var.region
}

module "vault-cluster-ap" {
    source = "../sub-modules/vault_cluster"

    #Variables
    vpc_cidr = var.vpc_cidr
    random_id = var.random_id
    region = var.region

    vault_common_ca_cert = var.vault_common_ca_cert
    vault_common_ca_private_key = var.vault_common_ca_private_key

    vault_license = var.vault_license
    providers = {
      aws = aws.ap-provider
    }
}
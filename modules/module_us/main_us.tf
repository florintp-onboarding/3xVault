provider "aws" {
  alias  = "us-provider"
  region = var.region
}

module "vault-cluster-us" {
    source = "../sub-modules/vault_cluster"

    #Variables
    vpc_cidr = var.vpc_cidr
    random_id = var.random_id
    region = var.region

    vault_common_ca_cert = var.vault_common_ca_cert
    vault_common_ca_private_key = var.vault_common_ca_private_key

    vault_license = var.vault_license
    providers = {
      aws = aws.us-provider
    }
}
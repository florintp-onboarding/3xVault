variable "clusters" {
  type = map(object({
    region        = string
    vpc_cidr      = string
    vault_version = string
  }))

  description = "Defines all Vault clusters, map of custom objects"
}

variable "userinfra" {
  type  = string
  description = "User prefixing the infrastructure"
}

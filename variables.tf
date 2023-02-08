variable "clusters" {
  type = map(object({
    region         = string
    vpc_cidr       = string
    vault_version  = string
    vault_ec2_type = string
  }))

  description = "Defines all Vault clusters, map of custom objects"
}

variable "userinfra" {
  type        = string
  description = "User prefixing the infrastructure"
}

variable "myip" {
  type        = string
  description = "MYIP for securing access to SSH"
}

variable "mytimezone" {
  type        = string
  description = "TIMEZONE for infrastructure"
}


resource "random_pet" "env" {
  length    = 1
  separator = "-"
  prefix = var.userinfra
}

data "template_cloudinit_config" "myhost" {

  for_each = local.availability_zones_sliced # Each EC2 in the cluster needs different cloud-init

  gzip          = true
  base64_encode = true
  # This part is for setting hostname adds Hashicorp repo and installs Vault
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../templates/cloud_init_templates/cloud-config.yml", {
      hostname = "vault-${var.region}-${each.key}-${var.random_id}"
    })
  }
  # Fixing Systemd Unit file because of "Unknown lvalue 'StartLimitIntervalSec' in section 'Unit'"
  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/../templates/vault_config/systemd_vault.sh.tmpl")
  }
  # Vault config
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/../templates/vault_config/vault.sh.tmpl", {
      kms_key_id = aws_kms_key.vault.id
      region     = var.region
      log_level  = var.log_level
      node_id    = "vault-${var.region}-${each.key}-${var.random_id}"
    })
  }
  # Uploading the Vault TLS cert and private key for the listner
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../templates/vault_config/tls_cert.yml.tmpl", {
      vault_tls_cert = base64encode(tls_locally_signed_cert.vault_cert_sign[each.key].cert_pem)
      vault_tls_private_key = base64encode(tls_private_key.vault_tls_rsa_key[each.key].private_key_pem)
    })
  }
  # Using cc_cert to add the self-signed Vault CA
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/../templates/vault_config/vault_common_ca.yml.tmpl", {
      vault_common_ca = indent(6, chomp(var.vault_common_ca_cert))
    })
  }
  # Provides host keys for the EC2
  part {
    content_type = "text_cloud-config"
    content = templatefile("${path.module}/../templates/cloud_init_templates/cloud-config-ssh-keys.yml.tmpl", {
      keys = [
        for k in tls_private_key.host[*] : {
          # adding four spaces in front of the all lines of the private key and trimming tailing newlines chars
          private = indent(4, chomp(k.private_key_pem))
          # trimming tailing newlines chars
          public    = chomp(k.public_key_openssh)
          algorithm = lower(k.algorithm)
        }
      ]
    })
  }
}


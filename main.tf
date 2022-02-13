/*
  Generate CA key and CA certificate
*/
resource "tls_private_key" "ca_key" {
  count = var.generate_cert_sign_request_only ? 0 : 1

  algorithm   = var.tls_private_key_algorithm
  ecdsa_curve = var.tls_private_key_algorithm == "ECDSA" ? var.tls_private_key_ecdsa_curve : null
  rsa_bits    = var.tls_private_key_algorithm == "RSA" ? var.tls_private_key_rsa_bits : null
}

resource "tls_self_signed_cert" "ca_cert" {
  count = var.generate_cert_sign_request_only ? 0 : 1

  key_algorithm   = tls_private_key.ca_key[0].algorithm
  private_key_pem = tls_private_key.ca_key[0].private_key_pem

  subject {
    common_name         = trimprefix(var.tls_cert_subject["common_name"], "*.")
    organization        = lookup(var.tls_cert_subject, "organization", null)
    organizational_unit = lookup(var.tls_cert_subject, "organizational_unit", null)
    locality            = lookup(var.tls_cert_subject, "locality", null)
    province            = lookup(var.tls_cert_subject, "province", null)
    country             = lookup(var.tls_cert_subject, "country", null)
  }

  validity_period_hours = var.tls_cert_validity_period_hours
  allowed_uses          = distinct(concat(var.tls_cert_allowed_uses, ["cert_signing"]))
  is_ca_certificate     = true
  early_renewal_hours   = var.tls_cert_early_renewal_hours
  set_subject_key_id    = var.tls_cert_set_subject_key_id
}

/*
  Generate certificate key and certificate signing request
*/
resource "tls_private_key" "cert_key" {
  algorithm   = var.tls_private_key_algorithm
  ecdsa_curve = var.tls_private_key_algorithm == "ECDSA" ? var.tls_private_key_ecdsa_curve : null
  rsa_bits    = var.tls_private_key_algorithm == "RSA" ? var.tls_private_key_rsa_bits : null
}

resource "tls_cert_request" "cert_request" {
  key_algorithm   = tls_private_key.cert_key.algorithm
  private_key_pem = tls_private_key.cert_key.private_key_pem

  subject {
    common_name         = var.tls_cert_subject["common_name"]
    organization        = lookup(var.tls_cert_subject, "organization", null)
    organizational_unit = lookup(var.tls_cert_subject, "organizational_unit", null)
    locality            = lookup(var.tls_cert_subject, "locality", null)
    province            = lookup(var.tls_cert_subject, "province", null)
    country             = lookup(var.tls_cert_subject, "country", null)
  }

  dns_names    = var.tls_cert_dns_names
  ip_addresses = var.tls_cert_ip_addresses
  uris         = var.tls_cert_uris
}

/*
  Generate signed certificate from generated CA and CSR
*/
resource "tls_locally_signed_cert" "cert_signed" {
  count = var.generate_cert_sign_request_only ? 0 : 1

  cert_request_pem      = tls_cert_request.cert_request.cert_request_pem
  ca_key_algorithm      = tls_private_key.ca_key[0].algorithm
  ca_private_key_pem    = tls_private_key.ca_key[0].private_key_pem
  ca_cert_pem           = tls_self_signed_cert.ca_cert[0].cert_pem
  validity_period_hours = var.tls_cert_validity_period_hours
  allowed_uses          = var.tls_cert_allowed_uses
  is_ca_certificate     = false
  early_renewal_hours   = var.tls_cert_early_renewal_hours
  set_subject_key_id    = var.tls_cert_set_subject_key_id
}

/*
  Generate certificates and keys as local files
*/
resource "local_file" "ca_crt" {
  count    = var.generate_certs_keys_as_local_files && !var.generate_cert_sign_request_only ? 1 : 0
  content  = tls_self_signed_cert.ca_cert[0].cert_pem
  filename = "./certs/ca-cert.pem"
}

resource "local_file" "ca_key" {
  count    = var.generate_certs_keys_as_local_files && !var.generate_cert_sign_request_only ? 1 : 0
  content  = tls_private_key.ca_key[0].private_key_pem
  filename = "./certs/ca-key.pem"
}

resource "local_file" "cert_request" {
  count    = var.generate_certs_keys_as_local_files ? 1 : 0
  content  = tls_cert_request.cert_request.cert_request_pem
  filename = "./certs/cert-request.pem"
}

resource "local_file" "cert_signed" {
  count    = var.generate_certs_keys_as_local_files && !var.generate_cert_sign_request_only ? 1 : 0
  content  = tls_locally_signed_cert.cert_signed[0].cert_pem
  filename = "./certs/cert-signed.pem"
}

resource "local_file" "cert_key" {
  count    = var.generate_certs_keys_as_local_files && !var.generate_cert_sign_request_only ? 1 : 0
  content  = tls_private_key.cert_key.private_key_pem
  filename = "./certs/cert-key.pem"
}

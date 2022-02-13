output "ca_cert_pem" {
  value = tls_self_signed_cert.ca_cert.cert_pem
}

output "cert_request_pem" {
  value = tls_cert_request.cert_request.cert_request_pem
}

output "cert_signed_pem" {
  value = tls_locally_signed_cert.cert_signed.cert_pem
}

output "ca_key_pem" {
  sensitive = true
  value     = tls_private_key.ca_key.private_key_pem
}

output "cert_key_pem" {
  sensitive = true
  value     = tls_private_key.cert_key.private_key_pem
}

output "ca_cert_pem" {
  value = tls_self_signed_cert.ca_cert.cert_pem
}

output "cert_request_pem" {
  value = tls_cert_request.cert_request.cert_request_pem
}

output "cert_signed_pem" {
  value = tls_locally_signed_cert.cert_signed.cert_pem
}

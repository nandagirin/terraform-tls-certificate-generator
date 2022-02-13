output "ca_cert_pem" {
  value       = base64encode(tls_self_signed_cert.ca_cert.cert_pem)
  description = "CA certificate pem file (base64 encoded)."
}

output "cert_request_pem" {
  value       = base64encode(tls_cert_request.cert_request.cert_request_pem)
  description = "Certificate signing request pem file (base64 encoded)."
}

output "cert_signed_pem" {
  value       = base64encode(tls_locally_signed_cert.cert_signed.cert_pem)
  description = "Signed certificate pem file (base64 encoded)."
}

output "ca_key_pem" {
  sensitive   = true
  value       = base64encode(tls_private_key.ca_key.private_key_pem)
  description = "CA key pem file (base64 encoded)."
}

output "cert_key_pem" {
  sensitive   = true
  value       = base64encode(tls_private_key.cert_key.private_key_pem)
  description = "Certificate key pem file (base64 encoded)."
}

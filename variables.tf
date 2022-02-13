variable "tls_private_key_algorithm" {
  type        = string
  description = "The name of the algorithm to use for the certificate key. Currently-supported values are RSA and ECDSA"
  default     = "ECDSA"
}

variable "tls_private_key_ecdsa_curve" {
  type        = string
  description = "When tls private key algorithm used is ECDSA, the name of the elliptic curve to use. May be any one of P224, P256, P384 or P521."
  default     = "P256"
}

variable "tls_private_key_rsa_bits" {
  type        = number
  description = "When tls private key used algorithm is RSA, the size of the generated RSA key in bits."
  default     = 2048
}

variable "tls_cert_subject" {
  type        = map(any)
  description = "The subject for which a certificate is being requested."
}

variable "tls_cert_validity_period_hours" {
  type        = number
  description = "The number of hours after initial issuing that the certificate will become invalid."
  // Default to 1 year
  default = 8766
}

variable "tls_cert_allowed_uses" {
  type        = list(string)
  description = "List of keywords each describing a use that is permitted for the issued certificate."
  default = [
    "cert_signing",
    "server_auth",
    "client_auth",
  ]
}

variable "tls_cert_early_renewal_hours" {
  type        = number
  description = "If set, the resource will consider the certificate to have expired the given number of hours before its actual expiry time."
  // Default to 1 month
  default = 730
}

variable "tls_cert_set_subject_key_id" {
  type        = bool
  description = "If true, the certificate will include the subject key identifier."
  default     = false
}

variable "tls_cert_dns_names" {
  type        = list(string)
  description = "List of DNS names for which a certificate is being requested."
  default     = []
}

variable "tls_cert_ip_addresses" {
  type        = list(string)
  description = "List of IP addresses for which a certificate is being requested."
  default     = []
}

variable "tls_cert_uris" {
  type        = list(string)
  description = "List of URIs for which a certificate is being requested."
  default     = []
}

variable "generate_certs_keys_as_local_files" {
  type        = bool
  description = "If true, Terraform will generate certificates and keys as local files in relative path ./certs."
  default     = false
}

variable "generate_cert_sign_request_only" {
  type        = bool
  description = "If true, Terraform will only generate certificate signing request resource."
  default     = false
}

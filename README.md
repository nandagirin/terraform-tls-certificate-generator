# Terraform TLS Certificate Generator Module

This module handles creation of TLS keys and certificates. This module will be useful for generating a self signed certificate or providing certificate signing request for requesting a TLS certificate from public CA provider. This module is also extensible, such as adding other Terraform resources to store the generated certificates and keys or creating JKS keystores.
The resources that this module will create are:
- CA private key
- CA certificate
- Certificate private key
- Certificate signing request
- Locally signed certificate

## Usage
Example usage to generate self signed certificate with RSA algorithm:
```hcl
module "tls" {
  source  = "nandagirin/certificate-generator/tls"
  version = "2.0.2"

  tls_private_key_algorithm = "RSA"
  tls_private_key_rsa_bits  = 2048
  tls_cert_subject          = {
    common_name = "*.somedomain.io"
  }
  tls_cert_dns_names        = ["*.somedomain.io"]
}
```

Example usage to generate only certificate signing request with ECDSA algorithm:
```hcl
module "tls" {
  source  = "nandagirin/certificate-generator/tls"
  version = "2.0.2"

  tls_private_key_algorithm   = "ECDSA"
  tls_private_key_ecdsa_curve = "P256"
  tls_cert_subject            = {
    common_name = "*.somedomain.io"
  }
  tls_cert_dns_names              = ["*.somedomain.io"]
  generate_cert_sign_request_only = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tls_private_key_algorithm | The name of the algorithm to use to generate the certificate key. Currently-supported values are RSA and ECDSA. | `string` | `ECDSA` | no |
| tls_private_key_ecdsa_curve | When tls private key algorithm used is ECDSA, the name of the elliptic curve to use. May be any one of P224, P256, P384 or P521. | `string` | `P256` | no |
| tls_private_key_rsa_bits | When tls private key used algorithm is RSA, the size of the generated RSA key in bits. | `number` | `2048` | no |
| tls_cert_subject | The subject for which a certificate is being requested. The map could be configured with these values: <br /> - common_name `string` <br /> - organization `string` <br /> - organizational_unit `string` <br /> - locality `string` <br /> - province `string` <br /> - country `string`  | `map` | - | yes |
| tls_cert_validity_period_hours | The number of hours after initial issuing that the certificate will become invalid. | `number` | `8766` | no |
| tls_cert_allowed_uses | List of keywords each describing a use that is permitted for the issued certificate. | `list` | `["cert_signing", "server_auth", "client_auth"]` | no |
| tls_cert_early_renewal_hours | If set, the resource will consider the certificate to have expired the given number of hours before its actual expiry time. | `number` | `730` | no |
| tls_cert_set_subject_key_id | If true, the certificate will include the subject key identifier. | `bool` | `false` | no |
| tls_cert_dns_names | List of DNS names for which a certificate is being requested. | `list` | `[]` | no |
| tls_cert_ip_addresses | List of IP addresses for which a certificate is being requested. | `list` | `[]` | no |
| tls_cert_uris | List of URIs for which a certificate is being requested. | `list` | `[]` | no |
| generate_certs_keys_as_local_files | If true, Terraform will generate certificates and keys as local files in relative path `./certs`. | `bool` | `false` | no |
| generate_cert_sign_request_only | If true, Terraform will only generate certificate signing request resources. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca_cert_pem | CA certificate pem file (base64 encoded). |
| cert_request_pem | Certificate signing request pem file (base64 encoded). |
| cert_signed_pem | Signed certificate pem file (base64 encoded). |
| ca_key_pem | CA key pem file (base64 encoded). |
| cert_key_pem | Certificate key pem file (base64 encoded). |

## References
- [Terraform TLS provider](https://registry.terraform.io/providers/hashicorp/tls/latest/docs)
- [Terraform TLS private key resource](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)
- [Terraform TLS self signed certificate resource](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert)
- [Terraform TLS certificate signing request resource](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request)
- [Terraform TLS locally signed certificate resource](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert)

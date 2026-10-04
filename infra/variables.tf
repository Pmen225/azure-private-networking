variable "location" {
  description = "Azure region for this lab."
  type        = string
  default     = "uksouth"
}

variable "admin_ssh_public_key" {
  description = "Existing OpenSSH public key for azureuser. Never supply a private key."
  type        = string

  validation {
    condition     = can(regex("^ssh-(rsa|ed25519) [A-Za-z0-9+/]+={0,3}( .*)?$", trimspace(var.admin_ssh_public_key)))
    error_message = "Provide an RSA or ED25519 OpenSSH public key."
  }
}

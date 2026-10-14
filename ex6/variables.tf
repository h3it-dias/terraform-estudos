variable "ambiente" {
  description = "Determina qual o ambiente em que o código está executando"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.ambiente)
    error_message = "Ambiente deve ser dev ou prod"
  }
}

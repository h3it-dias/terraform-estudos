variable "nome" {
  description = "Nome do serviço, usado no arquivo de configuração e na URL"
  type        = string
}

variable "cpu" {
  description = "Quantidade de vCPUs do serviço"
  type        = number
}

variable "memoria" {
  description = "Memória do serviço no formato do Cloud Run (ex.: 256Mi, 2Gi)"
  type        = string
}

variable "max_instancias" {
  description = "Número máximo de instâncias do serviço"
  type        = number
}

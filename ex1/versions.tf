terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.9.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.1"
    }
  }
}

resource "local_file" "arquivo_gaia" {
  filename = "ola_gaia.txt"
  content  = "Olá, GAIA!"
}
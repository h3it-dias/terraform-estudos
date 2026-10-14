resource "random_pet" "sufixo" {
  prefix = var.nome
}

resource "local_file" "configuracao" {
  filename = "servicos/${var.nome}.json"
  content = jsonencode({
    nome           = var.nome
    cpu            = var.cpu
    memoria        = var.memoria
    max_instancias = var.max_instancias
    url            = local.url
  })
}

locals {
  url = "https://${random_pet.sufixo.id}.run.app"
}

# O recurso se chamava local_file.config; o bloco moved avisa o Terraform
# que é o mesmo objeto, evitando destruir e recriar o arquivo.
moved {
  from = local_file.config
  to   = local_file.configuracao
}

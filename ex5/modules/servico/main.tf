resource "random_pet" "sufixo" {
  prefix = var.nome
}

resource "local_file" "config" {
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

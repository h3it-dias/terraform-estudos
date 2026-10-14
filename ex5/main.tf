locals {
  max_instancias = var.ambiente == "prod" ? 10 : 2
}

module "gaia_backend" {
  source = "./modules/servico"

  nome           = "gaia-backend"
  cpu            = 2
  memoria        = "2Gi"
  max_instancias = local.max_instancias
}

module "gaia_frontend" {
  source = "./modules/servico"

  nome           = "gaia-frontend"
  cpu            = 1
  memoria        = "256Mi"
  max_instancias = local.max_instancias
}

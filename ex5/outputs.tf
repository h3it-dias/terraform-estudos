output "urls" {
  description = "URLs dos serviços do GAIA"
  value = {
    backend  = module.gaia_backend.url
    frontend = module.gaia_frontend.url
  }
}
